open Util.ReactStuff;

%raw
"require('../styles/main.css')";

module CodeMirror = {
  type editor;

  type props;

  [@bs.obj]
  external props:
    (
      ~value: string,
      ~mode: string,
      ~readOnly: bool=?,
      ~onBeforeChange: (editor, string, string) => unit=?, // (editor, data, value) => {}
      ~onChange: (editor, string, string) => unit=?,
      unit
    ) =>
    props;

  // Codemirror relies heavily on Browser APIs, so we need to disable
  // SSR for this specific component and use the dynamic loading mechanism
  // to run this component clientside only
  let dynamicComponent: React.component(props) =
    Next.Dynamic.(
      dynamic(
        () => import("../ffi/react-codemirror"),
        options(~ssr=true, ()),
      )
    );

  [@react.component]
  let make =
      (~value="", ~mode, ~readOnly=false, ~onBeforeChange=?, ~onChange=?) => {
    React.createElement(
      dynamicComponent,
      props(~value, ~mode, ~readOnly, ~onBeforeChange?, ~onChange?, ()),
    );
  };
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
        Js.log2("raw", raw);
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

  type error =
    | SetupError(string)
    | CompilerLoadingError(string);

  type selected = {
    name: string, // The name used for loading the compiler bundle
    compilerVersion: string,
    ocamlVersion: string,
    reasonVersion: string,
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
          if (ready.selected.name !== target) {
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

                let onSuccess = () => {
                  let selected = {
                    name: latest,
                    compilerVersion: Api.compilerVersion,
                    ocamlVersion: Api.ocamlVersion,
                    reasonVersion: Api.reasonVersion,
                  };
                  setState(_ => {
                    Ready({
                      selected,
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
              "https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@master/VERSIONS",
            )
            ->send
          );
        | SwitchingCompiler((ready, version)) =>
          let src = getCompilerUrl(version);
          let onSuccess = () => {
            // Make sure to remove the previous script from the DOM as well
            LoadScript.removeScript(
              ~src=getCompilerUrl(ready.selected.name),
            );

            let selected = {
              name: version,
              compilerVersion: Api.compilerVersion,
              ocamlVersion: Api.ocamlVersion,
              reasonVersion: Api.reasonVersion,
            };

            setState(_ => {Ready({...ready, result: None, selected})});
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

module ErrorPane = {
  [@react.component]
  let make = (~errors: array(string), ~warnings: array(string)) => {
    let errorNumber = Belt.Array.length(errors);

    Js.log2("foo", errors);
    let errorElements =
      Belt.Array.map(errors, err => {<div> err->s </div>})->ate;
    <div>
      <div> <div> {{j|Errors ($errorNumber)|j}}->s </div> errorElements </div>
    </div>;
  };
};

[@react.component]
let default = () => {
  let (compilerState, compilerDispatch) = Compiler.useCompilerManager();

  let overlayState = React.useState(() => false);

  let initialContent = {j|type tree = Leaf | Node(int, tree, tree);

[@some.decorator]
let rec sum = (item) => {
  switch (item) {
  | Leaf => 0
  | Node(value, left, right) => value + sum(left) + sum(right);
  }
};

let myTree =
  Node(
    1,
    Node(2, Node(4, Leaf, Leaf), Node(6, Leaf, Leaf)),
    Node(3, Node(5, Leaf, Leaf), Node(7, Leaf, Leaf))
  );

Js.log(sum(myTree));

let test: string = "foobar";
let test2: string => string = (a) => a;

let test = ("foo": int);


module Test = {
  [@react.component]
  let make = (~a: string, ~b: string) => {
    <div>
    </div>
  };
}

  |j};

  let (reasonContent, setReasonContent) =
    React.useState(() => initialContent);

  let onReasonEditorChange =
    Util.Debounce.debounce3(
      ~wait=600,
      ~immediate=true,
      (_editor, _data, value: string) => {
        setReasonContent(_ => value);
        ();
      },
    );

  let output =
    switch (compilerState) {
    | Ready({result: Compiler.Api.CompilationResult.Success({js_output})}) => js_output
    | _ => ""
    };

  let isReady =
    switch (compilerState) {
    | Ready(_) => true
    | _ => false
    };

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
              compilerDispatch(
                CompileCode(Compiler.Api.Reason, reasonContent),
              );
            }}>
            "Compile"->s
          </button>
          <div className="flex h-2/3">
            <div className="w-1/2 mr-4">
              <CodeMirror
                mode="reason"
                value=reasonContent
                onChange=onReasonEditorChange
              />
            </div>
            <div className="w-1/2">
              <CodeMirror mode="javascript" value=output readOnly=true />
            </div>
          </div>
          <h3 className=Text.H3.default> "Compiler Debugging:"->s </h3>
          {switch (compilerState) {
           | Ready(ready) =>
             let (errors, warnings) =
               switch (ready.result) {
               | Fail({super_errors}) => ([|super_errors|], [||])
               | Success({warnings}) => ([||], [|warnings|])
               | _ => ([||], [||])
               };
             <>
               <p> "Selected Bundle:"->s ready.selected.name->s </p>
               <select
                 name="availableVersions"
                 value={ready.selected.name}
                 disabled={!isReady}
                 onChange={evt => {
                   ReactEvent.Form.preventDefault(evt);
                   let version = evt->ReactEvent.Form.target##value;
                   compilerDispatch(SwitchToCompiler(version));
                 }}>
                 {Belt.Array.map(ready.versions, version => {
                    <option key=version value=version> version->s </option>
                  })
                  ->ate}
               </select>
               <div className="flex">
                 <div> "BS: "->s {ready.selected.compilerVersion}->s </div>
                 <div> "Reason: "->s {ready.selected.reasonVersion}->s </div>
               </div>
               <ErrorPane errors warnings />
             </>;
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
