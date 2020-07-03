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

module AnsiTerminal = {
  open Ansi;

  type colorTarget =
    | Fg
    | Bg;

  let mapColor = (~target: colorTarget, c: Color.t): string => {
    switch (target, c) {
    | (Fg, Black) => "text-black"
    | (Fg, Red) => "text-fire"
    | (Fg, Green) => "text-dark-code-3"
    | (Fg, Yellow) => "text-dark-code-1"
    | (Fg, Blue) => "text-dark-code-2"
    | (Fg, Magenta) => "text-berry"
    | (Fg, Cyan) => "text-dark-code-2"
    | (Fg, White) => "text-snow-dark"
    | (Bg, Black) => "bg-black"
    | (Bg, Red) => "bg-fire"
    | (Bg, Green) => "bg-dark-code-3"
    | (Bg, Yellow) => "bg-dark-code-1"
    | (Bg, Blue) => "bg-dark-code-2"
    | (Bg, Magenta) => "bg-berry"
    | (Bg, Cyan) => "bg-dark-code-2"
    | (Bg, White) => "bg-snow-dark"
    };
  };

  let renderSgrString = (sgrStr: SgrString.t): React.element => {
    let {SgrString.content, params} = sgrStr;

    let className =
      Belt.Array.reduce(params, "", (acc, p) => {
        switch (p) {
        | Sgr.Bold => acc ++ " bold"
        | Fg(c) => acc ++ " " ++ mapColor(~target=Fg, c)
        | Bg(c) => acc ++ " " ++ mapColor(~target=Bg, c)
        | _ => acc
        }
      });
    <span className> content->s </span>;
  };

  let renderLine = (tokens: array(Lexer.token)): React.element => {
    <div>
      {SgrString.fromTokens(tokens)->Belt.Array.map(renderSgrString)->ate}
    </div>;
  };

  /*
     Renders an array of ANSI encoded strings
     and applying the right styling for our design system
   */
  [@react.component]
  let make = (~className=?, ~children: array(string)) => {
    let lines = Belt.Array.map(children, line => line->Ansi.parse->renderLine);
    <div ?className> lines->ate </div>;
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
      | OCaml;

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
        | Fail(fail)
        | Success(success)
        | Unknown(string, raw)
        | None;

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
              | value => Unknown({j|.js_code is not a string: $value|j}, raw)
              }
            | (None, Some(type_)) =>
              switch (classify(type_)) {
              | JSONString("error") =>
                open! Json.Decode;
                switch (
                  {
                    js_error_msg: raw->field("js_error_msg", string, _),
                    super_errors,
                    row: raw->field("row", int, _),
                    column: raw->field("column", int, _),
                    endRow: raw->field("endRow", int, _),
                    endColumn: raw->field("endColumn", int, _),
                    text: raw->field("text", string, _),
                  }
                ) {
                | fail => Fail(fail)
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

    [@bs.val] [@bs.scope "reason"] external reasonVersion: string = "version";
    [@bs.val] [@bs.scope "ocaml"] external compilerVersion: string = "version";

    // TODO: We need to add this information in the actual bundle and retrieve it
    //       via external
    let ocamlVersion = "4.06.1";

    [@bs.val] [@bs.scope "ocaml"]
    external ocamlCompile: string => Js.Json.t = "compile_super_errors";

    [@bs.val] [@bs.scope "reason"]
    external reasonCompile: string => Js.Json.t = "compile_super_errors";

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
    compilerVersion: string,
    ocamlVersion: string,
    reasonVersion: string,
    libraries: array(string),
  };

  type ready = {
    versions: array(string),
    selected,
    errors: array(string),
    result: Api.CompilationResult.t,
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
                      let selected = {
                        id: latest,
                        compilerVersion: Api.compilerVersion,
                        ocamlVersion: Api.ocamlVersion,
                        reasonVersion: Api.reasonVersion,
                        libraries,
                      };
                      setState(_ => {
                        Ready({
                          selected,
                          versions,
                          errors: [||],
                          result: Api.CompilationResult.None,
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
              "https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@master/VERSIONS",
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

                let selected = {
                  id: version,
                  compilerVersion: Api.compilerVersion,
                  ocamlVersion: Api.ocamlVersion,
                  reasonVersion: Api.reasonVersion,
                  libraries,
                };
                setState(_ => {
                  Ready({
                    selected,
                    versions: ready.versions,
                    errors: [||],
                    result: Api.CompilationResult.None,
                  })
                });
              | Error(errs) =>
                let msg = Js.Array2.joinWith(errs, "; ");

                dispatchError(CompilerLoadingError(msg));
              }
            })
        | Compiling(ready, (lang, code)) =>
          let flush = Api.ConsoleCapture.captureErrorConsole();

          let jsonResult =
            switch (lang) {
            | Api.OCaml => Api.ocamlCompile(code)
            | Api.Reason => Api.reasonCompile(code)
            };

          // Retrieve the console.error output and append it
          // to the result if necessary
          let superErrors = flush();

          let result =
            Api.CompilationResult.classify(jsonResult, superErrors);

          setState(_ => {Ready({...ready, result})});
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
  [@react.component]
  let make = (~onChange, ~name, ~value, ~disabled, ~children) => {
    <select
      className="border border-night-light inline-block rounded px-4 py-1 bg-onyx appearance-none font-semibold"
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
  let make = (~errors: array(string), ~warnings: array(string)) => {
    let errorNumber = Belt.Array.length(errors);

    <div>
      <div>
        <div> {{j|Errors ($errorNumber)|j}}->s </div>
        <AnsiTerminal className="bg-onyx text-night-light">
          errors
        </AnsiTerminal>
      </div>
    </div>;
  };
};

module ControlPanel = {
  [@react.component]
  let make =
      (
        ~compilerReady: bool,
        ~compilerVersion: string,
        ~availableCompilerVersions: array(string),
        ~loadedLibraries: array(string),
        ~reasonVersion: string,
        ~onCompilerSelect: string => unit,
        ~onCompileClick: unit => unit,
      ) => {
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
        <div className="font-semibold"> "Reason "->s {reasonVersion}->s </div>
        <div className="font-semibold">
          "Bindings: "->s
          {switch (loadedLibraries) {
           | [||] => "No third party library loaded"->s
           | arr => Js.Array2.joinWith(arr, ", ")->s
           }}
        </div>
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

  let initialContent = {j|
  let a = 1 + "";
module Test2 = {
  [@react.component]
  let make = (~a: string, ~b: string) => {
    <div>
    </div>
  };
}

  |j};

  let jsOutput =
    switch (compilerState) {
    | Ready({result: Compiler.Api.CompilationResult.Success({js_output})}) => js_output
    | Ready({result: Compiler.Api.CompilationResult.Fail(_)}) => "/* Could not compile, check the error pane for details. */"
    | Ready({result: Compiler.Api.CompilationResult.None}) => "/* Compiler ready! Press the \"Compile\" button to see the JS output. */"
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
    };

  let isReady =
    switch (compilerState) {
    | Ready(_) => true
    | _ => false
    };

  let reasonCode = React.useRef(initialContent);

  let compilerErrors =
    switch (compilerState) {
    /*| Compiling({result: Fail({row, column, endColumn})}, _)*/
    | Ready({result: Fail({row, column, endColumn, endRow, text})}) => [|
        {CodeMirrorBase.row, column, endColumn, endRow, text},
      |]
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
                errors=compilerErrors
                value={React.Ref.current(reasonCode)}
                onChange={value => {React.Ref.setCurrent(reasonCode, value)}}
              />
              {switch (compilerState) {
               | Ready(ready)
               | Compiling(ready, _)
               | SwitchingCompiler(ready, _, _) =>
                 let (errors, warnings) =
                   switch (ready.result) {
                   | Fail({super_errors, js_error_msg}) =>
                     let errors =
                       if (super_errors !== "") {
                         [|super_errors|];
                       } else {
                         [|js_error_msg|];
                       };

                     (errors, [||]);
                   | Success({warnings}) => ([||], [|warnings|])
                   | _ => ([||], [||])
                   };

                 let onCompilerSelect = id => {
                   compilerDispatch(
                     SwitchToCompiler({
                       id,
                       libraries: ready.selected.libraries,
                     }),
                   );
                 };

                 let onCompileClick = () => {
                   compilerDispatch(
                     CompileCode(
                       Compiler.Api.Reason,
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

                 <>
                   <ControlPanel
                     compilerReady=isReady
                     compilerVersion
                     availableCompilerVersions={ready.versions}
                     loadedLibraries={ready.selected.libraries}
                     reasonVersion={ready.selected.reasonVersion}
                     onCompilerSelect
                     onCompileClick
                   />
                   <ErrorPane errors warnings />
                 </>;
               | Init => "Initializing"->s
               | SetupFailed(msg) => ("Setup failed: " ++ msg)->s
               }}
            </div>
            <div className="w-full">
              <CodeMirror
                className="w-full"
                minHeight="40vh"
                mode="javascript"
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
