open Util.ReactStuff;

module CodeMirror = {
  type props = {
    .
    value: string,
    onChange: unit => unit,
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
  };

  type state =
    | Init
    | SetupFailed(string)
    | SwitchingCompiler((ready, string))
    | Ready(ready);

  type action =
    | SwitchToCompiler(string);

  module Api = {
    // This module establishes the communication to the
    // loaded bucklescript API exposed by the bs-platform-js
    // bundle

    // It is only safe to call these functions when a bundle
    // has been loaded so far, so we'd prefer to protect this
    // API with the compiler manager state

    [@bs.val] [@bs.scope "reason"] external reasonVersion: string = "version";
    [@bs.val] [@bs.scope "ocaml"] external compilerVersion: string = "version";
  };

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
          let onSuccess = data => {
            switch (parseVersions(data)) {
            | [||] =>
              dispatchError(SetupError({j|No compiler versions found|j}))
            | versions =>
              // Fetching the initial compiler is different, since we
              // don't have any running version downloaded yet
              let latest = versions[0];
              let src = getCompilerUrl(latest);
              let onSuccess = () => {
                setState(_ => {
                  Ready({selected: latest, versions, errors: [||]})
                });
              };
              let onError = err => {
                dispatchError(
                  CompilerLoadingError(
                    {j|Could not load compiler located at $src|j},
                  ),
                );
              };
              LoadScript.loadScript(~src, ~onSuccess, ~onError);
            };
            ();
          };

          let onError = err =>
            dispatchError(SetupError({j|Error occurred: $err|j}));

          SimpleRequest.(
            make(
              ~contentType=Plain,
              ~onSuccess,
              ~onError,
              "https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@latest/VERSIONS",
            )
            ->send
          );
        | SwitchingCompiler((ready, version)) =>
          let src = getCompilerUrl(version);
          let onSuccess = () => {
            // Make sure to remove the previous script from the DOM as well
            LoadScript.removeScript(~src=getCompilerUrl(ready.selected));

            setState(_ => {Ready({...ready, selected: version})});
          };
          let onError = err => {
            dispatchError(
              CompilerLoadingError(
                {j|Could not load compiler located at $src|j},
              ),
            );
          };
          LoadScript.loadScript(~src, ~onSuccess, ~onError);
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
module State = {
  type error =
    | CompilerVersionsError(string)
    | LoadingCompilerError(string);

  type t =
    | LoadingCompilerVersions
    | LoadingCompilerVersionsError(string)
    | LoadingCompiler({
        version: string,
        versions: array(string),
      })
    | Error(error)
    | Ready({
        versions: array(string),
        version: string,
      });
};

[@react.component]
let default = () => {
  let (state, dispatch) = Compiler.useCompilerManager();

  Js.log2("state", state);
  let overlayState = React.useState(() => false);

  let codemirror =
    React.createElement(
      CodeMirror.dynamicComponent,
      {"value": "let a = 1;", "onChange": () => ()},
    );

  <>
    <Meta
      title="Reason Playground"
      description="Try ReasonML in the browser"
    />
    <div className="mb-32 mt-16 pt-2">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <main className="mx-10 mt-16">
          codemirror
          <h3 className=Text.H3.default> "Compiler Debugging:"->s </h3>
          {switch (state) {
           | Ready(ready) =>
             <>
               <p> "Selected Version:"->s ready.selected->s </p>
               <ul>
                 {Belt.Array.map(
                    ready.versions,
                    version => {
                      let onClick = evt => {
                        ReactEvent.Mouse.preventDefault(evt);
                        dispatch(SwitchToCompiler(version));
                      };
                      <li key=version onClick> version->s </li>;
                    },
                  )
                  ->ate}
               </ul>
             </>
           | SwitchingCompiler((_, version)) =>
             ("Switching to " ++ version)->s
           | _ => "Initializing"->s
           }}
        </main>
      </div>
    </div>
  </>;
};
