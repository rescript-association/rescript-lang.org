open Util.ReactStuff;

%raw
"require('../styles/main.css')";

module LoadScript = {
  type err;

  [@bs.module "../ffi/loadScript"]
  external loadScript:
    (~src: string, ~onSuccess: unit => unit, ~onError: err => unit) =>
    (. unit) => unit =
    "default";

  [@bs.module "../ffi/loadScript"]
  external removeScript: (~src: string) => unit = "removeScript";

  let loadScriptPromise = (url: string): Promise.t(result(unit, string)) => {
    let (p, resolve) = Promise.pending();
    loadScript(
      ~src=url,
      ~onSuccess=() => {resolve(Ok())},
      ~onError=_err => {resolve(Error({j|Could not load script: $url|j}))},
    )
    ->ignore;
    p;
  };
};

module Compiler = {
  /*
      This module is intended to manage following things:
      - Loading available versions of bs-platform-js releases
      - Loading actual bs-platform-js bundles on demand
      - Loading third-party libraries together with the compiler bundle
      - Sending data back and forth between consumer and compiler

      The interface is defined with a finite state and action dispatcher.
   */

  module Api = {
    // This module establishes the communication to the
    // loaded bucklescript API exposed by the bs-platform-js
    // bundle

    // It is only safe to call these functions when a bundle
    // has been loaded so far, so we'd prefer to protect this
    // API with the compiler manager state

    type lang =
      | Reason
      | OCaml
      | Res;

    module Version = {
      type t =
        | V1 // before 8.1.0
        | V2 // since 8.1.0;
        | UnknownVersion;

      // Helps finding the right API version
      let whichApi = (compilerVersion: string): t =>
        switch (Js.String2.split(compilerVersion, ".")->Belt.List.fromArray) {
        | [maj, min, ..._] =>
          let maj = Belt.Int.fromString(maj);
          let min = Belt.Int.fromString(min);

          switch (maj, min) {
          | (Some(maj), Some(min)) =>
            if (maj >= 8 && min >= 1) {
              V2;
            } else if (maj >= 8 && min < 1 || maj < 8) {
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
        | V2 => Res
        | _ => Reason
        };

      let availableLanguages = t =>
        switch (t) {
        | V2 => [|Reason, Res|]
        | V1
        | UnknownVersion => [|Reason|]
        };
    };

    module CompilationResult = {
      type raw = Js.Json.t;

      // TODO: Would be great to get rid of the separate console.error
      //       capturing and retrieve the super_error output through the
      //       actual json result instead (needs change on the compiler bundle)
      type fail = {
        js_error_msg: string,
        super_errors: string, // also includes warnings
        row: int,
        column: int,
        endRow: int,
        endColumn: int,
        text: string,
      };

      type success = {
        js_output: string,
        warnings: string,
      };

      type t =
        | Fail(array(fail)) // When a compilation failed with some error result
        | Success(success)
        | UnexpectedError(string) // Errors that slip through as uncaught exceptions within the playground
        | Unknown(string, raw)
        | None;

      // Useful for showing errors in a more compact format
      let toCompactErrorLine = (fail: fail) => {
        let {row, column, text} = fail;

        {j|[1;31m[E] Line $row, $column:[0m $text|j};
      };

      module DecodeV2 = {
        let decodeCompilationErr = (~super_errors="", json) => {
          Json.Decode.{
            js_error_msg: json->field("js_error_msg", string, _),
            super_errors,
            row: json->field("row", int, _),
            column: json->field("column", int, _),
            endRow: json->field("endRow", int, _),
            endColumn: json->field("endColumn", int, _),
            text: json->field("text", string, _),
          };
        };

        // Used for compiler version >= 8.1
        // TODO: We might change this specific api completely before launching
        let classify = (raw: raw, super_errors: string): t => {
          open! Json.Decode;

          switch (field("type", string, raw)) {
          | "success" =>
            switch (field("js_code", string, raw)) {
            | js_output => Success({js_output, warnings: super_errors})
            | exception (DecodeError(errMsg)) => Unknown(errMsg, raw)
            }
          | "error" =>
            switch (
              field(
                "errors",
                array(decodeCompilationErr(~super_errors)),
                raw,
              )
            ) {
            | [||] =>
              Unknown("Failed, but no errors returned by the compiler", raw)
            | fails => Fail(fails)
            | exception (DecodeError(errMsg)) => Unknown(errMsg, raw)
            }
          | "unexpected_error" =>
            switch (field("js_error_msg", string, raw)) {
            | msg => UnexpectedError(msg)
            | exception (DecodeError(errMsg)) => Unknown(errMsg, raw)
            }
          | _ => Unknown("Malformed result", raw)
          | exception (DecodeError(errMsg)) => Unknown(errMsg, raw)
          };
        };
      };

      module DecodeV1 = {
        let classify = (raw: raw, super_errors: string): t => {
          Js.Json.(
            switch (raw->classify) {
            | JSONObject(root) =>
              let type_ = Js.Dict.get(root, "type");
              let jsCode = Js.Dict.get(root, "js_code");

              switch (jsCode, type_) {
              | (Some(json), None) =>
                switch (classify(json)) {
                | JSONString(js_output) =>
                  Success({js_output, warnings: super_errors})
                | value =>
                  Unknown({j|.js_code is not a string: $value|j}, raw)
                }
              | (None, Some(type_)) =>
                switch (classify(type_)) {
                | JSONString("error") =>
                  open! Json.Decode;
                  // Note:
                  // The V1 playground bundle API was already correcting the row numbers
                  // to a zero based value. This will correct them back to 1 based ones to
                  // have a unified interface for the UI (which again, converts them to zero based
                  // line numbers)
                  let toOneBased = n => n + 1;

                  switch (
                    {
                      js_error_msg: raw->field("js_error_msg", string, _),
                      super_errors,
                      row: raw->field("row", int, _)->toOneBased,
                      column: raw->field("column", int, _),
                      endRow: raw->field("endRow", int, _)->toOneBased,
                      endColumn: raw->field("endColumn", int, _),
                      text: raw->field("text", string, _),
                    }
                  ) {
                  | fail => Fail([|fail|])
                  | exception (DecodeError(errMsg)) => Unknown(errMsg, raw)
                  };

                | value => Unknown({j|.type is not a string: $value|j}, raw)
                }
              | (Some(_), Some(_)) =>
                Unknown("Not sure if this is a success / error result", raw)
              | (None, None) => Unknown("No js code / error message", raw)
              };
            | _ => Unknown("Malformed result", raw)
            }
          );
        };
      };
    };

    [@bs.val] [@bs.scope "reason"] external reasonVersion: string = "version";
    [@bs.val] [@bs.scope "ocaml"] external compilerVersion: string = "version";

    // TODO: We need to add this information in the actual bundle and retrieve it
    //       via external
    let ocamlVersion = "4.06.1";

    [@bs.val] [@bs.scope "ocaml"]
    external ocamlCompile: string => Js.Json.t = "compile_super_errors";

    [@bs.val] [@bs.scope "reason"]
    external reasonCompile: string => Js.Json.t = "compile_super_errors";

    [@bs.val] [@bs.scope "napkin"]
    external napkinCompile: string => Js.Json.t = "compile_super_errors";

    module ConversionResult = {
      type fail = CompilationResult.fail; // Currently the convertion result is the same as with a compilation
      type t =
        | Fail({
            fromLang: lang,
            toLang: lang,
            fails: array(fail),
          }) // When a conversion failed with some error result
        | Success(string)
        | UnexpectedError(string) // Errors that slip through as uncaught exceptions within the playground
        | Unknown(string, Js.Json.t)
        | None;

      let decode = (~fromLang, ~toLang, json) => {
        Json.Decode.(
          try(
            switch (field("type", string, json)) {
            | "success" => Success(field("code", string, json))
            | "error" =>
              switch (
                field(
                  "errors",
                  array(
                    CompilationResult.DecodeV2.decodeCompilationErr(
                      ~super_errors="",
                    ),
                  ),
                  json,
                )
              ) {
              | [||] =>
                Unknown(
                  "Failed, but no errors returned by the converter",
                  json,
                )
              | fails => Fail({fromLang, toLang, fails})
              }
            | "unexpected_error" =>
              switch (field("js_error_msg", string, json)) {
              | msg => UnexpectedError(msg)
              }
            | _ => Unknown("Unknown type value", json)
            }
          ) {
          | DecodeError(errMsg) => Unknown(errMsg, json)
          }
        );
      };
    };

    module FinalResult = {
      /* A final result is the last operation the compiler has done, right now this includes... */
      type t =
        | Conv(ConversionResult.t)
        | Comp(CompilationResult.t)
        | Nothing;
    };

    // Pretty printing facilities (v2 only)
    [@bs.val] [@bs.scope "napkin"]
    external napkinPrettyPrint: string => Js.Json.t = "pretty_print";

    [@bs.val] [@bs.scope "reason"]
    external reasonPrettyPrint: string => Js.Json.t = "pretty_print";

    let napkinPrettyPrint = (code): ConversionResult.t => {
      let json = napkinPrettyPrint(code);
      json->ConversionResult.decode(~fromLang=Res, ~toLang=Res);
    };

    let reasonPrettyPrint = (code): ConversionResult.t => {
      let json = reasonPrettyPrint(code);
      json->ConversionResult.decode(~fromLang=Reason, ~toLang=Reason);
    };

    // Syntax convertion functions
    [@bs.val] [@bs.scope "convert"]
    external reason_to_res: string => Js.Json.t = "reason_to_res";

    [@bs.val] [@bs.scope "convert"]
    external res_to_reason: string => Js.Json.t = "res_to_reason";

    let reason_to_res = (code): ConversionResult.t => {
      reason_to_res(code)
      ->ConversionResult.decode(~fromLang=Reason, ~toLang=Res);
    };

    let res_to_reason = (code): ConversionResult.t => {
      res_to_reason(code)
      ->ConversionResult.decode(~fromLang=Res, ~toLang=Reason);
    };

    module ConsoleCapture = {
      /*
          Right now, super error printing only happens on stderr / console.error.
          For that reason, we need to replace console.error with a mocked function
          to capture and gather all the error output during a compile process.

          This module provides functionality for that purpose.

          See https://github.com/reasonml/reasonml.github.io/blob/source/website/playground/try.js#L621
       */

      [@bs.val] [@bs.scope "console"]
      external consoleError: (. string) => unit = "error";

      let setConsoleError: (. ((. string) => unit)) => unit = [%raw
        {|
        function setConsoleError(cerror) {
          console.error = cerror;
        }
      |}
      ];

      // Used for restoring
      let _originalConsoleError = consoleError;

      /*
          Usage:
          let flush = captureErrorConsole();
          // do some error logging in between
          let result = flush();

          Running flush will automatically restore
          the original error logger again
       */
      let captureErrorConsole = () => {
        let errs = ref("");

        setConsoleError(. (. msg) => {errs := errs^ ++ msg ++ "\n"});

        let flush = () => {
          setConsoleError(. _originalConsoleError);
          errs^;
        };

        flush;
      };
    };
  };

  // Splits and sanitizes the content of the VERSIONS file
  let parseVersions = (versions: string) => {
    Js.String2.split(versions, "\n")->Js.Array2.filter(v => v !== "");
  };

  let getCompilerUrl = (version: string): string => {
    {j|https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@master/$version/compiler.js|j};
  };

  let getLibraryCmijUrl = (version: string, libraryName: string): string => {
    {j|https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@master/$version/$libraryName/cmij.js|j};
  };

  /*
      This function loads the compiler, plus a defined set of libraries that are available
      on our bs-platform-js-releases channel.

      Due to JSOO specifics, even if we already loaded a compiler before, we need to make sure
      to load the compiler bundle first, and then load the library cmij files right after that.

      If you don't respect the loading order, then the loaded cmij files will not hook into the
      jsoo filesystem and the compiler won't be able to find the cmij content.

      We coupled the compiler / library loading to prevent ppl to try loading compiler / cmij files
      separately and cause all kinds of race conditions.
   */
  let attachCompilerAndLibraries =
      (~version: string, ~libraries: array(string), ())
      : Promise.t(result(unit, array(string))) => {
    let compilerUrl = getCompilerUrl(version);

    LoadScript.loadScriptPromise(compilerUrl)
    ->Promise.mapError(_msg =>
        {j|Could not load compiler from url $compilerUrl|j}
      )
    ->Promise.map(r => {
        switch (r) {
        | Ok () =>
          Belt.Array.map(
            libraries,
            lib => {
              let cmijUrl = getLibraryCmijUrl(version, lib);
              LoadScript.loadScriptPromise(cmijUrl)
              ->Promise.mapError(_msg =>
                  {j|Could not load cmij from url $cmijUrl|j}
                );
            },
          )
        | Error(msg) => [|Promise.resolved(Error(msg))|]
        }
      })
    ->Promise.flatMap(Promise.allArray)
    ->Promise.map(all => {
        // all: array(Promise.result(unit, string))
        let errors =
          Belt.Array.reduce(all, [||], (acc, r) =>
            switch (r) {
            | Error(msg) => Js.Array2.concat(acc, [|msg|])
            | _ => acc
            }
          );

        switch (errors) {
        | [||] => Ok()
        | errs => Error(errs)
        };
      });
  };

  type error =
    | SetupError(string)
    | CompilerLoadingError(string);

  type selected = {
    id: string, // The id used for loading the compiler bundle (ideally should be the same as compilerVersion)
    apiVersion: Api.Version.t, // The playground API version in use
    compilerVersion: string,
    ocamlVersion: string,
    reasonVersion: string,
    libraries: array(string),
  };

  type ready = {
    versions: array(string),
    selected,
    targetLang: Api.lang,
    errors: array(string), // For major errors like bundle loading
    result: Api.FinalResult.t,
  };

  type state =
    | Init
    | SetupFailed(string)
    | SwitchingCompiler(ready, string, array(string))
    | Ready(ready)
    | Compiling(ready, (Api.lang, string));

  type action =
    | SwitchToCompiler({
        id: string,
        libraries: array(string),
      })
    | SwitchLanguage({
        lang: Api.lang,
        code: string,
      })
    | Format(string)
    | CompileCode(Api.lang, string);

  let useCompilerManager = () => {
    let (state, setState) = React.useState(_ => Init);

    // Dispatch method for the public interface
    let dispatch = (action: action): unit => {
      switch (action) {
      | SwitchToCompiler({id, libraries}) =>
        switch (state) {
        | Ready(ready) =>
          // TODO: Check if libraries have changed as well
          if (ready.selected.id !== id) {
            setState(_ => SwitchingCompiler(ready, id, libraries));
          } else {
            ();
          }
        | _ => ()
        }
      | CompileCode(lang, code) =>
        switch (state) {
        | Ready(ready) => setState(_ => Compiling(ready, (lang, code)))
        | _ => ()
        }
      | SwitchLanguage({lang, code}) =>
        switch (state) {
        | Ready(ready) =>
          let availableTargetLangs =
            Api.Version.availableLanguages(ready.selected.apiVersion);

          let currentLang = ready.targetLang;

          Js.Array2.find(availableTargetLangs, l => l === lang)
          ->Belt.Option.forEach(l => {
              // Try to automatically transform code
              let (result, targetLang) =
                switch (ready.selected.apiVersion) {
                | V2 =>
                  let convResult =
                    switch (currentLang, lang) {
                    | (Reason, Res) => Api.reason_to_res(code)
                    | (Res, Reason) => Api.res_to_reason(code)
                    | _ => None
                    };

                  // In case of an error, keep the current lang
                  switch (convResult) {
                  | Api.ConversionResult.Fail(_)
                  | Unknown(_, _)
                  | UnexpectedError(_) => (
                      Api.FinalResult.Conv(convResult),
                      currentLang,
                    )
                  | Api.ConversionResult.Success(code) => (
                      Conv(convResult),
                      l,
                    )
                  | None => (Nothing, l)
                  };
                | _ => (Nothing, l)
                };

              setState(_ =>
                Ready({...ready, result, errors: [||], targetLang})
              );
            });
        | _ => ()
        }
      | Format(code) =>
        switch (state) {
        | Ready(ready) =>
          let convResult =
            switch (ready.targetLang) {
            | Res => Api.napkinPrettyPrint(code)
            | Reason => Api.reasonPrettyPrint(code)
            | _ => None
            };

          let result =
            switch (convResult) {
            | Api.ConversionResult.Success(newCode) =>
              // We will only change the result to a ConversionResult
              // in case the reformatting has actually changed code
              // otherwise we'd loose previous compilationResults, although
              // the result should be the same anyways
              if (code !== newCode) {
                Api.FinalResult.Conv(convResult);
              } else {
                ready.result;
              }
            | Api.ConversionResult.Fail(_)
            | Unknown(_, _)
            | UnexpectedError(_) => Api.FinalResult.Conv(convResult)
            | _ => ready.result
            };

          setState(_ => Ready({...ready, result, errors: [||]}));
        | _ => ()
        }
      };
    };

    let dispatchError = (err: error) => {
      setState(prev => {
        let msg =
          switch (err) {
          | SetupError(msg) => msg
          | CompilerLoadingError(msg) => msg
          };
        switch (prev) {
        | Ready(ready) =>
          Ready({...ready, errors: Js.Array2.concat(ready.errors, [|msg|])})
        | _ => SetupFailed(msg)
        };
      });
    };

    React.useEffect1(
      () => {
        switch (state) {
        | Init =>
          let libraries = [|"reason-react"|];

          let completed = res => {
            open SimpleRequest;
            switch (res) {
            | Ok({text}) =>
              switch (parseVersions(text)) {
              | [||] =>
                dispatchError(SetupError({j|No compiler versions found|j}))
              | versions =>
                // Fetching the initial compiler is different, since we
                // don't have any running version downloaded yet

                let latest = versions[0];

                attachCompilerAndLibraries(~version=latest, ~libraries, ())
                ->Promise.get(result => {
                    switch (result) {
                    | Ok () =>
                      let apiVersion =
                        Api.Version.whichApi(Api.compilerVersion);
                      let selected = {
                        id: latest,
                        apiVersion,
                        compilerVersion: Api.compilerVersion,
                        ocamlVersion: Api.ocamlVersion,
                        reasonVersion: Api.reasonVersion,
                        libraries,
                      };

                      setState(_ => {
                        Ready({
                          selected,
                          targetLang:
                            Api.Version.defaultTargetLang(apiVersion),
                          versions,
                          errors: [||],
                          result: Api.FinalResult.Nothing,
                        })
                      });
                    | Error(errs) =>
                      let msg = Js.Array2.joinWith(errs, "; ");

                      dispatchError(CompilerLoadingError(msg));
                    }
                  });
              }
            | Error({text, status}) =>
              dispatchError(
                SetupError(
                  {j|Error occurred: $text (status-code: $status)|j},
                ),
              )
            };
            ();
          };

          SimpleRequest.(
            make(
              ~contentType=Plain,
              ~completed,
              "https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@latest/VERSIONS",
            )
            ->send
          );
        | SwitchingCompiler(ready, version, libraries) =>
          attachCompilerAndLibraries(~version, ~libraries, ())
          ->Promise.get(result => {
              switch (result) {
              | Ok () =>
                // Make sure to remove the previous script from the DOM as well
                LoadScript.removeScript(
                  ~src=getCompilerUrl(ready.selected.id),
                );

                Belt.Array.forEach(ready.selected.libraries, lib => {
                  LoadScript.removeScript(
                    ~src=getLibraryCmijUrl(ready.selected.id, lib),
                  )
                });

                let apiVersion = Api.Version.whichApi(Api.compilerVersion);

                let selected = {
                  id: version,
                  apiVersion,
                  compilerVersion: Api.compilerVersion,
                  ocamlVersion: Api.ocamlVersion,
                  reasonVersion: Api.reasonVersion,
                  libraries,
                };

                setState(_ => {
                  Ready({
                    selected,
                    targetLang: Api.Version.defaultTargetLang(apiVersion),
                    versions: ready.versions,
                    errors: [||],
                    result: Api.FinalResult.Nothing,
                  })
                });
              | Error(errs) =>
                let msg = Js.Array2.joinWith(errs, "; ");

                dispatchError(CompilerLoadingError(msg));
              }
            })
        | Compiling(ready, (lang, code)) =>
          let flush = Api.ConsoleCapture.captureErrorConsole();

          let apiVersion = ready.selected.apiVersion;
          let compilerVersion = ready.selected.compilerVersion;

          let jsonResult =
            switch (lang) {
            | Api.OCaml => Api.ocamlCompile(code)
            | Api.Reason => Api.reasonCompile(code)
            | Api.Res => Api.napkinCompile(code)
            };

          // Retrieve the console.error output and append it
          // to the result if necessary
          let superErrors = flush();

          let compResult =
            switch (apiVersion) {
            | Api.Version.V1 =>
              Api.CompilationResult.DecodeV1.classify(jsonResult, superErrors)
            | V2 =>
              Api.CompilationResult.DecodeV2.classify(jsonResult, superErrors)
            | UnknownVersion =>
              Api.CompilationResult.Unknown(
                {j|Can't classify result of compiler version "$compilerVersion" (This is a bug)|j},
                jsonResult,
              )
            };

          setState(_ => {
            Ready({...ready, result: Api.FinalResult.Comp(compResult)})
          });
        | SetupFailed(_)
        | Ready(_) => ()
        };
        None;
      },
      [|state|],
    );

    (state, dispatch);
  };
};

module DropdownSelect = {
  type style = [ | `Error | `Normal];

  [@react.component]
  let make = (~onChange, ~name, ~value, ~disabled, ~children) => {
    let opacity = disabled ? " opacity-50" : "";
    <select
      className={
        "border border-night-light inline-block rounded px-4 py-1 bg-onyx appearance-none font-semibold "
        ++ opacity
      }
      name
      value
      disabled
      onChange>
      children
    </select>;
  };
};

module ErrorPane = {
  [@react.component]
  let make =
      (
        ~highlightedErrors: array(int)=[||], // index values of [errors] that should be highlighted
        ~errors: array(string),
        ~warnings: array(string)=[||],
      ) => {
    let errorNumber = Belt.Array.length(errors);

    <div>
      <div>
        <div> {{j|Errors ($errorNumber)|j}}->s </div>
        <div
          style={ReactDOMRe.Style.make(~maxHeight="17rem", ())}
          className="overflow-y-scroll ">
          <div className="bg-onyx text-snow-darker text-14 px-4 py-4">
            {errors
             ->Belt.Array.mapWithIndex((i, line) => {
                 let highlight =
                   switch (
                     Js.Array2.find(highlightedErrors, errIdx => errIdx === i)
                   ) {
                   | Some(_) => "bg-fire-15 rounded"
                   | None => ""
                   };
                 <AnsiPre
                   className={
                     "mb-4 pb-2 last:mb-0 last:pb-0 last:border-0 border-b border-night-light "
                     ++ highlight
                   }
                   key={Belt.Int.toString(i)}>
                   line
                 </AnsiPre>;
               })
             ->ate}
            {warnings
             ->Belt.Array.mapWithIndex((i, line) => {
                 <AnsiPre key={Belt.Int.toString(i)}> line </AnsiPre>
               })
             ->ate}
          </div>
        </div>
      </div>
    </div>;
  };
};

module ControlPanel = {
  let langToString = lang =>
    switch (lang) {
    | Compiler.Api.Res => "New BS Syntax"
    | Reason => "Reason"
    | OCaml => "OCaml"
    };

  [@react.component]
  let make =
      (
        ~compilerReady: bool,
        ~langSelectionDisabled: bool, // In case a syntax conversion error occurred
        ~compilerVersion: string,
        ~availableCompilerVersions: array(string),
        ~availableTargetLangs: array(Compiler.Api.lang),
        ~selectedTargetLang: (Compiler.Api.lang, string), // (lang, version)
        ~loadedLibraries: array(string),
        ~onCompilerSelect: string => unit,
        ~onFormatClick: option(unit => unit)=?,
        ~formatDisabled: bool=false,
        ~onCompileClick: unit => unit,
        ~onTargetLangSelect: Compiler.Api.lang => unit,
      ) => {
    let (targetLang, targetLangVersion) = selectedTargetLang;

    let targetLangName = langToString(targetLang);

    let formatClickHandler =
      switch (onFormatClick) {
      | Some(cb) =>
        let handler = evt => {
          ReactEvent.Mouse.preventDefault(evt);
          cb();
        };
        Some(handler);
      | None => None
      };

    <div className="flex bg-onyx text-night-light px-6 w-full text-14">
      <div
        className="flex justify-between items-center border-t py-4 border-night-60 w-full">
        <div>
          <span className="font-semibold mr-2"> "BS"->s </span>
          <DropdownSelect
            name="compilerVersions"
            value=compilerVersion
            disabled={!compilerReady}
            onChange={evt => {
              ReactEvent.Form.preventDefault(evt);
              let id = evt->ReactEvent.Form.target##value;
              onCompilerSelect(id);
            }}>
            {Belt.Array.map(availableCompilerVersions, version => {
               <option className="py-4" key=version value=version>
                 version->s
               </option>
             })
             ->ate}
          </DropdownSelect>
        </div>
        <DropdownSelect
          name="targetLang"
          value=targetLangName
          disabled=langSelectionDisabled
          onChange={evt => {
            ReactEvent.Form.preventDefault(evt);
            let lang =
              switch (evt->ReactEvent.Form.target##value) {
              | "New BS Syntax" => Compiler.Api.Res
              | "Reason" => Reason
              | "OCaml" => OCaml
              | _ => Reason
              };
            onTargetLangSelect(lang);
          }}>
          {Belt.Array.map(
             availableTargetLangs,
             lang => {
               let langStr = langToString(lang);
               <option className="py-4" key=langStr value=langStr>
                 langStr->s
               </option>;
             },
           )
           ->ate}
        </DropdownSelect>
        <button
          className={
            (!compilerReady ? "opacity-25" : "")
            ++ " font-semibold inline-block border border-night-light rounded py-1 px-4"
          }
          disabled=formatDisabled
          onClick=?formatClickHandler>
          "Format"->s
        </button>
        /*
         <div className="font-semibold">
           "Bindings: "->s
           {switch (loadedLibraries) {
            | [||] => "No third party library loaded"->s
            | arr => Js.Array2.joinWith(arr, ", ")->s
            }}
         </div>
         */
        <button
          disabled={!compilerReady}
          className={
            (!compilerReady ? "opacity-25" : "")
            ++ " inline-block bg-sky text-16 text-white-80 rounded py-2 px-6"
          }
          onClick={evt => {
            ReactEvent.Mouse.preventDefault(evt);
            onCompileClick();
          }}>
          "Compile"->s
        </button>
      </div>
    </div>;
  };
};

[@react.component]
let default = () => {
  let (compilerState, compilerDispatch) = Compiler.useCompilerManager();

  let overlayState = React.useState(() => false);

  // index based list of errors that should be highlighted in the ErrorPane
  let highlightedErrorState = React.useState(() => [||]);

  let initialContent = {j|
  let a = 1 + "";
module Test2 = {
  [@react.component]
  let make = (~a: string, ~b: string) => {
    <div>
    </div>
  };
}|j};

  let initialContent = {j|module A = {
  let = 1;
  let a = 1;
}

module B = {
  let = 2
  let b = 2
}|j};

  let jsOutput =
    Compiler.Api.(
      switch (compilerState) {
      | Init => "/* Initializing Playground... */"
      | Ready({result: FinalResult.Comp(comp)}) =>
        switch (comp) {
        | CompilationResult.Success({js_output}) => js_output
        | UnexpectedError(msg)
        | Unknown(msg, _) => {j|/* Unexpected Result: $msg */|j}
        | Fail(_) => "/* Could not compile, check the error pane for details. */"
        | None => "/* Compiler ready! Press the \"Compile\" button to see the JS output. */"
        }
      | Ready({result: Nothing})
      | Ready({result: Conv(_)}) => "/* Compiler ready! Press the \"Compile\" button to see the JS output. */"
      | Compiling(_, _) => "/* Compiling... */"
      | SwitchingCompiler(_, version, libraries) =>
        let appendix =
          if (Js.Array.length(libraries) > 0) {
            " (+" ++ Js.Array2.joinWith(libraries, ", ") ++ ")";
          } else {
            "";
          };
        "/* Switching to " ++ version ++ appendix ++ " ... */";
      | _ => ""
      }
    );

  let isReady =
    switch (compilerState) {
    | Ready(_) => true
    | _ => false
    };

  let reasonCode = React.useRef(initialContent);

  /* In case the compiler did some kind of syntax conversion / reformatting,
     we take any success results and set the editor code to the new formatted code */
  Compiler.Api.(
    switch (compilerState) {
    | Ready({result: FinalResult.Conv(ConversionResult.Success(code))}) =>
      React.Ref.setCurrent(reasonCode, code)
    | _ => ()
    }
  );

  Js.log2("state", compilerState);

  let cmErrors =
    switch (compilerState) {
    | Ready({result}) =>
      let fails =
        switch (result) {
        | Compiler.Api.FinalResult.Comp(Fail(fails)) => fails
        | Conv(Fail({fails})) => fails
        | Comp(_)
        | Conv(_)
        | Nothing => [||]
        };
      Belt.Array.map(fails, ({row, column, endColumn, endRow, text}) => {
        {CodeMirrorBase.row, column, endColumn, endRow, text}
      });
    | _ => [||]
    };

  <>
    <Meta
      title="Reason Playground"
      description="Try ReasonML in the browser"
    />
    <div className="mb-32 mt-16 pt-2 bg-night-dark">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <main className="mx-10 mt-16 pb-32 flex justify-center">
          <div className="flex max-w-1280 w-full">
            <div className="w-full max-w-705 border-r-4 border-night">
              <CodeMirror
                className="w-full"
                minHeight="40vh"
                mode="reason"
                errors=cmErrors
                value={React.Ref.current(reasonCode)}
                onChange={value => {React.Ref.setCurrent(reasonCode, value)}}
              />
              {switch (compilerState) {
               | Ready(ready)
               | Compiling(ready, _)
               | SwitchingCompiler(ready, _, _) =>
                 let (errors, warnings) =
                   Compiler.Api.(
                     switch (ready.result) {
                     | FinalResult.Comp(CompilationResult.Fail(fails))
                     | Conv(Fail({fails})) =>
                       let initial =
                         switch (ready.result) {
                         | FinalResult.Conv(Fail({fromLang, toLang})) =>
                           let msg =
                             if (fromLang === toLang) {
                               let fromStr =
                                 ControlPanel.langToString(fromLang);
                               {j|Cannot format "$fromStr" code because of following syntax errors:|j};
                             } else {
                               let fromStr =
                                 ControlPanel.langToString(fromLang);
                               let toStr = ControlPanel.langToString(toLang);
                               {j|Cannot switch "$fromStr" to "$toStr" because of syntax errors:|j};
                             };

                           [|msg|];
                         | _ => [||]
                         };
                       let errors =
                         Belt.Array.reduce(
                           fails,
                           initial,
                           (acc, next) => {
                             let {
                               Compiler.Api.CompilationResult.super_errors,
                               js_error_msg,
                             } = next;

                             switch (
                               ready.selected.apiVersion,
                               ready.targetLang,
                             ) {
                             | (Compiler.Api.Version.V2, Res) =>
                               let text =
                                 Compiler.Api.CompilationResult.toCompactErrorLine(
                                   next,
                                 );

                               Js.Array2.concat(acc, [|text|]);
                             | _ =>
                               let add =
                                 if (super_errors !== "") {
                                   [|super_errors|];
                                 } else {
                                   [|js_error_msg|];
                                 };
                               Js.Array2.concat(acc, add);
                             };
                           },
                         );

                       (errors, [||]);
                     | Comp(Success({warnings})) => ([||], [|warnings|])
                     | _ => (ready.errors, [||])
                     }
                   );

                 let availableTargetLangs =
                   Compiler.Api.Version.availableLanguages(
                     ready.selected.apiVersion,
                   );

                 let selectedTargetLang =
                   switch (ready.targetLang) {
                   | Res => (Compiler.Api.Res, ready.selected.compilerVersion)
                   | Reason => (Reason, ready.selected.reasonVersion)
                   | OCaml => (OCaml, ready.selected.ocamlVersion)
                   };

                 let onCompilerSelect = id => {
                   compilerDispatch(
                     SwitchToCompiler({
                       id,
                       libraries: ready.selected.libraries,
                     }),
                   );
                 };

                 let onTargetLangSelect = lang => {
                   compilerDispatch(
                     SwitchLanguage({
                       lang,
                       code: React.Ref.current(reasonCode),
                     }),
                   );
                 };

                 let onCompileClick = () => {
                   compilerDispatch(
                     CompileCode(
                       ready.targetLang,
                       React.Ref.current(reasonCode),
                     ),
                   );
                 };

                 // When a new compiler version was selected, it should
                 // be shown in the control panel as the currently selected
                 // version, even when it is currently loading
                 let compilerVersion =
                   switch (compilerState) {
                   | SwitchingCompiler(_, version, _) => version
                   | _ => ready.selected.id
                   };

                 let langSelectionDisabled =
                   Compiler.Api.(
                     switch (ready.result) {
                     | FinalResult.Conv(ConversionResult.Fail(_))
                     | Comp(CompilationResult.Fail(_)) => true
                     | _ => false
                     }
                   );

                 let (highlightedErrors, _) = highlightedErrorState;

                 let onFormatClick = () => {
                   compilerDispatch(Format(React.Ref.current(reasonCode)));
                 };

                 <>
                   <ControlPanel
                     compilerReady=isReady
                     langSelectionDisabled
                     compilerVersion
                     availableTargetLangs
                     availableCompilerVersions={ready.versions}
                     selectedTargetLang
                     loadedLibraries={ready.selected.libraries}
                     onCompilerSelect
                     onTargetLangSelect
                     onCompileClick
                     onFormatClick
                   />
                   <ErrorPane highlightedErrors errors warnings />
                 </>;
               | Init => "Initializing"->s
               | SetupFailed(msg) =>
                 let errors = [|"Setup failed: " ++ msg|];
                 <> <ErrorPane errors /> </>;
               }}
            </div>
            <div className="w-full">
              <CodeMirror
                className="w-full"
                minHeight="40vh"
                mode="javascript"
                lineWrapping=true
                value=jsOutput
                readOnly=true
              />
            </div>
          </div>
        </main>
      </div>
    </div>
  </>;
};
