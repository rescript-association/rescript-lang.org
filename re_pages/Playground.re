open Util.ReactStuff;

%raw
"require('../styles/main.css')";

/*
    TODO / Idea list:
    - Fix issue with Reason where a comment on the last line causes a infinite loop
    - Add settings pane to set moduleSystem
    - Add advanced mode for enabling OCaml output as well

    More advanced tasks:
    - Fix syntax convertion issue where comments are stripped on Reason <-> Res convertion
    - Try to get Reason's recoverable errors working
 */

open CompilerManagerHook;
module Api = Bs_platform_api;

module DropdownSelect = {
  type style = [ | `Error | `Normal];

  [@react.component]
  let make = (~onChange, ~name, ~value, ~disabled=false, ~children) => {
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

module LanguageToggle = {
  [@react.component]
  let make =
      (
        ~onChange: Api.Lang.t => unit,
        ~values: array(Api.Lang.t),
        ~selected: Api.Lang.t,
        ~disabled=false,
      ) => {
    // We make sure that there's at least one element in the array
    // otherwise we run into undefined behavior
    let values =
      if (Array.length(values) === 0) {
        [|selected|];
      } else {
        values;
      };

    let selectedIndex =
      switch (Belt.Array.getIndexBy(values, lang => {lang === selected})) {
      | Some(i) => i
      | None => 0
      };

    let elements =
      Belt.Array.mapWithIndex(
        values,
        (i, lang) => {
          let active = i === selectedIndex ? "text-fire" : "";
          let ext = Api.Lang.toExt(lang)->Js.String2.toUpperCase;

          <span key=ext className={"mr-1 last:mr-0 " ++ active}>
            ext->s
          </span>;
        },
      );

    let onMouseDown = evt => {
      ReactEvent.Mouse.preventDefault(evt);
      ReactEvent.Mouse.stopPropagation(evt);

      // Rotate through the array
      let nextIdx =
        selectedIndex < Array.length(values) - 1 ? selectedIndex + 1 : 0;

      switch (Belt.Array.get(values, nextIdx)) {
      | Some(lang) => onChange(lang)
      | None => ()
      };
    };

    // Required for iOS Safari 12
    let onClick = _ => ();

    <button
      className={
        (disabled ? "opacity-25" : "")
        ++ " border border-night-light inline-block rounded px-4 py-1 flex text-16"
      }
      disabled
      onMouseDown
      onClick>
      elements->ate
    </button>;
  };
};

module Pane = {
  type tab = {
    title: string,
    content: React.element,
  };

  // Classname is applied to a div element
  let defaultMakeTabClass = (active: bool): string => {
    let rest =
      active
        ? "text-fire font-medium bg-onyx hover:cursor-default"
        : "hover:cursor-pointer";

    "flex items-center text-16 h-12 px-4 pr-24 " ++ rest;
  };

  // tabClass: base class for bg color etc
  [@react.component]
  let make =
      (~disabled=false, ~tabs: array(tab), ~makeTabClass=defaultMakeTabClass) => {
    let (current, setCurrent) = React.useState(_ => 0);

    let headers =
      Belt.Array.mapWithIndex(
        tabs,
        (i, tab) => {
          let title = tab.title;
          let onMouseDown = evt => {
            ReactEvent.Mouse.preventDefault(evt);
            ReactEvent.Mouse.stopPropagation(evt);
            setCurrent(_ => i);
          };
          let active = current === i;
          // For Safari iOS12
          let onClick = _ => ();
          let className = makeTabClass(active);
          <button
            key={Belt.Int.toString(i) ++ "-" ++ title}
            onMouseDown
            onClick
            className
            disabled>
            title->s
          </button>;
        },
      );

    let body =
      switch (Belt.Array.get(tabs, current)) {
      | Some(tab) => tab.content
      | None => React.null
      };

    <div>
      <div>
        <div
          className={
            "flex bg-night-10 w-full " ++ (disabled ? "opacity-50" : "")
          }>
          headers->ate
        </div>
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
  module ActionIndicator = {
    [@react.component]
    let make = () => {
      <div className="animate-pulse"> "<!>"->s </div>;
    };
  };

  module PreWrap = {
    [@react.component]
    let make = (~className="", ~children) => {
      <pre className={"whitespace-pre-wrap " ++ className}> children </pre>;
    };
  };
  type prefix = [ | `W | `E];
  let compactErrorLine =
      (~highlight=false, ~prefix: prefix, locMsg: Api.LocMsg.t) => {
    let {Api.LocMsg.row, column, shortMsg} = locMsg;
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

  let filterHighlightedLocMsgs =
      (~focusedRowCol, locMsgs: array(Api.LocMsg.t)): array(Api.LocMsg.t) => {
    Api.LocMsg.(
      switch (focusedRowCol) {
      | Some(focusedRowCol) =>
        let (fRow, fCol) = focusedRowCol;
        let filtered =
          Belt.Array.keep(locMsgs, locMsg => {
            fRow === locMsg.row && fCol === locMsg.column
          });

        if (Array.length(filtered) === 0) {
          locMsgs;
        } else {
          filtered;
        };

      | None => locMsgs
      }
    );
  };

  let filterHighlightedLocWarnings =
      (~focusedRowCol, warnings: array(Api.Warning.t)): array(Api.Warning.t) => {
    switch (focusedRowCol) {
    | Some(focusedRowCol) =>
      let (fRow, fCol) = focusedRowCol;
      let filtered =
        Belt.Array.keep(warnings, warning => {
          switch (warning) {
          | Warn({details})
          | WarnErr({details}) =>
            fRow === details.row && fCol === details.column
          }
        });
      if (Array.length(filtered) === 0) {
        warnings;
      } else {
        filtered;
      };
    | None => warnings
    };
  };

  let renderResult =
      (
        ~compilerVersionGitCommit: option(string)=?,
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
        filterHighlightedLocMsgs(~focusedRowCol, locMsgs)
        ->Belt.Array.map(locMsg => {
            compactErrorLine(
              ~highlight=isHighlighted(~focusedRowCol?, locMsg),
              ~prefix=`E,
              locMsg,
            )
          })
        ->ate
      | WarningErr(warnings) =>
        filterHighlightedLocWarnings(~focusedRowCol, warnings)
        ->Belt.Array.map(warning => {
            let (prefix, details) =
              switch (warning) {
              | Api.Warning.Warn({details}) => (`W, details)
              | WarnErr({details}) => (`E, details)
              };
            compactErrorLine(
              ~highlight=isHighlighted(~focusedRowCol?, details),
              ~prefix,
              details,
            );
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
        filterHighlightedLocWarnings(~focusedRowCol, warnings)
        ->Belt.Array.map(warning => {
            let (prefix, details) =
              switch (warning) {
              | Api.Warning.Warn({details}) => (`W, details)
              | WarnErr({details}) => (`E, details)
              };
            compactErrorLine(
              ~highlight=isHighlighted(~focusedRowCol?, details),
              ~prefix,
              details,
            );
          })
        ->ate;
      }
    | Conv(Success({fromLang, toLang})) =>
      let msg =
        if (fromLang === toLang) {
          "Formatting completed with 0 errors";
        } else {
          let toStr = Api.Lang.toString(toLang);
          {j|Switched to $toStr with 0 errors|j};
        };
      <PreWrap> msg->s </PreWrap>;
    | Conv(Fail({fromLang, toLang, details})) =>
      let errs =
        filterHighlightedLocMsgs(~focusedRowCol, details)
        ->Belt.Array.map(locMsg => {
            compactErrorLine(
              ~highlight=isHighlighted(~focusedRowCol?, locMsg),
              ~prefix=`E,
              locMsg,
            )
          })
        ->ate;

      // The way the UI is currently designed, there shouldn't be a case where fromLang !== toLang.
      // We keep both cases though in case we change things later
      let msg =
        if (fromLang === toLang) {
          let langStr = Api.Lang.toString(toLang);
          {j|The code above is no valid $langStr syntax.|j};
        } else {
          let fromStr = Api.Lang.toString(fromLang);
          let toStr = Api.Lang.toString(toLang);
          {j|Could not convert from "$fromStr" to "$toStr" due to malformed syntax:|j};
        };
      <div> <PreWrap className="text-16 mb-4"> msg->s </PreWrap> errs </div>;
    | Comp(UnexpectedError(msg))
    | Conv(UnexpectedError(msg)) => msg->s
    | Comp(Unknown(msg, json))
    | Conv(Unknown(msg, json)) =>
      let subheader = "font-bold text-night-light text-16";
      <div>
        <PreWrap>
          "The compiler bundle API returned a result that couldn't be interpreted. Please open an issue on our "
          ->s
          <Markdown.A
            target="_blank"
            href="https://github.com/reason-association/rescript-lang.org/issues">
            "issue tracker"->s
          </Markdown.A>
          "."->s
        </PreWrap>
        <div className="mt-4">
          <PreWrap>
            <div className=subheader> "Message: "->s </div>
            msg->s
          </PreWrap>
        </div>
        <div className="mt-4">
          <PreWrap>
            <span className=subheader> "Received JSON payload:"->s </span>
            <div> {Util.Json.prettyStringify(json)->s} </div>
          </PreWrap>
        </div>
      </div>;
    | Nothing =>
      let syntax = Api.Lang.toString(targetLang);
      let fullVersion =
        switch (compilerVersionGitCommit) {
        | Some(gitCommit) => compilerVersion ++ " (" ++ gitCommit ++ ")"
        | None => compilerVersion
        };
      <PreWrap>
        {j|This playground is now running on compiler version $fullVersion with $syntax syntax|j}
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
      | Conv(UnexpectedError(_)) => (errClass, "Unexpected Error")
      | Comp(Unknown(_))
      | Conv(Unknown(_)) => (errClass, "Unknown Result")
      | Nothing => (okClass, "Ready")
      };

    <span className> text->s </span>;
  };

  [@react.component]
  let make =
      (
        ~actionIndicatorKey: string,
        ~targetLang: Api.Lang.t,
        ~compilerVersion: string,
        ~compilerVersionGitCommit: option(string)=?,
        ~focusedRowCol: option((int, int))=?,
        ~result: FinalResult.t,
      ) => {
    let activityIndicatorColor =
      switch (result) {
      | FinalResult.Comp(Fail(_))
      | Conv(Fail(_))
      | Comp(UnexpectedError(_))
      | Conv(UnexpectedError(_))
      | Comp(Unknown(_))
      | Conv(Unknown(_)) => "bg-fire-80"
      | Conv(Success(_))
      | Nothing => "bg-dark-code-3"
      | Comp(Success({warnings})) =>
        if (Array.length(warnings) === 0) {
          "bg-dark-code-3";
        } else {
          "bg-code-5";
        }
      };

    <div
      className="pt-4 bg-night-dark overflow-y-auto hide-scrollbar"
      style={ReactDOMRe.Style.make(
        ~minHeight="20rem",
        ~maxHeight="20rem",
        (),
      )}>
      <div className="flex items-center text-16 font-medium px-4">
        <div className="pr-4"> {renderTitle(result)} </div>
        <div
          key=actionIndicatorKey
          className={
            "animate-pulse block h-1 w-1 rounded-full "
            ++ activityIndicatorColor
          }
        />
      </div>
      <div className="">
        <div className="bg-night-dark text-snow-darker px-4 py-4">
          {renderResult(
             ~compilerVersionGitCommit?,
             ~focusedRowCol,
             ~compilerVersion,
             ~targetLang,
             result,
           )}
        </div>
      </div>
    </div>;
  };
};

// For console, settings etc
module MiscPanel = {
  module Console = {
    [@react.component]
    let make = () => {
      <div className="p-4 pt-8">
        <AnsiPre> "> console not implemented yet (coming soon)" </AnsiPre>
      </div>;
    };
  };

  [@bs.set] external scrollTop: (Dom.element, int) => unit = "scrollTop";
  [@bs.send] external focus: Dom.element => unit = "focus";
  [@bs.send]
  external scrollIntoView: (Dom.element, [@bs.as {json|false|json}] _) => unit =
    "scrollIntoView";

  [@bs.send] external blur: Dom.element => unit = "blur";

  [@bs.get] external scrollHeight: Dom.element => int = "scrollHeight";
  [@bs.get] external clientHeight: Dom.element => int = "clientHeight";
  [@bs.get] external scrollTop: Dom.element => int = "scrollTop";
  [@bs.get] external offsetTop: Dom.element => int = "offsetTop";
  [@bs.get] external offsetHeight: Dom.element => int = "offsetHeight";

  [@bs.set] external setScrollTop: (Dom.element, int) => unit = "scrollTop";

  // Inspired by MUI (who got inspired by WAI best practise examples)
  // https://github.com/mui-org/material-ui/blob/next/packages/material-ui-lab/src/useAutocomplete/useAutocomplete.js#L327
  let scrollToElement = (~parent: Dom.element, element: Dom.element): unit =>
    if (parent->scrollHeight > parent->clientHeight) {
      let scrollBottom = parent->clientHeight + parent->scrollTop;
      let elementBottom = element->offsetTop + element->offsetHeight;

      if (elementBottom > scrollBottom) {
        parent->setScrollTop(elementBottom - parent->clientHeight);
      } else if (element->offsetTop - element->offsetHeight < parent->scrollTop) {
        parent->setScrollTop(element->offsetTop - element->offsetHeight);
      };
    };

  module WarningFlagsWidget = {
    type suggestion =
      | NoSuggestion
      | FuzzySuggestions({
          modifier: string, // tells if the user is currently inputting a + / -
          // All tokens without the suggestion token (last one)
          precedingTokens: array(WarningFlagDescription.Parser.token),
          results: array((string, string)),
          selected: int,
        })
      | ErrorSuggestion(string);

    type state =
      | HideSuggestion({input: string})
      | ShowTokenHint({
          lastState: state, // For restoring the previous state
          token: WarningFlagDescription.Parser.token,
        }) // hover target
      | Typing({
          suggestion,
          input: string,
        });

    let hide = (prev: state) => {
      switch (prev) {
      | Typing({input})
      | ShowTokenHint({lastState: Typing({input})}) =>
        HideSuggestion({input: input})
      | ShowTokenHint(_) => HideSuggestion({input: ""})
      | HideSuggestion(_) => prev
      };
    };

    let updateInput = (prev: state, input: string) => {
      let suggestion =
        switch (input) {
        | "" => NoSuggestion
        | _ =>
          // Case: +
          let last = input->Js.String2.length - 1;
          switch (input->Js.String2.get(last)) {
          | "+" as modifier
          | "-" as modifier =>
            let results = WarningFlagDescription.lookupAll();

            let partial = input->Js.String2.substring(~from=0, ~to_=last);

            let precedingTokens =
              switch (WarningFlagDescription.Parser.parse(partial)) {
              | Ok(tokens) => tokens
              | Error(_) => [||]
              };

            FuzzySuggestions({
              modifier,
              precedingTokens,
              results,
              selected: 0,
            });
          | _ =>
            // Case: +1...
            let results = WarningFlagDescription.Parser.parse(input);
            switch (results) {
            | Ok(tokens) =>
              let last =
                Belt.Array.get(tokens, Belt.Array.length(tokens) - 1);

              switch (last) {
              | Some(token) =>
                let results = WarningFlagDescription.fuzzyLookup(token.flag);
                if (Belt.Array.length(results) === 0) {
                  ErrorSuggestion("No results");
                } else {
                  let precedingTokens =
                    Belt.Array.slice(
                      tokens,
                      ~offset=0,
                      ~len=Belt.Array.length(tokens) - 1,
                    );
                  let modifier = token.enabled ? "+" : "-";
                  FuzzySuggestions({
                    modifier,
                    precedingTokens,
                    results,
                    selected: 0,
                  });
                };
              | None => NoSuggestion
              };
            | Error(msg) =>
              // In case the user started with a + / -
              // show all available flags
              switch (input) {
              | "+" as modifier
              | "-" as modifier =>
                let results = WarningFlagDescription.lookupAll();

                FuzzySuggestions({
                  modifier,
                  precedingTokens: [||],
                  results,
                  selected: 0,
                });
              | _ => ErrorSuggestion(msg)
              }
            };
          };
        };

      switch (prev) {
      | ShowTokenHint(_)
      | Typing(_) => Typing({suggestion, input})
      | HideSuggestion(_) => Typing({suggestion, input})
      };
    };

    let selectPrevious = (prev: state) => {
      switch (prev) {
      | Typing(
          {suggestion: FuzzySuggestions({selected, results} as suggestion)} as typing,
        ) =>
        let nextIdx =
          if (selected > 0) {
            selected - 1;
          } else {
            Belt.Array.length(results) - 1;
          };
        Typing({
          ...typing,
          suggestion: FuzzySuggestions({...suggestion, selected: nextIdx}),
        });
      | ShowTokenHint(_)
      | Typing(_)
      | HideSuggestion(_) => prev
      };
    };

    let selectNext = (prev: state) => {
      switch (prev) {
      | Typing(
          {suggestion: FuzzySuggestions({selected, results} as suggestion)} as typing,
        ) =>
        let nextIdx =
          if (selected < Belt.Array.length(results) - 1) {
            selected + 1;
          } else {
            0;
          };
        Typing({
          ...typing,
          suggestion: FuzzySuggestions({...suggestion, selected: nextIdx}),
        });
      | ShowTokenHint(_)
      | Typing(_)
      | HideSuggestion(_) => prev
      };
    };

    [@react.component]
    let make =
        (
          ~onUpdate: array(WarningFlagDescription.Parser.token) => unit,
          ~flags: array(WarningFlagDescription.Parser.token),
        ) => {
      let (state, setState) =
        React.useState(_ => HideSuggestion({input: ""}));

      // Used for the suggestion box list
      let listboxRef = React.useRef(Js.Nullable.null);

      // Used for the text input
      let inputRef = React.useRef(Js.Nullable.null);

      let focusInput = () => {
        React.Ref.current(inputRef)
        ->Js.Nullable.toOption
        ->Belt.Option.forEach(el => el->focus);
      };

      let blurInput = () => {
        React.Ref.current(inputRef)
        ->Js.Nullable.toOption
        ->Belt.Option.forEach(el => el->blur);
      };

      let chips =
        Belt.Array.mapWithIndex(
          flags,
          (i, token) => {
            let {WarningFlagDescription.Parser.flag, enabled} = token;

            let isActive =
              switch (state) {
              | ShowTokenHint({token}) => token.flag === flag
              | _ => false
              };

            let full = (enabled ? "+" : "-") ++ flag;
            let color =
              switch (enabled, isActive) {
              | (true, false) => "text-dark-code-3"
              | (false, false) => "text-fire"
              | (true, true) => "bg-night-light text-dark-code-3"
              | (false, true) => "bg-night-light text-fire"
              };

            let hoverEnabled =
              switch (state) {
              | ShowTokenHint(_)
              | Typing(_) => true
              | HideSuggestion(_) => false
              };

            let (onMouseEnter, onMouseLeave) =
              if (hoverEnabled) {
                let enter = evt => {
                  ReactEvent.Mouse.preventDefault(evt);
                  ReactEvent.Mouse.stopPropagation(evt);

                  setState(prev => {ShowTokenHint({token, lastState: prev})});
                };

                let leave = evt => {
                  ReactEvent.Mouse.preventDefault(evt);
                  ReactEvent.Mouse.stopPropagation(evt);

                  setState(prev => {
                    switch (prev) {
                    | ShowTokenHint({lastState}) => lastState
                    | _ => prev
                    }
                  });
                };
                (Some(enter), Some(leave));
              } else {
                (None, None);
              };

            let onClick = evt => {
              // Removes clicked token from the current flags
              ReactEvent.Mouse.preventDefault(evt);

              let remaining = Belt.Array.keep(flags, t => {t.flag !== flag});
              onUpdate(remaining);
            };

            <span
              onClick
              ?onMouseEnter
              ?onMouseLeave
              className={
                color
                ++ " hover:cursor-default text-16 inline-block border border-night-light rounded-full px-2 mr-1"
              }
              key={Belt.Int.toString(i) ++ flag}>
              full->s
            </span>;
          },
        )
        ->ate;

      let onKeyDown = evt => {
        let key = ReactEvent.Keyboard.key(evt);
        let ctrlKey = ReactEvent.Keyboard.ctrlKey(evt);

        let caretPosition = ReactEvent.Keyboard.target(evt)##selectionStart;
        /*Js.log2("caretPosition", caretPosition);*/

        let full = (ctrlKey ? "CTRL+" : "") ++ key;
        switch (full) {
        | "Enter" =>
          switch (state) {
          | Typing({
              suggestion:
                FuzzySuggestions({
                  precedingTokens,
                  modifier,
                  selected,
                  results,
                }),
            }) =>
            // In case a selection was made correctly, add
            // the flag to the current flags
            switch (Belt.Array.get(results, selected)) {
            | Some((num, _)) =>
              let token = {
                WarningFlagDescription.Parser.enabled: modifier === "+",
                flag: num,
              };

              // TODO: merge tokens with flags
              let newTokens = Belt.Array.concat(precedingTokens, [|token|]);

              let all = WarningFlagDescription.Parser.merge(flags, newTokens);

              onUpdate(all);
              setState(prev => updateInput(prev, ""));
            | None => ()
            }
          | _ => ()
          };
          ReactEvent.Keyboard.preventDefault(evt);
        | "Escape" => blurInput()
        | "Tab" =>
          switch (state) {
          | Typing({
              suggestion:
                FuzzySuggestions({
                  modifier,
                  precedingTokens,
                  selected,
                  results,
                }),
            }) =>
            switch (Belt.Array.get(results, selected)) {
            | Some((num, _)) =>
              let flag = modifier ++ num;

              let completed =
                WarningFlagDescription.Parser.tokensToString(precedingTokens)
                ++ flag;
              setState(prev => updateInput(prev, completed));
            | None => ()
            };
            // Prevents tab to change focus
            ReactEvent.Keyboard.preventDefault(evt);
          | _ => ()
          }
        | "ArrowDown"
        | "CTRL+n" =>
          setState(prev => selectNext(prev));
          ReactEvent.Keyboard.preventDefault(evt);
        | "ArrowUp"
        | "CTRL+p" =>
          setState(prev => selectPrevious(prev));
          ReactEvent.Keyboard.preventDefault(evt);
        | "ArrowRight"
        | "ArrowLeft" => ()
        | full =>
          switch (state) {
          | Typing({suggestion: ErrorSuggestion(_)}) =>
            if (full !== "Backspace") {
              ReactEvent.Keyboard.preventDefault(evt);
            }
          | _ => Js.log(full)
          }
        };
      };

      let suggestions =
        switch (state) {
        | ShowTokenHint({token}) =>
          WarningFlagDescription.lookup(token.flag)
          ->Belt.Array.map(((num, description)) => {
              let (modifier, color) =
                if (token.enabled) {
                  ("(Enabled) ", "text-dark-code-3");
                } else {
                  ("(Disabled) ", "text-fire");
                };

              <div key=num>
                <span className=color> modifier->s </span>
                description->s
              </div>;
            })
          ->ate
          ->Some
        | Typing(typing) =>
          let suggestions =
            switch (typing.suggestion) {
            | NoSuggestion =>
              "Type + / - followed by a number or letter (e.g. +a+1)"->s
            | ErrorSuggestion(msg) => msg->s
            | FuzzySuggestions({precedingTokens, selected, results, modifier}) =>
              Belt.Array.mapWithIndex(
                results,
                (i, (flag, desc)) => {
                  let activeClass = selected === i ? "bg-night-light" : "";

                  let ref =
                    if (selected === i) {
                      ReactDOMRe.Ref.callbackDomRef(dom => {
                        let el = Js.Nullable.toOption(dom);
                        let parent =
                          React.Ref.current(listboxRef)->Js.Nullable.toOption;

                        switch (parent, el) {
                        | (Some(parent), Some(el)) =>
                          scrollToElement(~parent, el)
                        | _ => ()
                        };
                      })
                      ->Some;
                    } else {
                      None;
                    };

                  let onMouseEnter = evt => {
                    ReactEvent.Mouse.preventDefault(evt);
                    setState(prev => {
                      switch (prev) {
                      | Typing({
                          suggestion: FuzzySuggestions(fuzzySuggestion),
                        }) =>
                        Typing({
                          ...typing,
                          suggestion:
                            FuzzySuggestions({
                              ...fuzzySuggestion,
                              selected: i,
                            }),
                        })
                      | _ => prev
                      }
                    });
                  };

                  let onClick = evt => {
                    ReactEvent.Mouse.preventDefault(evt);
                    setState(prev => {
                      switch (prev) {
                      | Typing(_) =>
                        let full = modifier ++ flag;
                        let completed =
                          WarningFlagDescription.Parser.tokensToString(
                            precedingTokens,
                          )
                          ++ full;
                        updateInput(prev, completed);
                      | _ => prev
                      }
                    });
                  };

                  <div
                    ?ref
                    onMouseEnter
                    onMouseDown=onClick
                    className=activeClass
                    key=flag>
                    {{
                       modifier ++ flag ++ ": " ++ desc;
                     }
                     ->s}
                  </div>;
                },
              )
              ->ate
            };
          Some(suggestions);
        | HideSuggestion(_) => None
        };

      let suggestionBox =
        Belt.Option.map(suggestions, elements => {
          <div
            ref={ReactDOMRe.Ref.domRef(listboxRef)}
            className="p-2 absolute overflow-auto z-50 border-b rounded border-l border-r block w-full bg-onyx"
            style={ReactDOMRe.Style.make(~maxHeight="15rem", ())}>
            elements
          </div>
        })
        ->Belt.Option.getWithDefault(React.null);

      let onChange = evt => {
        ReactEvent.Form.preventDefault(evt);
        let input = ReactEvent.Form.target(evt)##value;
        setState(prev => {updateInput(prev, input)});
      };

      let onBlur = evt => {
        ReactEvent.Focus.preventDefault(evt);
        ReactEvent.Focus.stopPropagation(evt);
        setState(prev => hide(prev));
      };

      let onFocus = evt => {
        let input = ReactEvent.Focus.target(evt)##value;
        setState(prev => updateInput(prev, input));
      };

      let isActive =
        switch (state) {
        | ShowTokenHint(_)
        | Typing(_) => true
        | HideSuggestion(_) => false
        };

      let deleteButton =
        switch (flags) {
        | [||]
        | [|{enabled: false, flag: "a"}|] => React.null
        | _ =>
          let onMouseDown = evt => {
            ReactEvent.Mouse.preventDefault(evt);
            onUpdate([|
              {WarningFlagDescription.Parser.enabled: false, flag: "a"},
            |]);
          };

          // For iOS12 compat
          let onClick = _ => ();
          let onFocus = evt => {
            ReactEvent.Focus.preventDefault(evt);
            ReactEvent.Focus.stopPropagation(evt);
          };

          <button
            onMouseDown
            onClick
            onFocus
            tabIndex=0
            className="focus:outline-none self-start focus:shadow-outline hover:cursor-pointer hover:bg-night-light p-2 rounded-full">
            <Icon.Close />
          </button>;
        };

      let activeClass =
        if (isActive) {"border-white"} else {"border-night-light"};

      let areaOnFocus = evt =>
        if (!isActive) {
          focusInput();
        };

      let inputValue =
        switch (state) {
        | ShowTokenHint({lastState: Typing({input})})
        | Typing({input}) => input
        | HideSuggestion({input}) => input
        | ShowTokenHint(_) => ""
        };

      <div tabIndex=(-1) className="relative" onFocus=areaOnFocus onKeyDown>
        <div className={"flex justify-between border p-2 " ++ activeClass}>
          <div>
            chips
            <input
              ref={ReactDOMRe.Ref.domRef(inputRef)}
              className="outline-none bg-night-dark placeholder-snow-darker placeholder-opacity-50"
              placeholder="Flags"
              type_="text"
              tabIndex=0
              value=inputValue
              onChange
              onFocus
              onBlur
            />
          </div>
          deleteButton
        </div>
        suggestionBox
      </div>;
    };
  };

  module Settings = {
    [@react.component]
    let make = (~setConfig: Api.Config.t => unit, ~config: Api.Config.t) => {
      let {Api.Config.warn_flags, warn_error_flags} = config;

      let normalizeEmptyFlags = flags => {
        switch (flags) {
        | [||] => [|
            {WarningFlagDescription.Parser.enabled: false, flag: "a"},
          |]
        | other => other
        };
      };

      let onWarningFlagsUpdate = flags => {
        let config = {
          ...config,
          warn_flags:
            flags
            ->normalizeEmptyFlags
            ->WarningFlagDescription.Parser.tokensToString,
        };
        setConfig(config);
      };

      let onWarnErrFlagsUpdate = flags => {
        let config = {
          ...config,
          warn_error_flags:
            flags
            ->normalizeEmptyFlags
            ->WarningFlagDescription.Parser.tokensToString,
        };
        setConfig(config);
      };

      let warnFlagTokens =
        WarningFlagDescription.Parser.parse(warn_flags)
        ->Belt.Result.getWithDefault([||]);

      let warnErrFlagTokens =
        WarningFlagDescription.Parser.parse(warn_error_flags)
        ->Belt.Result.getWithDefault([||]);

      let onResetClick = evt => {
        ReactEvent.Mouse.preventDefault(evt);
        let defaultConfig = {
          Api.Config.module_system: "nodejs",
          warn_error_flags: "-a+5+6+101",
          warn_flags: "+a-4-9-20-40-41-42-50-61-102",
        };
        setConfig(defaultConfig);
      };

      <div className="p-4 pt-8 text-snow-darker">
        <div className="flex justify-end">
          <button onMouseDown=onResetClick className=Text.Link.standalone>
            "Reset"->s
          </button>
        </div>
        <div>
          <div> {("Module-System: " ++ config.module_system)->s} </div>
          <div>
            <div> "Warn-Flags: "->s </div>
            <WarningFlagsWidget
              onUpdate=onWarningFlagsUpdate
              flags=warnFlagTokens
            />
          </div>
          <div>
            <div> "Warn-Error-Flags: "->s </div>
            <WarningFlagsWidget
              onUpdate=onWarnErrFlagsUpdate
              flags=warnErrFlagTokens
            />
          </div>
        </div>
      </div>;
    };
  };

  [@react.component]
  let make = (~disabled=false, ~setConfig, ~config, ~className=?) => {
    let tabs = [|
      {Pane.title: "Console", content: <Console />},
      {title: "Settings", content: <Settings setConfig config />},
    |];

    let makeTabClass = (active: bool): string => {
      let rest =
        active
          ? "text-fire font-medium bg-night-dark hover:cursor-default"
          : "hover:cursor-pointer bg-night-10 text-night-light";

      "flex items-center h-12 px-4 pr-24 " ++ rest;
    };
    <div ?className> <Pane disabled makeTabClass tabs /> </div>;
  };
};

module ControlPanel = {
  [@react.component]
  let make =
      (
        ~isCompilerSwitching: bool,
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
          <span className="font-semibold mr-2"> "REV: "->s </span>
          <DropdownSelect
            name="compilerVersions"
            value=compilerVersion
            disabled=isCompilerSwitching
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
        <LanguageToggle
          values=availableTargetLangs
          selected=targetLang
          disabled=isCompilerSwitching
          onChange=onTargetLangSelect
        />
        <button
          className={
            (isCompilerSwitching ? "opacity-25" : "")
            ++ " font-semibold inline-block border border-night-light rounded py-1 px-4"
          }
          disabled=isCompilerSwitching
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
          disabled=isCompilerSwitching
          className={
            (isCompilerSwitching ? "opacity-25" : "")
            ++ " inline-block active:bg-sky-80 bg-sky text-16 text-white-80 rounded py-2 px-6"
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
  // We don't count to infinity. This value is only required to trigger
  // rerenders for specific components (ActivityIndicator)
  let (actionCount, setActionCount) = React.useState(_ => 0);
  let onAction = _ => {
    setActionCount(prev => prev > 1000000 ? 0 : prev + 1);
  };
  let (compilerState, compilerDispatch) = useCompilerManager(~onAction, ());

  let overlayState = React.useState(() => false);

  // The user can focus an error / warning on a specific line & column
  // which is stored in this ref and triggered by hover / click states
  // in the CodeMirror editor
  let (focusedRowCol, setFocusedRowCol) = React.useState(_ => None);

  let initialContent = {j|module A = {
  let = 1;
  let a = 1;
}

module B = {
  let = 2
  let b = 2
}|j};

  let initialContent = {j|// Please note:
// ---
// The Playground is still a work in progress
// ReScript / old Reason syntax should parse just
// fine.
//
// Feel free to play around and compile some
// ReScript code!

module Button = {
  @react.component
  let make = (~count: int) => {
    let times = switch count {
    | 1 => "once"
    | 2 => "twice"
    | n => Belt.Int.toString(n) ++ " times"
    }
    let msg = "Click me " ++ times

    <button> {msg->React.string} </button>
  }
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

  let editorCode = React.useRef(initialContent);

  /* In case the compiler did some kind of syntax conversion / reformatting,
     we take any success results and set the editor code to the new formatted code */
  switch (compilerState) {
  | Ready({result: FinalResult.Conv(Api.ConversionResult.Success({code}))}) =>
    React.Ref.setCurrent(editorCode, code)
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

  let editorTitle =
    switch (compilerState) {
    | SwitchingCompiler(ready, _, _)
    | Compiling(ready, _)
    | Ready(ready) =>
      switch (ready.targetLang) {
      | Reason => "ReasonML"
      | OCaml => "OCaml"
      | Res => "ReScript"
      }
    | _ => "..."
    };

  <>
    <Meta
      title="ReScript Playground"
      description="Try ReScript in the browser"
    />
    <div className="text-16 mb-32 mt-16 pt-2 bg-night-dark">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <main className="mx-10 mt-4 pb-32 flex justify-center">
          /* MOBILE PLACEHOLDER */

            <div className="block lg:hidden text-snow-darker text-center">
              <div className="font-bold mb-4">
                "Mobile Playground version not available yet."->s
              </div>
              <div>
                "Please use a screen with at least 1024px width for the desktop version"
                ->s
              </div>
            </div>
            <div className="hidden w-full lg:flex border-4 border-night" style=ReactDOMRe.Style.make(~maxWidth="112rem",())>
              <div
                className="w-full border-r-4 border-night"
                style={ReactDOMRe.Style.make(~maxWidth="56rem", ())}>
                <SingleTabPane title=editorTitle>
                  <div className="bg-onyx text-snow-darker">
                    <CodeMirror
                      className="w-full"
                      minHeight="40vh"
                      maxHeight="40vh"
                      mode="reason"
                      errors=cmErrors
                      value={React.Ref.current(editorCode)}
                      onChange={value => {
                        React.Ref.setCurrent(editorCode, value)
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
                     Api.Version.availableLanguages(
                       ready.selected.apiVersion,
                     );

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
                         code: React.Ref.current(editorCode),
                       }),
                     );
                   };

                   let onCompileClick = () => {
                     compilerDispatch(
                       CompileCode(
                         ready.targetLang,
                         React.Ref.current(editorCode),
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
                     compilerDispatch(
                       Format(React.Ref.current(editorCode)),
                     );
                   };

                   let actionIndicatorKey = Belt.Int.toString(actionCount);

                   let isCompilerSwitching =
                     switch (compilerState) {
                     | SwitchingCompiler(_, _, _) => true
                     | _ => false
                     };

                   let compilerVersionGitCommit =
                     Api.Compiler.version_git_commit(ready.selected.instance);
                   <>
                     <ControlPanel
                       isCompilerSwitching
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
                         actionIndicatorKey
                         targetLang={ready.targetLang}
                         compilerVersion={ready.selected.compilerVersion}
                         ?compilerVersionGitCommit
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
              <div
                className="w-full"
                style={ReactDOMRe.Style.make(~maxWidth="56rem", ())}>
                <SingleTabPane
                  title="JavaScript"
                  makeTabClass={active => {
                    let activeClass =
                      active
                        ? "text-fire font-medium bg-night-dark hover:cursor-default"
                        : "";

                    "flex items-center h-12 px-4 pr-16 " ++ activeClass;
                  }}>
                  <div className="w-full bg-night-dark text-snow-darker">
                    <CodeMirror
                      className="w-full"
                      minHeight="40vh"
                      maxHeight="40vh"
                      mode="javascript"
                      lineWrapping=true
                      value=jsOutput
                      readOnly=true
                    />
                  </div>
                </SingleTabPane>
                {switch (compilerState) {
                 | Ready(ready)
                 | Compiling(ready, _)
                 | SwitchingCompiler(ready, _, _) =>
                   let disabled =
                     switch (compilerState) {
                     | SwitchingCompiler(_, _, _) => true
                     | _ => false
                     };
                   let config = ready.selected.config;
                   let setConfig = config => {
                     compilerDispatch(UpdateConfig(config));
                   };

                   <MiscPanel
                     config
                     setConfig
                     disabled
                     className="border-t-4 border-night"
                   />;
                 | Init
                 | SetupFailed(_) => React.null
                 }}
              </div>
            </div>
          </main>
      </div>
    </div>
  </>;
};
