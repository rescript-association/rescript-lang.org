open Util.ReactStuff;

%raw
"require('../styles/main.css')";

/*
    TODO / Idea list:
    - Refactor ErrorPane so it can render locMsgs instead of strings
    - Convert language dropdown to toggle component
    - Allow syntax switching on errornous syntax
    - Add settings pane to set moduleSystem
 */

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

module Pane = {
  type tab = {
    title: string,
    content: React.element,
  };

  let defaultMakeTabClass = (active: bool): string => {
    let activeClass = active ? "text-fire font-medium bg-onyx" : "";

    "flex items-center h-12 px-4 pr-16 " ++ activeClass;
  };

  // tabClass: base class for bg color etc
  [@react.component]
  let make = (~tabs: array(tab), ~makeTabClass=defaultMakeTabClass) => {
    let (current, setCurrent) = React.useState(_ => 0);

    let headers =
      Belt.Array.mapWithIndex(
        tabs,
        (i, tab) => {
          let title = tab.title;
          let onClick = evt => {
            ReactEvent.Mouse.preventDefault(evt);
            setCurrent(_ => i);
          };
          let active = current === i;
          let className = makeTabClass(active);
          <div key={string_of_int(i) ++ "-" ++ title} onClick className>
            title->s
          </div>;
        },
      );

    let body =
      switch (Belt.Array.get(tabs, current)) {
      | Some(tab) => tab.content
      | None => React.null
      };

    <div>
      <div>
        <div className="flex bg-night-10 w-full"> headers->ate </div>
        <div> body </div>
      </div>
    </div>;
  };
};

module SingleTabPane = {
  [@react.component]
  let make = (~title: string, ~makeTabClass=?, ~children) => {
    let tabs = [|{Pane.title, content: children}|];

    <Pane tabs ?makeTabClass />;
  };
};

module ErrorPane = {
  module PreWrap = {
    [@react.component]
    let make = (~children) => {
      <pre className="whitespace-pre-wrap"> children </pre>;
    };
  };
  type prefix = [ | `W | `E];
  let compactErrorLine =
      (~highlight=false, ~prefix: prefix, locMsg: Api.LocMsg.t) => {
    let {Api.LocMsg.row, column, shortMsg, fullMsg} = locMsg;
    let prefixColor =
      switch (prefix) {
      | `W => "text-code-5"
      | `E => "text-fire"
      };

    let prefixText =
      switch (prefix) {
      | `W => "[W]"
      | `E => "[E]"
      };

    let highlightClass =
      switch (highlight, prefix) {
      | (false, _) => ""
      | (true, `W) => "bg-gold-15"
      | (true, `E) => "bg-fire-15 rounded"
      };

    <div
      className="font-mono mb-4 pb-6 last:mb-0 last:pb-0 last:border-0 border-b border-night-light ">
      <div className={"p-2 " ++ highlightClass}>
        <span className=prefixColor> prefixText->s </span>
        <span className="font-medium text-night-light">
          {j| Line $row, column $column:|j}->s
        </span>
        <AnsiPre className="whitespace-pre-wrap "> shortMsg </AnsiPre>
      </div>
    </div>;
  };

  let isHighlighted = (~focusedRowCol=?, locMsg): bool => {
    switch (focusedRowCol) {
    | Some(focusedRowCol) =>
      let {Api.LocMsg.row, column} = locMsg;
      let (fRow, fCol) = focusedRowCol;

      fRow === row && fCol === column;

    | None => false
    };
  };

  let renderResult =
      (
        ~focusedRowCol: option((int, int)),
        ~targetLang: Api.Lang.t,
        ~compilerVersion: string,
        result: FinalResult.t,
      )
      : React.element => {
    switch (result) {
    | FinalResult.Comp(Fail(result)) =>
      switch (result) {
      | TypecheckErr(locMsgs)
      | OtherErr(locMsgs)
      | SyntaxErr(locMsgs) =>
        Belt.Array.map(locMsgs, locMsg => {
          compactErrorLine(
            ~highlight=isHighlighted(~focusedRowCol?, locMsg),
            ~prefix=`E,
            locMsg,
          )
        })
        ->ate
      | WarningErr(warnings) =>
        Belt.Array.map(warnings, next => {
          switch (next) {
          | Api.Warning.Warn({details})
          | WarnErr({details}) =>
            compactErrorLine(
              ~highlight=isHighlighted(~focusedRowCol?, details),
              ~prefix=`W,
              details,
            )
          }
        })
        ->ate
      | WarningFlagErr({msg}) =>
        <div>
          "There are some issues with your compiler flag configuration:"->s
          msg->s
        </div>
      }
    | Comp(Success({warnings})) =>
      if (Array.length(warnings) === 0) {
        <PreWrap> "0 Errors, 0 Warnings"->s </PreWrap>;
      } else {
        Belt.Array.map(warnings, next => {
          switch (next) {
          | Api.Warning.Warn({details})
          | WarnErr({details}) =>
            let warns =
              compactErrorLine(
                ~highlight=isHighlighted(~focusedRowCol?, details),
                ~prefix=`W,
                details,
              );
            <div> warns </div>;
          }
        })
        ->ate;
      }
    | Conv(Success({fromLang, toLang})) =>
      let msg =
        if (fromLang === toLang) {
          "Formating completed with 0 errors"
        } else {
          let toStr = Api.Lang.toString(toLang);
          {j|Switched to $toStr with 0 errors|j};
        };
      <PreWrap> msg->s </PreWrap>;
    | Conv(Fail({details})) =>
      Belt.Array.map(details, locMsg => {
        compactErrorLine(
          ~highlight=isHighlighted(~focusedRowCol?, locMsg),
          ~prefix=`E,
          locMsg,
        )
      })
      ->ate
    | Comp(UnexpectedError(msg))
    | Conv(UnexpectedError(msg)) => msg->s
    | Comp(Unknown(msg, json))
    | Conv(Unknown(msg, json)) =>
      <PreWrap>
        "This should not happen. Please report this as a bug."->s
        {Js.Json.stringify(json)->s}
      </PreWrap>
    | Nothing =>
      let syntax =
        switch (targetLang) {
        | Api.Lang.OCaml => "OCaml"
        | Res => "New BuckleScript"
        | Reason => "Reason"
        };
      <PreWrap>
        {j|This playground is now running on compiler version $compilerVersion with the $syntax syntax|j}
        ->s
      </PreWrap>;
    };
  };

  let renderTitle = result => {
    let errClass = "text-fire";
    let warnClass = "text-code-5";
    let okClass = "text-dark-code-3";

    let (className, text) =
      switch (result) {
      | FinalResult.Comp(Fail(result)) =>
        switch (result) {
        | SyntaxErr(_) => (errClass, "Syntax Errors")
        | TypecheckErr(_) => (errClass, "Type Errors")
        | WarningErr(_) => (warnClass, "Warning Errors")
        | WarningFlagErr(_) => (errClass, "Config Error")
        | OtherErr(_) => (errClass, "Errors")
        }
      | Conv(Fail(_)) => (errClass, "Syntax Errors")
      | Comp(Success({warnings})) =>
        if (Belt.Array.length(warnings) === 0) {
          (okClass, "Compilation Successful");
        } else {
          (warnClass, "Success with Warnings");
        }
      | Conv(Success(_)) => (okClass, "Format Successful")
      | Comp(UnexpectedError(_))
      | Conv(UnexpectedError(_))
      | Comp(Unknown(_))
      | Conv(Unknown(_)) => (errClass, "Errors")
      | Nothing => (okClass, "Ready")
      };

    <span className> text->s </span>;
  };

  [@react.component]
  let make =
      (
        ~targetLang: Api.Lang.t,
        ~compilerVersion: string,
        ~focusedRowCol: option((int, int))=?,
        ~result: FinalResult.t,
      ) => {
    let (errors, warnings) = getErrorsAndWarningsFromResult(result);
    let errorNumber = Belt.Array.length(errors);

    let _ =
      <div className="pt-4 bg-night-dark">
        <div className="text-fire font-medium px-4"> "Errors"->s </div>
        <div
          style={ReactDOMRe.Style.make(~maxHeight="17rem", ())} className="">
          <div className="bg-night-dark text-snow-darker px-4 py-4">
            {errors
             ->Belt.Array.mapWithIndex((i, line) => {
                 <AnsiPre
                   className="whitespace-pre-wrap mb-4 pb-2 last:mb-0 last:pb-0 last:border-0 border-b border-night-light"
                   key={Belt.Int.toString(i)}>
                   line
                 </AnsiPre>
               })
             ->ate}
            {warnings
             ->Belt.Array.mapWithIndex((i, line) => {
                 <AnsiPre key={Belt.Int.toString(i)}> line </AnsiPre>
               })
             ->ate}
          </div>
        </div>
      </div>;

    <div className="pt-4 bg-night-dark">
      <div className="flex items-center text-16 font-medium px-4 pr-16">
        {renderTitle(result)}
      </div>
      <div style={ReactDOMRe.Style.make(~maxHeight="17rem", ())} className="">
        <div className="bg-night-dark text-snow-darker px-4 py-4">
          {renderResult(~focusedRowCol, ~compilerVersion, ~targetLang, result)}
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

    <div className="flex bg-onyx text-night-light px-6 text-14 w-full">
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

let locMsgToCmError =
    (~kind: CodeMirrorBase.Error.kind, locMsg: Api.LocMsg.t)
    : CodeMirrorBase.Error.t => {
  let {Api.LocMsg.row, column, endColumn, endRow, shortMsg} = locMsg;
  {CodeMirrorBase.Error.row, column, endColumn, endRow, text: shortMsg, kind};
};

[@react.component]
let default = () => {
  let (compilerState, compilerDispatch) = useCompilerManager();

  let overlayState = React.useState(() => false);

  // The user can focus an error / warning on a specific line & column
  // which is stored in this ref and triggered by hover / click states
  // in the CodeMirror editor
  let (focusedRowCol, setFocusedRowCol) = React.useState(_ => None);

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
      switch (result) {
      | FinalResult.Comp(Fail(result)) =>
        switch (result) {
        | SyntaxErr(locMsgs)
        | TypecheckErr(locMsgs)
        | OtherErr(locMsgs) =>
          Belt.Array.map(locMsgs, locMsgToCmError(~kind=`Error))
        | WarningErr(warnings) =>
          Belt.Array.reduce(
            warnings,
            [||],
            (acc, next) => {
              switch (next) {
              | Api.Warning.Warn({details})
              | WarnErr({details}) =>
                let warn = locMsgToCmError(~kind=`Warning, details);
                Js.Array2.push(acc, warn)->ignore;
              };
              acc;
            },
          )
        | WarningFlagErr(_) => [||]
        }
      | Comp(Success({warnings})) =>
        Belt.Array.reduce(
          warnings,
          [||],
          (acc, next) => {
            switch (next) {
            | Api.Warning.Warn({details})
            | WarnErr({details}) =>
              let warn = locMsgToCmError(~kind=`Warning, details);
              Js.Array2.push(acc, warn)->ignore;
            };
            acc;
          },
        )
      | Conv(Fail({details})) =>
        Belt.Array.map(details, locMsgToCmError(~kind=`Error))
      | Comp(_)
      | Conv(_)
      | Nothing => [||]
      }
    | _ => [||]
    };

  <>
    <Meta
      title="Reason Playground"
      description="Try ReasonML in the browser"
    />
    <div className="text-16 mb-32 mt-16 pt-2 bg-night-dark">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <main className="mx-10 mt-16 pb-32 flex justify-center">
          <div className="flex max-w-1280 w-full border-4 border-night">
            <div className="w-full max-w-705 border-r-4 border-night">
              <SingleTabPane title="ReasonML">
                <div className="bg-onyx text-snow-darker">
                  <CodeMirror
                    className="w-full"
                    minHeight="40vh"
                    mode="reason"
                    errors=cmErrors
                    value={React.Ref.current(reasonCode)}
                    onChange={value => {
                      React.Ref.setCurrent(reasonCode, value)
                    }}
                    onMarkerFocus={rowCol => {
                      setFocusedRowCol(prev => {Some(rowCol)})
                    }}
                    onMarkerFocusLeave={_ => {setFocusedRowCol(_ => None)}}
                  />
                </div>
              </SingleTabPane>
              {switch (compilerState) {
               | Ready(ready)
               | Compiling(ready, _)
               | SwitchingCompiler(ready, _, _) =>
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
                   <div className="border-fire border-t-4">
                     <ErrorPane
                       targetLang={ready.targetLang}
                       compilerVersion={ready.selected.compilerVersion}
                       ?focusedRowCol
                       result={ready.result}
                     />
                   </div>
                 </>;
               | Init => "Initializing"->s
               | SetupFailed(msg) =>
                 let content = ("Setup failed: " ++ msg)->s;
                 let tabs = [|{Pane.title: "Error", content}|];
                 <> <Pane tabs /> </>;
               }}
            </div>
            <SingleTabPane
              title="JavaScript"
              makeTabClass={active => {
                let activeClass =
                  active ? "text-fire font-medium bg-night-dark" : "";

                "flex items-center h-12 px-4 pr-16 " ++ activeClass;
              }}>
              <div className="w-full bg-night-dark text-snow-darker">
                <CodeMirror
                  className="w-full"
                  minHeight="40vh"
                  mode="javascript"
                  lineWrapping=true
                  value=jsOutput
                  readOnly=true
                />
              </div>
            </SingleTabPane>
          </div>
        </main>
      </div>
    </div>
  </>;
};
