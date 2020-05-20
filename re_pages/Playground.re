open Util.ReactStuff;

module ReactScriptHook = {
  // See: https://github.com/hupe1980/react-script-hook
  [@bs.deriving abstract]
  type config = {
    src: string,
    [@bs.optional]
    onload: unit => unit,
    [@bs.optional]
    checkForExisting: bool,
  };

  type error;

  let isErr: error => bool = [%raw "(err) => err != null"];

  // let (loading, error) = useScript({src: "https://..."})
  [@bs.module "react-script-hook"]
  external useScript: config => (bool, error) = "default";
};

module CompilerState = {
  type t = {src: string};

  type loading =
    | NotStarted(t)
    | Loading(t)
    | Failed(t, string)
    | Success(t);

  let fromLoading = (loading: loading): t => {
    switch (loading) {
    | NotStarted(state) => state
    | Loading(state) => state
    | Failed(state, _) => state
    | Success(state) => state
    };
  };
};

[@react.component]
let default = () => {
  let latest = "https://cdn.jsdelivr.net/gh/ryyppy/bs-platform-js-releases@master/v8.0.0-dev.1/compiler.js";
  let (compilerLoadingState, setCompilerLoadingState) =
    React.useState(_ => CompilerState.NotStarted({src: latest}));

  let compilerState = CompilerState.fromLoading(compilerLoadingState);
  let (loading, error) =
    ReactScriptHook.(
      config(
        ~src=compilerState.src,
        ~onload=() => setCompilerLoadingState(_ => Success(compilerState)),
        ~checkForExisting=true,
        (),
      )
      ->useScript
    );

  React.useEffect2(
    () => {
      let newLoadingState =
        switch (loading, error) {
        | (true, err) =>
          if (ReactScriptHook.isErr(err)) {
            CompilerState.Failed(
              compilerState,
              "Some loading error occurred",
            );
          } else {
            CompilerState.Loading(compilerState);
          }
        | (false, err) =>
          if (ReactScriptHook.isErr(err)) {
            Failed(compilerState, "Some loading error occurred");
          } else {
            compilerLoadingState;
          }
        };
      setCompilerLoadingState(_ => newLoadingState);
      None;
    },
    (loading, error),
  );

  Js.log(compilerLoadingState);
  let overlayState = React.useState(() => false);

  <>
    <Meta
      title="Reason Playground"
      description="Try ReasonML in the browser"
    />
    <div className="mb-32 mt-16 pt-2">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <main className="mx-10 mt-16">
          <h3 className=Text.H3.default> "Playground Infos:"->s </h3>
          (
            switch (compilerLoadingState) {
            | Failed({src}, err) => {j|Could not load compiler from: $src ($err)|j}
            | Success({src}) => {j|Loaded compiler successfully from: $src|j}
            | Loading({src}) => {j|Loading compiler from: $src|j}
            | NotStarted(_) => {j|Waiting for the compiler download|j}
            }
          )
          ->s
        </main>
      </div>
    </div>
  </>;
};
