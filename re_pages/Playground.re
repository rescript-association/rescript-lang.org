open Util.ReactStuff;

module CodeMirror = {
  type editor;
  type props = {
    .
    value: string,
    onChange: (editor, string, string) => unit // (editor, data, value) => {}
  };

  // Codemirror relies heavily on Browser APIs, so we need to disable
  // SSR for this specific component and use the dynamic loading mechanism
  // to run this component clientside only
  let dynamicComponent: React.component(Js.t(props)) =
    Next.Dynamic.(
      dynamic(
        () => import("../ffi/react-codemirror"),
        options(~ssr=true, ()),
      )
    );
};

module LoadScript = {
  type err;
  [@bs.module "../ffi/loadScript"]
  external loadScript:
    (~src: string, ~onSuccess: unit => unit, ~onError: err => unit) => unit =
    "default";

  [@bs.module "../ffi/loadScript"]
  external removeScript: (~src: string) => unit = "removeScript";
};

module Compiler = {
  /*
      This module is intended to manage following things:
      - Loading available versions of bs-platform-js releases
      - Loading actual bs-platform-js bundles on demand
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

      type fail = {
        js_error_msg: string,
        row: int,
        column: int,
        endRow: int,
        endColumn: int,
        text: string,
      };

      type t =
        | Fail(fail)
        | Success(string)
        | Unknown(string, raw)
        | None;

      let classify = (raw: raw): t => {
        Js.Json.(
          switch (raw->classify) {
          | JSONObject(root) =>
            let type_ = Js.Dict.get(root, "type");
            let jsCode = Js.Dict.get(root, "js_code");

            switch (jsCode, type_) {
            | (Some(json), None) =>
              switch (classify(json)) {
              | JSONString(jscode) => Success(jscode)
              | value => Unknown({j|.js_code is not a string: $value|j}, raw)
              }
            | (None, Some(type_)) =>
              switch (classify(type_)) {
              | JSONString("error") =>
                open! Json.Decode;
                switch (
                  {
                    js_error_msg: raw->field("js_error_msg", string, _),
                    row: raw->field("js_error_msg", int, _),
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

    [@bs.val] [@bs.scope "ocaml"]
    external ocamlCompile: string => Js.Json.t = "compile";

    [@bs.val] [@bs.scope "reason"]
    external reasonCompile: string => Js.Json.t = "compile";
  };

  // Splits and sanitizes the content of the VERSIONS file
  let parseVersions = (versions: string) => {
    Js.String2.split(versions, "\n")->Js.Array2.filter(v => v !== "");
  };

  let getCompilerUrl = (version: string): string => {
    {j|https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@master/$version/compiler.js|j};
  };

  type error =
    | SetupError(string)
    | CompilerLoadingError(string);

  type ready = {
    versions: array(string),
    selected: string,
    errors: array(string),
    result: Api.CompilationResult.t,
  };

  type state =
    | Init
    | SetupFailed(string)
    | SwitchingCompiler((ready, string))
    | Ready(ready)
    | Compiling(ready, (Api.lang, string));

  type action =
    | SwitchToCompiler(string)
    | CompileCode(Api.lang, string);

  let useCompilerManager = () => {
    let (state, setState) = React.useState(_ => Init);

    // Dispatch method for the public interface
    let dispatch = (action: action): unit => {
      switch (action) {
      | SwitchToCompiler(target) =>
        switch (state) {
        | Ready(ready) =>
          if (ready.selected !== target) {
            setState(_ => SwitchingCompiler((ready, target)));
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
                let src = getCompilerUrl(latest);
                Js.log(src);
                let onSuccess = () => {
                  setState(_ => {
                    Ready({
                      selected: latest,
                      versions,
                      errors: [||],
                      result: Api.CompilationResult.None,
                    })
                  });
                };
                let onError = _err => {
                  dispatchError(
                    CompilerLoadingError(
                      {j|Could not load compiler located at $src|j},
                    ),
                  );
                };
                LoadScript.loadScript(~src, ~onSuccess, ~onError);
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
        | SwitchingCompiler((ready, version)) =>
          let src = getCompilerUrl(version);
          let onSuccess = () => {
            // Make sure to remove the previous script from the DOM as well
            LoadScript.removeScript(~src=getCompilerUrl(ready.selected));

            setState(_ => {Ready({...ready, result: None, selected: version})});
          };
          let onError = _err => {
            dispatchError(
              CompilerLoadingError(
                {j|Could not load compiler located at $src|j},
              ),
            );
          };
          LoadScript.loadScript(~src, ~onSuccess, ~onError);
        | Compiling(ready, (lang, code)) =>
          let result =
            (
              switch (lang) {
              | Api.OCaml => Api.ocamlCompile(code)
              | Api.Reason => Api.reasonCompile(code)
              }
            )
            ->Api.CompilationResult.classify;

          Js.log2("result", result);
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

// Playground state
module State = {};

[@react.component]
let default = () => {
  let (compilerState, compilerDispatch) = Compiler.useCompilerManager();

  let overlayState = React.useState(() => false);

  let (reasonContent, setReasonContent) = React.useState(() => "");

  let reasonEditor =
    React.createElement(
      CodeMirror.dynamicComponent,
      {
        "value": reasonContent,
        "onChange":
          Util.Debounce.debounce3(
            ~wait=300,
            ~immediate=true,
            (_editor, _data, value: string) => {
              setReasonContent(_ => value);
              ();
            },
          ),
      },
    );

  let output =
    switch (compilerState) {
    | Ready({result: Compiler.Api.CompilationResult.Success(output)}) => output
    | _ => ""
    };

  Js.log2("output:", output);

  let outputEditor =
    React.createElement(
      CodeMirror.dynamicComponent,
      {"value": output, "onChange": (_, _, _) => ()},
    );

  let code = "let a = 1 + 1";

  let isReady =
    switch (compilerState) {
    | Ready(_) => true
    | _ => false
    };

  Js.log2("editor content: ", reasonContent);
  Js.log(compilerState);
  <>
    <Meta
      title="Reason Playground"
      description="Try ReasonML in the browser"
    />
    <div className="mb-32 mt-16 pt-2">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <main className="mx-10 mt-16">
          <button
            disabled={!isReady}
            onClick={evt => {
              ReactEvent.Mouse.preventDefault(evt);
              compilerDispatch(CompileCode(Compiler.Api.Reason, code));
            }}>
            "Compile"->s
          </button>
          <div className="flex">
            <div className="w-1/2 mr-4"> reasonEditor </div>
            <div className="w-1/2"> outputEditor </div>
          </div>
          <h3 className=Text.H3.default> "Compiler Debugging:"->s </h3>
          {switch (compilerState) {
           | Ready(ready) =>
             <>
               <p> "Selected Version:"->s ready.selected->s </p>
               <ul>
                 {Belt.Array.map(
                    ready.versions,
                    version => {
                      let onClick = evt => {
                        ReactEvent.Mouse.preventDefault(evt);
                        compilerDispatch(SwitchToCompiler(version));
                      };
                      <li key=version onClick> version->s </li>;
                    },
                  )
                  ->ate}
               </ul>
             </>
           | SwitchingCompiler((_, version)) =>
             ("Switching to " ++ version)->s
           | Init => "Initializing"->s
           | SetupFailed(msg) => ("Setup failed: " ++ msg)->s
           | Compiling(_, (lang, _)) =>
             switch (lang) {
             | OCaml => "Compiling OCaml..."->s
             | Reason => "Compiling Reason..."->s
             }
           }}
        </main>
      </div>
    </div>
  </>;
};
