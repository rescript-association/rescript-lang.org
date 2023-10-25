@val @scope("performance") external now: unit => float = "now"

module Lang = {
  type t =
    | Reason
    | OCaml
    | Res

  let toString = t =>
    switch t {
    | Res => "ReScript"
    | Reason => "Reason"
    | OCaml => "OCaml"
    }

  let toExt = t =>
    switch t {
    | Res => "res"
    | Reason => "re"
    | OCaml => "ml"
    }

  let decode = (json: Js.Json.t): t => {
    // open! Json.Decode
    switch json {
    | String("ml") => OCaml
    | String("re") => Reason
    | String("res") => Res
    | other => assert(false)
    // raise(DecodeError(`Unknown language "${other}"`))
    }
  }
}

module Version = {
  type t =
    | V1
    | V2
    | V3
    | UnknownVersion(string)

  // Helps finding the right API version
  let fromString = (apiVersion: string): t =>
    switch Js.String2.split(apiVersion, ".")->Belt.List.fromArray {
    | list{maj, min, ..._} =>
      let maj = Belt.Int.fromString(maj)
      let min = Belt.Int.fromString(min)

      switch (maj, min) {
      | (Some(maj), Some(_))
      | (Some(maj), None) =>
        if maj >= 1 {
          V1
        } else {
          UnknownVersion(apiVersion)
        }
      | _ => UnknownVersion(apiVersion)
      }
    | list{"2"} => V2
    | list{"3"} => V3
    | _ => UnknownVersion(apiVersion)
    }

  let toString = t =>
    switch t {
    | V1 => "1.0"
    | V2 => "2.0"
    | V3 => "3.0"
    | UnknownVersion(version) => version
    }

  let defaultTargetLang = Lang.Res

  let availableLanguages = t =>
    switch t {
    | V1 => [Lang.Reason, Res]
    | V2 | V3 => [Lang.Res]
    | UnknownVersion(_) => [Res]
    }
}

module LocMsg = {
  type t = {
    fullMsg: string,
    shortMsg: string,
    row: int,
    column: int,
    endRow: int,
    endColumn: int,
  }

  let decode = (json: Js.Json.t): t => {
    // open Json.Decode
    // {
    //   fullMsg: json->field("fullMsg", string, _),
    //   shortMsg: json->field("shortMsg", string, _),
    //   row: json->field("row", int, _),
    //   column: json->field("column", int, _),
    //   endRow: json->field("endRow", int, _),
    //   endColumn: json->field("endColumn", int, _),
    // }
    switch json {
    | Object(locDict) =>
      switch (
        locDict->Js.Dict.get("fullMsg"),
        locDict->Js.Dict.get("shortMsg"),
        locDict->Js.Dict.get("row"),
        locDict->Js.Dict.get("column"),
        locDict->Js.Dict.get("endRow"),
        locDict->Js.Dict.get("endColumn"),
      ) {
      | (
          Some(String(fullMsg)),
          Some(String(shortMsg)),
          Some(Number(row)),
          Some(Number(column)),
          Some(Number(endRow)),
          Some(Number(endColumn)),
        ) => {
          fullMsg,
          shortMsg,
          row: row->Belt.Float.toInt,
          column: column->Belt.Float.toInt,
          endRow: endRow->Belt.Float.toInt,
          endColumn: endColumn->Belt.Float.toInt,
        }
      | _ => assert(false)
      }
    | _ => assert(false)
    }
  }

  type prefix = [#W | #E]

  // Useful for showing errors in a more compact format
  let toCompactErrorLine = (~prefix: prefix, locMsg: t) => {
    let {row, column, shortMsg} = locMsg
    let prefix = switch prefix {
    | #W => "W"
    | #E => "E"
    }

    `[1;31m[${prefix}] Line ${row->Belt.Int.toString}, ${column->Belt.Int.toString}:[0m ${shortMsg}`
  }

  // Creates a somewhat unique id based on the rows / cols of the locMsg
  let makeId = t => {
    open Belt.Int
    toString(t.row) ++
    ("-" ++
    (toString(t.endRow) ++ ("-" ++ (toString(t.column) ++ ("-" ++ toString(t.endColumn))))))
  }

  let dedupe = (arr: array<t>) => {
    let result = Js.Dict.empty()

    for i in 0 to Js.Array.length(arr) - 1 {
      let locMsg = Js.Array2.unsafe_get(arr, i)
      let id = makeId(locMsg)

      // The last element with the same id wins
      result->Js.Dict.set(id, locMsg)
    }
    Js.Dict.values(result)
  }
}

module Warning = {
  type t =
    | Warn({warnNumber: int, details: LocMsg.t})
    | WarnErr({warnNumber: int, details: LocMsg.t}) // Describes an erronous warning

  let decode = (json: Js.Json.t): t => {
    // open! Json.Decode

    // let warnNumber = field("warnNumber", int, json)
    let details = LocMsg.decode(json)

    // field("isError", bool, json) ? WarnErr({warnNumber, details}) : Warn({warnNumber, details})

    switch json {
    | Object(warnDict) =>
      switch (warnDict->Js.Dict.get("isError"), warnDict->Js.Dict.get("warnNumber")) {
      | (Some(Boolean(isError)), Some(Number(warnNumber))) =>
        isError
          ? WarnErr({warnNumber: warnNumber->Belt.Float.toInt, details})
          : Warn({warnNumber: warnNumber->Belt.Float.toInt, details})
      | _ => assert(false)
      }
    | _ => assert(false)
    }
  }

  // Useful for showing errors in a more compact format
  let toCompactErrorLine = (t: t) => {
    let prefix = switch t {
    | Warn(_) => "W"
    | WarnErr(_) => "E"
    }

    let (row, column, msg) = switch t {
    | Warn({warnNumber, details})
    | WarnErr({warnNumber, details}) =>
      let {LocMsg.row: row, column, shortMsg} = details
      let msg = `(Warning number ${warnNumber->Belt.Int.toString}) ${shortMsg}`
      (row, column, msg)
    }

    `[1;31m[${prefix}] Line ${row->Belt.Int.toString}, ${column->Belt.Int.toString}:[0m ${msg}`
  }
}

module WarningFlag = {
  type t = {
    msg: string,
    warn_flags: string,
    warn_error_flags: string,
  }

  let decode = (json: Js.Json.t): t => {
    // open Json.Decode
    // {
    //   msg: field("msg", string, json),
    //   warn_flags: field("warn_flags", string, json),
    //   warn_error_flags: field("warn_error_flags", string, json),
    // }

    switch json {
    | Object(warnFlagDict) =>
      switch (
        warnFlagDict->Js.Dict.get("msg"),
        warnFlagDict->Js.Dict.get("warn_flags"),
        warnFlagDict->Js.Dict.get("warn_error_flags"),
      ) {
      | (Some(String(msg)), Some(String(warn_flags)), Some(String(warn_error_flags))) => {
          msg,
          warn_flags,
          warn_error_flags,
        }
      | _ => assert(false)
      }
    | _ => assert(false)
    }
  }
}

module TypeHint = {
  type position = {
    line: int,
    col: int,
  }

  type data = {
    start: position,
    end: position,
    hint: string,
  }

  type t =
    | TypeDeclaration(data)
    | Expression(data)
    | Binding(data)
    | CoreType(data)

  let decodePosition = (json: Js.Json.t) => {
    // open Json.Decode
    // {
    //   line: field("line", int, json),
    //   col: field("col", int, json),
    // }

    switch json {
    | Object(posDict) =>
      switch (posDict->Js.Dict.get("line"), posDict->Js.Dict.get("col")) {
      | (Some(Number(line)), Some(Number(col))) => {
          line: line->Belt.Float.toInt,
          col: col->Belt.Float.toInt,
        }
      | _ => assert(false)
      }
    | _ => assert(false)
    }
  }

  let decode = (json: Js.Json.t): t => {
    // open Json.Decode
    // let data = {
    //   start: field("start", decodePosition, json),
    //   end: field("end", decodePosition, json),
    //   hint: field("hint", string, json),
    // }

    let data = switch json {
    | Object(dataDict) =>
      switch (
        dataDict->Js.Dict.get("start"),
        dataDict->Js.Dict.get("end"),
        dataDict->Js.Dict.get("hint"),
      ) {
      | (Some(Object(startPosition)), Some(Object(endPosition)), Some(String(hint))) => {
          start: startPosition->Js.Json.object_->decodePosition,
          end: endPosition->Js.Json.object_->decodePosition,
          hint,
        }
      | _ => assert(false)
      }
    | _ => assert(false)
    }

    switch json {
    | Object(dict) =>
      switch dict->Js.Dict.get("kind") {
      | Some(String(kind)) =>
        switch kind {
        | "expression" => Expression(data)
        | "type_declaration" => TypeDeclaration(data)
        | "binding" => Binding(data)
        | "core_type" => CoreType(data)
        | other => assert(false)
        // raise(DecodeError(`Unknown kind "${other}" type hint`))
        }
      | _ => assert(false)
      }
    | _ => assert(false)
    }
  }
}

module CompileSuccess = {
  type t = {
    js_code: string,
    warnings: array<Warning.t>,
    type_hints: array<TypeHint.t>,
    time: float, // total compilation time
  }

  let decode = (~time: float, json: Js.Json.t): t => {
    // open Json.Decode
    // {
    //   js_code: field("js_code", string, json),
    //   warnings: field("warnings", array(Warning.decode), json),
    //   type_hints: withDefault([], field("type_hints", array(TypeHint.decode)), json),
    //   time,
    // }

    switch json {
    | Object(infoDict) =>
      switch (
        infoDict->Js.Dict.get("js_code"),
        infoDict->Js.Dict.get("warnings"),
        infoDict->Js.Dict.get("type_hints"),
      ) {
      | (Some(String(js_code)), Some(Array(warnings)), Some(Array(type_hints))) => {
          js_code,
          warnings: warnings->Js.Array2.map(warn => warn->Warning.decode),
          type_hints: type_hints->Js.Array2.map(hint => hint->TypeHint.decode),
          time,
        }
      | _ => assert(false)
      }
    | _ => assert(false)
    }
  }
}

module ConvertSuccess = {
  type t = {
    code: string,
    fromLang: Lang.t,
    toLang: Lang.t,
  }

  let decode = (json: Js.Json.t): t => {
    // open Json.Decode
    // {
    //   code: field("code", string, json),
    //   fromLang: field("fromLang", Lang.decode, json),
    //   toLang: field("toLang", Lang.decode, json),
    // }

    switch json {
    | Object(dict) =>
      switch (
        dict->Js.Dict.get("code"),
        dict->Js.Dict.get("fromLang"),
        dict->Js.Dict.get("toLang"),
      ) {
      | (Some(String(code)), Some(Object(fromLang)), Some(Object(toLang))) => {
          code,
          fromLang: fromLang->Js.Json.object_->Lang.decode,
          toLang: toLang->Js.Json.object_->Lang.decode,
        }
      | _ => assert(false)
      }
    | _ => assert(false)
    }
  }
}

module CompileFail = {
  type t =
    | SyntaxErr(array<LocMsg.t>)
    | TypecheckErr(array<LocMsg.t>)
    | WarningErr(array<Warning.t>)
    | WarningFlagErr(WarningFlag.t)
    | OtherErr(array<LocMsg.t>)

  let decode = (json: Js.Json.t): t => {
    switch json {
    | Object(data) =>
      switch (data->Js.Dict.get("type"), data->Js.Dict.get("errors")) {
      | (Some(String(kind)), Some(Array(errors))) =>
        switch kind {
        | "syntax_error" =>
          let locMsgs = errors->Js.Array2.map(err => err->LocMsg.decode)
          locMsgs->LocMsg.dedupe->SyntaxErr
        | "type_error" =>
          let locMsgs = errors->Js.Array2.map(err => err->LocMsg.decode)
          TypecheckErr(locMsgs)
        | "warning_error" =>
          let warnings = errors->Js.Array2.map(err => err->Warning.decode)
          WarningErr(warnings)
        | "other_error" =>
          let locMsgs = errors->Js.Array2.map(err => err->LocMsg.decode)
          OtherErr(locMsgs)
        | other =>
          Js.log(`Unknown type "${other}" in CompileFail result`)
          assert(false)
        }
      | (Some(String(kind)), _) if kind == "warning_flag_error" =>
        let warningFlag = WarningFlag.decode(json)
        WarningFlagErr(warningFlag)
      | _ => assert(false)
      }
    | _ => assert(false)
    }

    // open! Json.Decode

    // switch field("type", string, json) {
    // | "syntax_error" =>
    //   let locMsgs = field("errors", array(LocMsg.decode), json)
    //   // TODO: There seems to be a bug in the ReScript bundle that reports
    //   //       back multiple LocMsgs of the same value
    //   locMsgs->LocMsg.dedupe->SyntaxErr
    // | "type_error" =>
    //   let locMsgs = field("errors", array(LocMsg.decode), json)
    //   TypecheckErr(locMsgs)
    // | "warning_error" =>
    //   let warnings = field("errors", array(Warning.decode), json)
    //   WarningErr(warnings)
    // | "other_error" =>
    //   let locMsgs = field("errors", array(LocMsg.decode), json)
    //   OtherErr(locMsgs)

    // | "warning_flag_error" =>
    //   let warningFlag = WarningFlag.decode(json)
    //   WarningFlagErr(warningFlag)
    // | other => raise(DecodeError(`Unknown type "${other}" in CompileFail result`))
    // }
  }
}

module CompilationResult = {
  type t =
    | Fail(CompileFail.t) // When a compilation failed with some error result
    | Success(CompileSuccess.t)
    | UnexpectedError(string) // Errors that slip through as uncaught exceptions of the compiler bundle
    | Unknown(string, Js.Json.t)

  // TODO: We might change this specific api completely before launching
  let decode = (~time: float, json: Js.Json.t): t => {
    // open! Json.Decode

    // try switch field("type", string, json) {
    // | "success" => Success(CompileSuccess.decode(~time, json))
    // | "unexpected_error" => UnexpectedError(field("msg", string, json))
    // | _ => Fail(CompileFail.decode(json))
    // } catch {
    // | DecodeError(errMsg) => Unknown(errMsg, json)
    // }

    switch json {
    | Object(dict) =>
      switch dict->Js.Dict.get("type") {
      | Some(String("sucess")) => Success(CompileSuccess.decode(~time, json))
      | Some(String("unexpected_error")) =>
        UnexpectedError(dict->Js.Dict.unsafeGet("msg")->Js.Json.stringify)
      | _ => Fail(CompileFail.decode(json))
      }
    | _ => Unknown("Invalid JSON", json)
    }
  }
}

module ConversionResult = {
  type t =
    | Success(ConvertSuccess.t)
    | Fail({fromLang: Lang.t, toLang: Lang.t, details: array<LocMsg.t>}) // When a compilation failed with some error result
    | UnexpectedError(string) // Errors that slip through as uncaught exceptions within the playground
    | Unknown(string, Js.Json.t)

  let decode = (~fromLang: Lang.t, ~toLang: Lang.t, json: Js.Json.t): t => {
    // open! Json.Decode
    // try switch field("type", string, json) {
    // | "success" => Success(ConvertSuccess.decode(json))
    // | "unexpected_error" => UnexpectedError(field("msg", string, json))
    // | "syntax_error" =>
    //   let locMsgs = field("errors", array(LocMsg.decode), json)
    //   Fail({fromLang, toLang, details: locMsgs})
    // | other => Unknown(`Unknown conversion result type "${other}"`, json)
    // } catch {
    // | DecodeError(errMsg) => Unknown(errMsg, json)
    // }

    switch json {
    | Object(dict) =>
      switch dict->Js.Dict.get("type") {
      | Some(String("success")) => Success(ConvertSuccess.decode(json))
      | Some(String("unexpected_error")) =>
        UnexpectedError(dict->Js.Dict.unsafeGet("msg")->Js.Json.stringify)
      | Some(String("syntax_error")) =>
        let locMsgs = switch dict->Js.Dict.get("errors") {
        | Some(Array(errors)) => errors->Js.Array2.map(err => err->LocMsg.decode)
        | _ => []
        }
        Fail({fromLang, toLang, details: locMsgs})
      | _ => Unknown("Invalid JSON", json)
      }
    | _ => Unknown("Invalid JSON, expected an object", json)
    }
  }
}

module Config = {
  type t = {
    module_system: string,
    warn_flags: string,
    uncurried?: bool,
  }
}

module Compiler = {
  type t

  // Factory
  @val @scope("rescript_compiler") external make: unit => t = "make"

  @get external version: t => string = "version"

  /*
      Res compiler actions
 */
  @get @scope("rescript") external resVersion: t => string = "version"

  @send @scope("rescript")
  external resCompile: (t, string) => Js.Json.t = "compile"

  let resCompile = (t, code): CompilationResult.t => {
    let startTime = now()
    let json = resCompile(t, code)
    let stopTime = now()

    CompilationResult.decode(~time=stopTime -. startTime, json)
  }

  @send @scope("rescript")
  external resFormat: (t, string) => Js.Json.t = "format"

  let resFormat = (t, code): ConversionResult.t => {
    let json = resFormat(t, code)
    ConversionResult.decode(~fromLang=Res, ~toLang=Res, json)
  }

  @send @scope("reason")
  external reasonCompile: (t, string) => Js.Json.t = "compile"
  let reasonCompile = (t, code): CompilationResult.t => {
    let startTime = now()
    let json = reasonCompile(t, code)
    let stopTime = now()

    CompilationResult.decode(~time=stopTime -. startTime, json)
  }

  @send @scope("reason")
  external reasonFormat: (t, string) => Js.Json.t = "format"

  let reasonFormat = (t, code): ConversionResult.t => {
    let json = reasonFormat(t, code)
    ConversionResult.decode(~fromLang=Reason, ~toLang=Reason, json)
  }

  @get @scope("ocaml") external ocamlVersion: t => string = "version"

  @send @scope("ocaml")
  external ocamlCompile: (t, string) => Js.Json.t = "compile"

  let ocamlCompile = (t, code): CompilationResult.t => {
    let startTime = now()
    let json = ocamlCompile(t, code)
    let stopTime = now()

    CompilationResult.decode(~time=stopTime -. startTime, json)
  }

  @send external getConfig: t => Config.t = "getConfig"

  @send external setFilename: (t, string) => bool = "setFilename"

  @send
  external setModuleSystem: (t, [#es6 | #nodejs]) => bool = "setModuleSystem"

  @send external setWarnFlags: (t, string) => bool = "setWarnFlags"

  let setConfig = (t: t, config: Config.t): unit => {
    let moduleSystem = switch config.module_system {
    | "nodejs" => #nodejs->Some
    | "es6" => #es6->Some
    | _ => None
    }

    Belt.Option.forEach(moduleSystem, moduleSystem => t->setModuleSystem(moduleSystem)->ignore)

    t->setWarnFlags(config.warn_flags)->ignore
  }

  @send
  external convertSyntax: (t, string, string, string) => Js.Json.t = "convertSyntax"

  // General format function
  let convertSyntax = (~fromLang: Lang.t, ~toLang: Lang.t, ~code: string, t): ConversionResult.t =>
    // TODO: There is an issue where trying to convert an empty Reason code
    //       to ReScript code would throw an unhandled JSOO exception
    //       we'd either need to special case the empty Reason code parsing,
    //       or handle the error on the JSOO bundle side more gracefully
    try convertSyntax(t, Lang.toExt(fromLang), Lang.toExt(toLang), code)->ConversionResult.decode(
      ~fromLang,
      ~toLang,
    ) catch {
    | Js.Exn.Error(obj) =>
      switch Js.Exn.message(obj) {
      | Some(m) => ConversionResult.UnexpectedError(m)
      | None => UnexpectedError("")
      }
    }
}

@val @scope("rescript_compiler")
external apiVersion: string = "api_version"
