// This module establishes the communication to the
// loaded bucklescript API exposed by the bs-platform-js
// bundle

// It is only safe to call these functions when a bundle
// has been loaded, so we'd prefer to protect this
// API with the playground compiler manager state

module Lang = {
  type t =
    | Reason
    | OCaml
    | Res;

  let toString = t =>
    switch (t) {
    | Res => "New BS Syntax"
    | Reason => "Reason"
    | OCaml => "OCaml"
    };

  let toExt = t =>
    switch (t) {
    | Res => "res"
    | Reason => "re"
    | OCaml => "ml"
    };
};

module Version = {
  type t =
    | V1
    | UnknownVersion;

  // Helps finding the right API version
  let whichApi = (apiVersion: string): t =>
    switch (Js.String2.split(apiVersion, ".")->Belt.List.fromArray) {
    | [maj, min, ..._] =>
      let maj = Belt.Int.fromString(maj);
      let min = Belt.Int.fromString(min);

      switch (maj, min) {
      | (Some(maj), Some(_))
      | (Some(maj), None) =>
        if (maj >= 1) {
          V1;
        } else {
          UnknownVersion;
        }
      | _ => UnknownVersion
      };
    | _ => UnknownVersion
    };

  let defaultTargetLang = t =>
    switch (t) {
    | V1 => Lang.Res
    | _ => Reason
    };

  let availableLanguages = t =>
    switch (t) {
    | V1 => [|Lang.Reason, Res|]
    | UnknownVersion => [|Res|]
    };
};

module Decode = {
  type raw = Js.Json.t;

  module LocMsg = {
    type t = {
      fullMsg: string,
      shortMsg: string,
      row: int,
      column: int,
      endRow: int,
      endColumn: int,
    };

    let decode = (json): t => {
      Json.Decode.{
        fullMsg: json->field("fullMsg", string, _),
        shortMsg: json->field("shortMsg", string, _),
        row: json->field("row", int, _),
        column: json->field("column", int, _),
        endRow: json->field("endRow", int, _),
        endColumn: json->field("endColumn", int, _),
      };
    };

    // Useful for showing errors in a more compact format
    let toCompactErrorLine = (locMsg: t) => {
      let {row, column, shortMsg} = locMsg;

      {j|[1;31m[E] Line $row, $column:[0m $shortMsg|j};
    };
  };

  module Warning = {
    type t =
      | Warn({
          warnNumber: int,
          details: LocMsg.t,
        })
      | WarnErr({
          warnNumber: int,
          details: LocMsg.t,
        });

    let decode = (json): t => {
      open! Json.Decode;

      let warnNumber = field("warnNumber", int, json);
      let details = LocMsg.decode(json);

      field("isError", bool, json)
        ? WarnErr({warnNumber, details}) : Warn({warnNumber, details});
    };
  };

  module WarningFlag = {
    type t = {
      msg: string,
      warn_flags: string,
      warn_error_flags: string,
    };

    let decode = (json): t => {
      Json.Decode.{
        msg: field("msg", string, json),
        warn_flags: field("warn_flags", string, json),
        warn_error_flags: field("warn_error_flags", string, json),
      };
    };
  };

  module CompileSuccess = {
    type t = {
      js_code: string,
      warnings: array(Warning.t),
    };

    let decode = (json): t => {
      Json.Decode.{
        js_code: field("js_code", string, json),
        warnings: field("warnings", array(Warning.decode), json),
      };
    };
  };

  module ConvertSuccess = {
    type t = {
      code: string,
      fromLang: Lang.t,
      toLang: Lang.t,
    };

    let decodeLang = (json): Lang.t => {
      open! Json.Decode;
      switch (string(json)) {
      | "ml" => Lang.OCaml
      | "re" => Reason
      | "res" => Res
      | other => raise(DecodeError({j|Unknown language "$other"|j}))
      };
    };

    let decode = (json): t => {
      Json.Decode.{
        code: field("code", string, json),
        fromLang: field("fromLang", decodeLang, json),
        toLang: field("toLang", decodeLang, json),
      };
    };
  };

  module CompileFail = {
    type t =
      | SyntaxErr(array(LocMsg.t))
      | TypecheckErr(array(LocMsg.t))
      | WarningErr(array(Warning.t))
      | WarningFlagErr(WarningFlag.t)
      | OtherErr(array(LocMsg.t));

    let decode = (json): t => {
      open! Json.Decode;

      switch (field("type", string, json)) {
      | "syntax_error" =>
        let locMsgs = field("errors", array(LocMsg.decode), json);
        SyntaxErr(locMsgs);
      | "type_error" =>
        let locMsgs = field("errors", array(LocMsg.decode), json);
        TypecheckErr(locMsgs);
      | "warning_error" =>
        let warnings = field("errors", array(Warning.decode), json);
        WarningErr(warnings);
      | "other_error" =>
        let locMsgs = field("errors", array(LocMsg.decode), json);
        OtherErr(locMsgs);

      | "warning_flag_error" =>
        let warningFlag = WarningFlag.decode(json);
        WarningFlagErr(warningFlag);
      | other =>
        raise(DecodeError({j|Unknown type $other in CompileFail result|j}))
      };
    };
  };

  module CompilationResult = {
    type t =
      | Fail(CompileFail.t) // When a compilation failed with some error result
      | Success(CompileSuccess.t)
      | UnexpectedError(string) // Errors that slip through as uncaught exceptions of the compiler bundle
      | Unknown(string, raw);

    // TODO: We might change this specific api completely before launching
    let decode = (json: raw): t => {
      open! Json.Decode;

      switch (field("type", string, json)) {
      | "success" => Success(CompileSuccess.decode(json))
      | "unexpected_error" => UnexpectedError(field("msg", string, json))
      | _ => Fail(CompileFail.decode(json))
      | exception (DecodeError(errMsg)) => Unknown(errMsg, json)
      };
    };
  };

  module ConversionResult = {
    type t =
      | Success(ConvertSuccess.t)
      | Fail(CompileFail.t) // When a compilation failed with some error result
      | UnexpectedError(string) // Errors that slip through as uncaught exceptions within the playground
      | Unknown(string, raw);

    let decode = (json): t => {
      Json.Decode.(
        switch (field("type", string, json)) {
        | "parse_print_success" =>
          Success(field("code", ConvertSuccess.decode, json))
        | "unexpected_error" => UnexpectedError(field("msg", string, json))
        | _ => Fail(CompileFail.decode(json))
        | exception (DecodeError(errMsg)) => Unknown(errMsg, json)
        }
      );
    };
  };
};

module Compiler = {
  open Decode;
  type t;

  type config = {
    module_system: string,
    warn_flags: string,
    warn_error_flags: string,
  };

  // Factory
  [@bs.val] [@bs.scope "bs_platform"] external make: unit => t = "make";

  /*
      Res compiler actions
   */
  [@bs.get] [@bs.scope "napkin"] external resVersion: t => string = "version";

  [@bs.send] [@bs.scope "napkin"]
  external resCompile: (t, string) => Js.Json.t = "compile";

  [@bs.send] [@bs.scope "napkin"]
  external resPrettyPrint: (t, string) => Js.Json.t = "pretty_print";

  /*
      Reason compiler actions
   */
  [@bs.get] [@bs.scope "reason"]
  external reasonVersion: t => string = "version";

  [@bs.send] [@bs.scope "reason"]
  external reasonCompile: (t, string) => Js.Json.t = "compile";

  [@bs.send] [@bs.scope "reason"]
  external reasonPrettyPrint: (t, string) => Js.Json.t = "pretty_print";

  /*
      OCaml compiler actions (Note: no pretty print available for OCaml)
   */
  [@bs.get] [@bs.scope "ocaml"] external ocamlVersion: t => string = "version";

  [@bs.send] [@bs.scope "ocaml"]
  external ocamlCompile: (t, string) => Js.Json.t = "compile";

  /*
      Setting actions
   */
  [@bs.send] [@bs.scope "settings"] external getConfig: t => config = "list";

  [@bs.send] [@bs.scope "settings"]
  external setFilename: (t, string) => bool = "setFilename";

  [@bs.send] [@bs.scope "settings"]
  external setModuleSystem: (t, [@bs.string] [ | `es6 | `nodejs]) => bool =
    "setModuleSystem";

  [@bs.send] [@bs.scope "settings"]
  external setWarnFlags: (t, string) => bool = "setWarnFlags";

  [@bs.send] [@bs.scope "settings"]
  external setWarnErrorFlags: (t, string) => bool = "setWarnErrorFlags";

  // Pretty print decoder overrides
  let napkinPrettyPrint = (t, code): ConversionResult.t => {
    let json = resPrettyPrint(t, code);
    ConversionResult.decode(json);
  };

  let reasonPrettyPrint = (t, code): ConversionResult.t => {
    let json = reasonPrettyPrint(t, code);
    ConversionResult.decode(json);
  };
};

[@bs.val] [@bs.scope "bs_platform"]
external api_version: string = "api_version";

module Convert = {
  open Decode;

  // Syntax convertion functions
  [@bs.send] [@bs.scope "convert"]
  external reason_to_res: (Compiler.t, string) => Js.Json.t = "reason_to_res";

  [@bs.send] [@bs.scope "convert"]
  external res_to_reason: (Compiler.t, string) => Js.Json.t = "res_to_reason";

  let reason_to_res = (comp: Compiler.t, code): ConversionResult.t => {
    reason_to_res(comp, code)->ConversionResult.decode;
  };

  let res_to_reason = (comp: Compiler.t, code): ConversionResult.t => {
    res_to_reason(comp, code)->ConversionResult.decode;
  };
};
