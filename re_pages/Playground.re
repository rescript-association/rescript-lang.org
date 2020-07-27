open Util.ReactStuff;

%raw
"require('../styles/main.css')";

open CompilerManagerHook;
module Api = Bs_platform_api;

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
  [@react.component]
  let make =
      (
        ~compilerReady: bool,
        ~langSelectionDisabled: bool, // In case a syntax conversion error occurred
        ~compilerVersion: string,
        ~availableCompilerVersions: array(string),
        ~availableTargetLangs: array(Api.Lang.t),
        ~selectedTargetLang: (Api.Lang.t, string), // (lang, version)
        ~loadedLibraries: array(string),
        ~onCompilerSelect: string => unit,
        ~onFormatClick: option(unit => unit)=?,
        ~formatDisabled: bool=false,
        ~onCompileClick: unit => unit,
        ~onTargetLangSelect: Api.Lang.t => unit,
      ) => {
    let (targetLang, targetLangVersion) = selectedTargetLang;

    let targetLangName = Api.Lang.toString(targetLang);

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
              | "New BS Syntax" => Api.Lang.Res
              | "Reason" => Reason
              | "OCaml" => OCaml
              | _ => Reason
              };
            onTargetLangSelect(lang);
          }}>
          {Belt.Array.map(
             availableTargetLangs,
             lang => {
               let langStr = Api.Lang.toString(lang);
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

let warningsToLocMsgs = warnings =>
  Belt.Array.reduce(
    warnings,
    [||],
    (acc, next) => {
      switch (next) {
      | Api.Warning.Warn({details})
      | WarnErr({details}) => Js.Array2.push(acc, details)->ignore
      };
      acc;
    },
  );

let getErrorsAndWarningsFromResult =
    (result: FinalResult.t): (array(string), array(string)) => {
  open Api;
  let (errors, warnings) = {
    let locMsgs =
      switch (result) {
      | FinalResult.Comp(Fail(result)) =>
        switch (result) {
        | SyntaxErr(locMsgs)
        | TypecheckErr(locMsgs)
        | OtherErr(locMsgs) => locMsgs
        | WarningErr(warnings) =>
          Belt.Array.reduce(
            warnings,
            [||],
            (acc, next) => {
              switch (next) {
              | Api.Warning.Warn({details})
              | WarnErr({details}) => Js.Array2.push(acc, details)->ignore
              };
              acc;
            },
          )
        | WarningFlagErr(_) => [||]
        }
      | Conv(Fail({details})) => details
      | Comp(_)
      | Conv(_)
      | Nothing => [||]
      };

    /*
     let initial =
       switch (result) {
       | Conv(Fail(locMsgs)) =>
         switch (result) {
         | FinalResult.Conv(Fail({fromLang, toLang})) =>
           let msg =
             if (fromLang === toLang) {
               let fromStr = Lang.toString(fromLang);
               {j|Cannot format "$fromStr" code because of following syntax errors:|j};
             } else {
               let fromStr = Lang.toString(fromLang);
               let toStr = Lang.toString(toLang);
               {j|Cannot switch "$fromStr" to "$toStr" because of syntax errors:|j};
             };

           [|msg|];
         | _ => [||]
         }
       | _ => [||]
       };
       */

    let errors =
      Belt.Array.map(locMsgs, locMsg => {
        Api.LocMsg.toCompactErrorLine(~prefix=`E, locMsg)
      });

    let warnings =
      switch (result) {
      | FinalResult.Comp(Success({warnings}))
      | Comp(Fail(WarningErr(warnings))) =>
        warnings->Belt.Array.map(Warning.toCompactErrorLine)
      | Comp(_)
      | Conv(_)
      | Nothing => [||]
      };

    (errors, warnings);
  };
  (errors, warnings);
};

[@react.component]
let default = () => {
  let (compilerState, compilerDispatch) = useCompilerManager();

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
    Api.(
      switch (compilerState) {
      | Init => "/* Initializing Playground... */"
      | Ready({result: FinalResult.Comp(comp)}) =>
        switch (comp) {
        | CompilationResult.Success({js_code}) => js_code
        | UnexpectedError(msg)
        | Unknown(msg, _) => {j|/* Unexpected Result: $msg */|j}
        | Fail(_) => "/* Could not compile, check the error pane for details. */"
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
  switch (compilerState) {
  | Ready({result: FinalResult.Conv(Api.ConversionResult.Success({code}))}) =>
    React.Ref.setCurrent(reasonCode, code)
  | _ => ()
  };

  Js.log2("state", compilerState);

  let cmErrors =
    switch (compilerState) {
    | Ready({result}) =>
      let locMsgs =
        switch (result) {
        | FinalResult.Comp(Fail(result)) =>
          switch (result) {
          | SyntaxErr(locMsgs)
          | TypecheckErr(locMsgs)
          | OtherErr(locMsgs) => locMsgs
          | WarningErr(warnings) =>
            Belt.Array.reduce(
              warnings,
              [||],
              (acc, next) => {
                switch (next) {
                | Api.Warning.Warn({details})
                | WarnErr({details}) => Js.Array2.push(acc, details)->ignore
                };
                acc;
              },
            )
          | WarningFlagErr(_) => [||]
          }
        | Conv(Fail({details})) => details
        | Comp(_)
        | Conv(_)
        | Nothing => [||]
        };
      Belt.Array.map(locMsgs, ({row, column, endColumn, endRow, shortMsg}) => {
        {CodeMirrorBase.row, column, endColumn, endRow, text: shortMsg}
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
                   getErrorsAndWarningsFromResult(ready.result);
                 let availableTargetLangs =
                   Api.Version.availableLanguages(ready.selected.apiVersion);

                 let selectedTargetLang =
                   switch (ready.targetLang) {
                   | Res => (Api.Lang.Res, ready.selected.compilerVersion)
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
                   Api.(
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
