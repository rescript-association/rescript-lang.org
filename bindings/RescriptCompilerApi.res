// This module establishes the communication to the
// loaded bucklescript API exposed by the bs-platform-js
// bundle

// It is only safe to call these functions when a bundle
// has been loaded, so we'd prefer to protect this
// API with the playground compiler manager state

@bs.val @bs.scope("performance") external now: unit => float = "now"

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

  let decode = (json): t => {
    open! Json.Decode
    switch string(json) {
    | "ml" => OCaml
    | "re" => Reason
    | "res" => Res
    | other => raise(DecodeError(j`Unknown language "$other"`))
    }
  }
}

module Version = {
  type t =
    | V1
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
    | _ => UnknownVersion(apiVersion)
    }

  let defaultTargetLang = t =>
    switch t {
    | V1 => Lang.Res
    | _ => Reason
    }

  let availableLanguages = t =>
    switch t {
    | V1 => [Lang.Reason, Res]
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

  let decode = (json): t => {
    open Json.Decode
    {
      fullMsg: json->field("fullMsg", string, _),
      shortMsg: json->field("shortMsg", string, _),
      row: json->field("row", int, _),
      column: json->field("column", int, _),
      endRow: json->field("endRow", int, _),
      endColumn: json->field("endColumn", int, _),
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

    j`[1;31m[$prefix] Line $row, $column:[0m $shortMsg`
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

  let decode = (json): t => {
    open! Json.Decode

    let warnNumber = field("warnNumber", int, json)
    let details = LocMsg.decode(json)

    field("isError", bool, json)
      ? WarnErr({warnNumber: warnNumber, details: details})
      : Warn({warnNumber: warnNumber, details: details})
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
      let msg = j`(Warning number $warnNumber) $shortMsg`
      (row, column, msg)
    }

    j`[1;31m[$prefix] Line $row, $column:[0m $msg`
  }
}

module WarningFlag = {
  type t = {
    msg: string,
    warn_flags: string,
    warn_error_flags: string,
  }

  let decode = (json): t => {
    open Json.Decode
    {
      msg: field("msg", string, json),
      warn_flags: field("warn_flags", string, json),
      warn_error_flags: field("warn_error_flags", string, json),
    }
  }
}

module CompileSuccess = {
  type t = {
    js_code: string,
    warnings: array<Warning.t>,
    time: float, // total compilation time
  }

  let decode = (~time: float, json): t => {
    open Json.Decode
    {
      js_code: field("js_code", string, json),
      warnings: field("warnings", array(Warning.decode), json),
      time: time,
    }
  }
}

module ConvertSuccess = {
  type t = {
    code: string,
    fromLang: Lang.t,
    toLang: Lang.t,
  }

  let decode = (json): t => {
    open Json.Decode
    {
      code: field("code", string, json),
      fromLang: field("fromLang", Lang.decode, json),
      toLang: field("toLang", Lang.decode, json),
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

  let decode = (json): t => {
    open! Json.Decode

    switch field("type", string, json) {
    | "syntax_error" =>
      let locMsgs = field("errors", array(LocMsg.decode), json)
      // TODO: There seems to be a bug in the ReScript bundle that reports
      //       back multiple LocMsgs of the same value
      locMsgs->LocMsg.dedupe->SyntaxErr
    | "type_error" =>
      let locMsgs = field("errors", array(LocMsg.decode), json)
      TypecheckErr(locMsgs)
    | "warning_error" =>
      let warnings = field("errors", array(Warning.decode), json)
      WarningErr(warnings)
    | "other_error" =>
      let locMsgs = field("errors", array(LocMsg.decode), json)
      OtherErr(locMsgs)

    | "warning_flag_error" =>
      let warningFlag = WarningFlag.decode(json)
      WarningFlagErr(warningFlag)
    | other => raise(DecodeError(j`Unknown type "$other" in CompileFail result`))
    }
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
    open! Json.Decode

    try switch field("type", string, json) {
    | "success" => Success(CompileSuccess.decode(~time, json))
    | "unexpected_error" => UnexpectedError(field("msg", string, json))
    | _ => Fail(CompileFail.decode(json))
    } catch {
    | DecodeError(errMsg) => Unknown(errMsg, json)
    }
  }
}

module ConversionResult = {
  type t =
    | Success(ConvertSuccess.t)
    | Fail({fromLang: Lang.t, toLang: Lang.t, details: array<LocMsg.t>}) // When a compilation failed with some error result
    | UnexpectedError(string) // Errors that slip through as uncaught exceptions within the playground
    | Unknown(string, Js.Json.t)

  let decode = (~fromLang: Lang.t, ~toLang: Lang.t, json): t => {
    open! Json.Decode
    try switch field("type", string, json) {
    | "success" => Success(ConvertSuccess.decode(json))
    | "unexpected_error" => UnexpectedError(field("msg", string, json))
    | "syntax_error" =>
      let locMsgs = field("errors", array(LocMsg.decode), json)
      Fail({fromLang: fromLang, toLang: toLang, details: locMsgs})
    | other => Unknown(j`Unknown conversion result type "$other"`, json)
    } catch {
    | DecodeError(errMsg) => Unknown(errMsg, json)
    }
  }
}

module Config = {
  type t = {
    module_system: string,
    warn_flags: string,
  }
}

module Compiler = {
  type t

  // Factory
  @bs.val @bs.scope("rescript_compiler") external make: unit => t = "make"

  @bs.get external version: t => string = "version"

  /*
      Res compiler actions
 */
  @bs.get @bs.scope("rescript") external resVersion: t => string = "version"

  @bs.send @bs.scope("rescript")
  external resCompile: (t, string) => Js.Json.t = "compile"

  let resCompile = (t, code): CompilationResult.t => {
    let startTime = now()
    let json = resCompile(t, code)
    let stopTime = now()

    CompilationResult.decode(~time=stopTime -. startTime, json)
  }

  @bs.send @bs.scope("rescript")
  external resFormat: (t, string) => Js.Json.t = "format"

  let resFormat = (t, code): ConversionResult.t => {
    let json = resFormat(t, code)
    ConversionResult.decode(~fromLang=Res, ~toLang=Res, json)
  }

  /*
      Reason compiler actions
 */
  @bs.get @bs.scope("reason")
  external reasonVersion: t => string = "version"

  @bs.send @bs.scope("reason")
  external reasonCompile: (t, string) => Js.Json.t = "compile"
  let reasonCompile = (t, code): CompilationResult.t => {
    let startTime = now()
    let json = reasonCompile(t, code)
    let stopTime = now()

    CompilationResult.decode(~time=stopTime -. startTime, json)
  }

  @bs.send @bs.scope("reason")
  external reasonFormat: (t, string) => Js.Json.t = "format"

  let reasonFormat = (t, code): ConversionResult.t => {
    let json = reasonFormat(t, code)
    ConversionResult.decode(~fromLang=Reason, ~toLang=Reason, json)
  }

  /*
      OCaml compiler actions (Note: no pretty print available for OCaml)
 */
  @bs.get @bs.scope("ocaml") external ocamlVersion: t => string = "version"

  @bs.send @bs.scope("ocaml")
  external ocamlCompile: (t, string) => Js.Json.t = "compile"

  let ocamlCompile = (t, code): CompilationResult.t => {
    let startTime = now()
    let json = ocamlCompile(t, code)
    let stopTime = now()

    CompilationResult.decode(~time=stopTime -. startTime, json)
  }

  /*
      Config setter / getters
 */
  @bs.send external getConfig: t => Config.t = "getConfig"

  @bs.send external setFilename: (t, string) => bool = "setFilename"

  @bs.send
  external setModuleSystem: (t, @bs.string [#es6 | #nodejs]) => bool = "setModuleSystem"

  @bs.send external setWarnFlags: (t, string) => bool = "setWarnFlags"

  let setConfig = (t: t, config: Config.t): unit => {
    let moduleSystem = switch config.module_system {
    | "nodejs" => #nodejs->Some
    | "es6" => #es6->Some
    | _ => None
    }

    Belt.Option.forEach(moduleSystem, moduleSystem => t->setModuleSystem(moduleSystem)->ignore)

    t->setWarnFlags(config.warn_flags)->ignore
  }

  @bs.send
  external convertSyntax: (t, string, string, string) => Js.Json.t = "convertSyntax"

  // General format function
  let convertSyntax = (t, ~fromLang: Lang.t, ~toLang: Lang.t, ~code: string): ConversionResult.t =>
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

@bs.val @bs.scope("rescript_compiler")
external apiVersion: string = "api_version"
