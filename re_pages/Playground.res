open Util.ReactStuff

%%raw("require('../styles/main.css')")

/*
    TODO / Idea list:
    - Fix issue with Reason where a comment on the last line causes a infinite loop
    - Add settings pane to set moduleSystem
    - Add advanced mode for enabling OCaml output as well

    More advanced tasks:
    - Fix syntax convertion issue where comments are stripped on Reason <-> Res convertion
    - Try to get Reason's recoverable errors working
 */

open CompilerManagerHook
module Api = RescriptCompilerApi

// Used for compressing / decompressing code for url sharing
module LzString = {
  @bs.module("lz-string")
  external compressToEncodedURIComponent: string => string = "compressToEncodedURIComponent"

  @bs.module("lz-string")
  external decompressToEncodedURIComponent: string => string = "decompressFromEncodedURIComponent"
}

module DropdownSelect = {
  type style = [#Error | #Normal]

  @react.component
  let make = (~onChange, ~name, ~value, ~disabled=false, ~children) => {
    let opacity = disabled ? " opacity-50" : ""
    <select
      className={"text-14 bg-transparent border border-night-light inline-block rounded px-4 py-1 font-semibold" ++
      opacity}
      name
      value
      disabled
      onChange>
      children
    </select>
  }
}

module ToggleSelection = {
  @react.component
  let make = (
    ~onChange: 'a => unit,
    ~values: array<'a>,
    ~toLabel: 'a => string,
    ~selected: 'a,
    ~disabled=false,
  ) => {
    // We make sure that there's at least one element in the array
    // otherwise we run into undefined behavior
    let values = if Array.length(values) === 0 {
      [selected]
    } else {
      values
    }

    let selectedIndex = switch Belt.Array.getIndexBy(values, lang => lang === selected) {
    | Some(i) => i
    | None => 0
    }

    let elements = Belt.Array.mapWithIndex(values, (i, value) => {
      let active = i === selectedIndex ? "bg-fire text-white font-bold" : "bg-gray-80 opacity-50"
      let label = toLabel(value)

      let onMouseDown = evt => {
        ReactEvent.Mouse.preventDefault(evt)
        ReactEvent.Mouse.stopPropagation(evt)

        if i !== selectedIndex {
          switch Belt.Array.get(values, i) {
          | Some(value) => onChange(value)
          | None => ()
          }
        }
      }

      // Required for iOS Safari 12
      let onClick = _ => ()

      <button
        disabled
        onMouseDown
        onClick
        key=label
        className={"mr-1 px-2 py-1 rounded inline-block  " ++ active}>
        {label->s}
      </button>
    })

    <div className={(disabled ? "opacity-25" : "") ++ "flex w-full"}> {elements->ate} </div>
  }
}

module Pane = {
  type tab = {
    title: string,
    content: React.element,
  }

  // Classname is applied to a div element
  let defaultMakeTabClass = (active: bool): string => {
    let rest = active
      ? "text-fire font-medium bg-gray-100 hover:cursor-default"
      : "hover:cursor-pointer"

    "flex items-center h-12 px-4 pr-24 " ++ rest
  }

  // tabClass: base class for bg color etc
  @react.component
  let make = (
    ~disabled=false,
    ~tabs: array<tab>,
    ~makeTabClass=defaultMakeTabClass,
    ~selected=0,
  ) => {
    let (current, setCurrent) = React.useState(_ =>
      if selected < 0 || selected >= Js.Array.length(tabs) {
        0
      } else {
        selected
      }
    )

    React.useEffect1(() => {
      setCurrent(_ => selected)
      None
    }, [selected])

    let headers = Belt.Array.mapWithIndex(tabs, (i, tab) => {
      let title = tab.title
      let onMouseDown = evt => {
        ReactEvent.Mouse.preventDefault(evt)
        ReactEvent.Mouse.stopPropagation(evt)
        setCurrent(_ => i)
      }
      let active = current === i
      // For Safari iOS12
      let onClick = _ => ()
      let className = makeTabClass(active)
      <button key={Belt.Int.toString(i) ++ ("-" ++ title)} onMouseDown onClick className disabled>
        {title->s}
      </button>
    })

    let body = switch Belt.Array.get(tabs, current) {
    | Some(tab) => tab.content
    | None => React.null
    }

    let body = Belt.Array.mapWithIndex(tabs, (i, tab) => {
      let className = current === i ? "block h-full" : "hidden"

      <div key={Belt.Int.toString(i)} className> tab.content </div>
    })

    <div>
      <div>
        <div className={"flex bg-night-10 w-full " ++ (disabled ? "opacity-50" : "")}>
          {headers->ate}
        </div>
        <div> {body->ate} </div>
      </div>
    </div>
  }
}

module SingleTabPane = {
  @react.component
  let make = (~title: string, ~makeTabClass=?, ~children) => {
    let tabs = [{Pane.title: title, content: children}]

    <Pane tabs ?makeTabClass />
  }
}

module Statusbar = {
  let renderTitle = (~targetLang, result) => {
    /* let errClass = "text-fire"; */
    /* let warnClass = "text-code-5"; */
    /* let okClass = "text-dark-code-3"; */
    let errClass = "text-white-80"
    let warnClass = "text-white font-bold"
    let okClass = "text-white-80"

    let (className, text) = switch result {
    | FinalResult.Comp(Fail(result)) =>
      switch result {
      | SyntaxErr(_) => (errClass, "Syntax Errors (" ++ (Api.Lang.toString(targetLang) ++ ")"))
      | TypecheckErr(_) => (errClass, "Type Errors")
      | WarningErr(_) => (warnClass, "Warning Errors")
      | WarningFlagErr(_) => (errClass, "Config Error")
      | OtherErr(_) => (errClass, "Errors")
      }
    | Conv(Fail(_)) => (errClass, "Syntax Errors")
    | Comp(Success({warnings})) =>
      let warningNum = Belt.Array.length(warnings)
      if warningNum === 0 {
        (okClass, "Compiled successfully")
      } else {
        (warnClass, "Compiled with " ++ (Belt.Int.toString(warningNum) ++ " Warning(s)"))
      }
    | Conv(Success(_)) => (okClass, "Format Successful")
    | Comp(UnexpectedError(_))
    | Conv(UnexpectedError(_)) => (errClass, "Unexpected Error")
    | Comp(Unknown(_))
    | Conv(Unknown(_)) => (errClass, "Unknown Result")
    | Nothing => (okClass, "Ready")
    }

    <span className> {text->s} </span>
  }

  @react.component
  let make = (~actionIndicatorKey: string, ~state: CompilerManagerHook.state) =>
    switch state {
    | Compiling(ready, _)
    | Ready(ready) =>
      let {result} = ready
      let activityIndicatorColor = switch result {
      | FinalResult.Comp(Fail(_))
      | Conv(Fail(_))
      | Comp(UnexpectedError(_))
      | Conv(UnexpectedError(_))
      | Comp(Unknown(_))
      | Conv(Unknown(_)) => "bg-fire-80"
      | Conv(Success(_))
      | Nothing => "bg-dark-code-3"
      | Comp(Success({warnings})) =>
        if Array.length(warnings) === 0 {
          "bg-dark-code-3"
        } else {
          "bg-code-5"
        }
      }

      <div className={"py-2 pb-3 flex items-center text-white " ++ activityIndicatorColor}>
        <div className="flex items-center font-medium px-4">
          <div key=actionIndicatorKey className="pr-4 animate-pulse">
            {renderTitle(~targetLang=ready.targetLang, result)}
          </div>
        </div>
      </div>
    | _ => React.null
    }
}
module ResultPane = {
  module PreWrap = {
    @react.component
    let make = (~className="", ~children) =>
      <pre className={"whitespace-pre-wrap " ++ className}> children </pre>
  }
  type prefix = [#W | #E]
  let compactErrorLine = (~highlight=false, ~prefix: prefix, locMsg: Api.LocMsg.t) => {
    let {Api.LocMsg.row: row, column, shortMsg} = locMsg
    let prefixColor = switch prefix {
    | #W => "text-code-5"
    | #E => "text-fire"
    }

    let prefixText = switch prefix {
    | #W => "[W]"
    | #E => "[E]"
    }

    let highlightClass = switch (highlight, prefix) {
    | (false, _) => ""
    | (true, #W) => "bg-gold-15"
    | (true, #E) => "bg-fire-15 rounded"
    }

    <div
      className="font-mono mb-4 pb-6 last:mb-0 last:pb-0 last:border-0 border-b border-night-light ">
      <div className={"p-2 " ++ highlightClass}>
        <span className=prefixColor> {prefixText->s} </span>
        <span className="font-medium text-night-light"> {j` Line $row, column $column:`->s} </span>
        <AnsiPre className="whitespace-pre-wrap "> shortMsg </AnsiPre>
      </div>
    </div>
  }

  let isHighlighted = (~focusedRowCol=?, locMsg): bool =>
    switch focusedRowCol {
    | Some(focusedRowCol) =>
      let {Api.LocMsg.row: row, column} = locMsg
      let (fRow, fCol) = focusedRowCol

      fRow === row && fCol === column

    | None => false
    }

  let filterHighlightedLocMsgs = (~focusedRowCol, locMsgs: array<Api.LocMsg.t>): array<
    Api.LocMsg.t,
  > => {
    open Api.LocMsg
    switch focusedRowCol {
    | Some(focusedRowCol) =>
      let (fRow, fCol) = focusedRowCol
      let filtered = Belt.Array.keep(locMsgs, locMsg =>
        fRow === locMsg.row && fCol === locMsg.column
      )

      if Array.length(filtered) === 0 {
        locMsgs
      } else {
        filtered
      }

    | None => locMsgs
    }
  }

  let filterHighlightedLocWarnings = (~focusedRowCol, warnings: array<Api.Warning.t>): array<
    Api.Warning.t,
  > =>
    switch focusedRowCol {
    | Some(focusedRowCol) =>
      let (fRow, fCol) = focusedRowCol
      let filtered = Belt.Array.keep(warnings, warning =>
        switch warning {
        | Warn({details})
        | WarnErr({details}) =>
          fRow === details.row && fCol === details.column
        }
      )
      if Array.length(filtered) === 0 {
        warnings
      } else {
        filtered
      }
    | None => warnings
    }

  let renderResult = (
    ~focusedRowCol: option<(int, int)>,
    ~targetLang: Api.Lang.t,
    ~compilerVersion: string,
    result: FinalResult.t,
  ): React.element =>
    switch result {
    | FinalResult.Comp(Fail(result)) =>
      switch result {
      | TypecheckErr(locMsgs)
      | OtherErr(locMsgs)
      | SyntaxErr(locMsgs) =>
        filterHighlightedLocMsgs(~focusedRowCol, locMsgs)
        ->Belt.Array.mapWithIndex((i, locMsg) =>
          <div key={Belt.Int.toString(i)}>
            {compactErrorLine(
              ~highlight=isHighlighted(~focusedRowCol?, locMsg),
              ~prefix=#E,
              locMsg,
            )}
          </div>
        )
        ->ate
      | WarningErr(warnings) =>
        filterHighlightedLocWarnings(~focusedRowCol, warnings)
        ->Belt.Array.mapWithIndex((i, warning) => {
          let (prefix, details) = switch warning {
          | Api.Warning.Warn({details}) => (#W, details)
          | WarnErr({details}) => (#E, details)
          }
          <div key={Belt.Int.toString(i)}>
            {compactErrorLine(~highlight=isHighlighted(~focusedRowCol?, details), ~prefix, details)}
          </div>
        })
        ->ate
      | WarningFlagErr({msg}) =>
        <div> {"There are some issues with your compiler flag configuration:"->s} {msg->s} </div>
      }
    | Comp(Success({warnings})) =>
      if Array.length(warnings) === 0 {
        <PreWrap> {"0 Errors, 0 Warnings"->s} </PreWrap>
      } else {
        filterHighlightedLocWarnings(~focusedRowCol, warnings)
        ->Belt.Array.mapWithIndex((i, warning) => {
          let (prefix, details) = switch warning {
          | Api.Warning.Warn({details}) => (#W, details)
          | WarnErr({details}) => (#E, details)
          }
          <div key={Belt.Int.toString(i)}>
            {compactErrorLine(~highlight=isHighlighted(~focusedRowCol?, details), ~prefix, details)}
          </div>
        })
        ->ate
      }
    | Conv(Success({fromLang, toLang})) =>
      let msg = if fromLang === toLang {
        "Formatting completed with 0 errors"
      } else {
        let toStr = Api.Lang.toString(toLang)
        j`Switched to $toStr with 0 errors`
      }
      <PreWrap> {msg->s} </PreWrap>
    | Conv(Fail({fromLang, toLang, details})) =>
      let errs =
        filterHighlightedLocMsgs(~focusedRowCol, details)
        ->Belt.Array.mapWithIndex((i, locMsg) =>
          <div key={Belt.Int.toString(i)}>
            {compactErrorLine(
              ~highlight=isHighlighted(~focusedRowCol?, locMsg),
              ~prefix=#E,
              locMsg,
            )}
          </div>
        )
        ->ate

      // The way the UI is currently designed, there shouldn't be a case where fromLang !== toLang.
      // We keep both cases though in case we change things later
      let msg = if fromLang === toLang {
        let langStr = Api.Lang.toString(toLang)
        j`The code is not valid $langStr syntax.`
      } else {
        let fromStr = Api.Lang.toString(fromLang)
        let toStr = Api.Lang.toString(toLang)
        j`Could not convert from "$fromStr" to "$toStr" due to malformed syntax:`
      }
      <div> <PreWrap className="text-16 mb-4"> {msg->s} </PreWrap> errs </div>
    | Comp(UnexpectedError(msg))
    | Conv(UnexpectedError(msg)) =>
      msg->s
    | Comp(Unknown(msg, json))
    | Conv(Unknown(msg, json)) =>
      let subheader = "font-bold text-night-light text-16"
      <div>
        <PreWrap>
          {"The compiler bundle API returned a result that couldn't be interpreted. Please open an issue on our "->s}
          <Markdown.A
            target="_blank" href="https://github.com/reason-association/rescript-lang.org/issues">
            {"issue tracker"->s}
          </Markdown.A>
          {"."->s}
        </PreWrap>
        <div className="mt-4">
          <PreWrap> <div className=subheader> {"Message: "->s} </div> {msg->s} </PreWrap>
        </div>
        <div className="mt-4">
          <PreWrap>
            <span className=subheader> {"Received JSON payload:"->s} </span>
            <div> {Util.Json.prettyStringify(json)->s} </div>
          </PreWrap>
        </div>
      </div>
    | Nothing =>
      let syntax = Api.Lang.toString(targetLang)
      <PreWrap>
        {j`This playground is now running on compiler version $compilerVersion with $syntax syntax`->s}
      </PreWrap>
    }

  let renderTitle = result => {
    let errClass = "text-fire"
    let warnClass = "text-code-5"
    let okClass = "text-dark-code-3"

    let (className, text) = switch result {
    | FinalResult.Comp(Fail(result)) =>
      switch result {
      | SyntaxErr(_) => (errClass, "Syntax Errors")
      | TypecheckErr(_) => (errClass, "Type Errors")
      | WarningErr(_) => (warnClass, "Warning Errors")
      | WarningFlagErr(_) => (errClass, "Config Error")
      | OtherErr(_) => (errClass, "Errors")
      }
    | Conv(Fail(_)) => (errClass, "Syntax Errors")
    | Comp(Success({warnings})) =>
      let warningNum = Belt.Array.length(warnings)
      if warningNum === 0 {
        (okClass, "Compiled successfully")
      } else {
        (warnClass, "Compiled with " ++ (Belt.Int.toString(warningNum) ++ " Warning(s)"))
      }
    | Conv(Success(_)) => (okClass, "Format Successful")
    | Comp(UnexpectedError(_))
    | Conv(UnexpectedError(_)) => (errClass, "Unexpected Error")
    | Comp(Unknown(_))
    | Conv(Unknown(_)) => (errClass, "Unknown Result")
    | Nothing => (okClass, "Ready")
    }

    <span className> {text->s} </span>
  }

  @react.component
  let make = (
    ~targetLang: Api.Lang.t,
    ~compilerVersion: string,
    ~focusedRowCol: option<(int, int)>=?,
    ~result: FinalResult.t,
  ) =>
    <div className="pt-4 bg-night-dark overflow-y-auto hide-scrollbar">
      <div className="flex items-center text-16 font-medium px-4">
        <div className="pr-4"> {renderTitle(result)} </div>
      </div>
      <div className="">
        <div className="bg-night-dark text-snow-darker px-4 py-4">
          {renderResult(~focusedRowCol, ~compilerVersion, ~targetLang, result)}
        </div>
      </div>
    </div>
}

module WarningFlagsWidget = {
  @bs.set external scrollTop: (Dom.element, int) => unit = "scrollTop"
  @bs.send external focus: Dom.element => unit = "focus"
  @bs.send
  external scrollIntoView: (Dom.element, @bs.as(json`false`) _) => unit = "scrollIntoView"

  @bs.send external blur: Dom.element => unit = "blur"

  @bs.get external scrollHeight: Dom.element => int = "scrollHeight"
  @bs.get external clientHeight: Dom.element => int = "clientHeight"
  @bs.get external scrollTop: Dom.element => int = "scrollTop"
  @bs.get external offsetTop: Dom.element => int = "offsetTop"
  @bs.get external offsetHeight: Dom.element => int = "offsetHeight"

  @bs.set external setScrollTop: (Dom.element, int) => unit = "scrollTop"

  // Inspired by MUI (who got inspired by WAI best practise examples)
  // https://github.com/mui-org/material-ui/blob/next/packages/material-ui-lab/src/useAutocomplete/useAutocomplete.js#L327
  let scrollToElement = (~parent: Dom.element, element: Dom.element): unit =>
    if parent->scrollHeight > parent->clientHeight {
      let scrollBottom = parent->clientHeight + parent->scrollTop
      let elementBottom = element->offsetTop + element->offsetHeight

      if elementBottom > scrollBottom {
        parent->setScrollTop(elementBottom - parent->clientHeight)
      } else if element->offsetTop - element->offsetHeight < parent->scrollTop {
        parent->setScrollTop(element->offsetTop - element->offsetHeight)
      }
    }

  type suggestion =
    | NoSuggestion
    | FuzzySuggestions({
        modifier: string, // tells if the user is currently inputting a + / -
        // All tokens without the suggestion token (last one)
        precedingTokens: array<WarningFlagDescription.Parser.token>,
        results: array<(string, string)>,
        selected: int,
      })
    | ErrorSuggestion(string)

  type rec state =
    | HideSuggestion({input: string})
    | ShowTokenHint({lastState: state, token: WarningFlagDescription.Parser.token}) // For restoring the previous state // hover target
    | Typing({suggestion: suggestion, input: string})

  let hide = (prev: state) =>
    switch prev {
    | Typing({input})
    | ShowTokenHint({lastState: Typing({input})}) =>
      HideSuggestion({input: input})
    | ShowTokenHint(_) => HideSuggestion({input: ""})
    | HideSuggestion(_) => prev
    }

  let updateInput = (prev: state, input: string) => {
    let suggestion = switch input {
    | "" => NoSuggestion
    | _ =>
      // Case: +
      let last = input->Js.String2.length - 1
      switch input->Js.String2.get(last) {
      | "+" as modifier
      | "-" as modifier =>
        let results = WarningFlagDescription.lookupAll()

        let partial = input->Js.String2.substring(~from=0, ~to_=last)

        let precedingTokens = switch WarningFlagDescription.Parser.parse(partial) {
        | Ok(tokens) => tokens
        | Error(_) => []
        }

        FuzzySuggestions({
          modifier: modifier,
          precedingTokens: precedingTokens,
          results: results,
          selected: 0,
        })
      | _ =>
        // Case: +1...
        let results = WarningFlagDescription.Parser.parse(input)
        switch results {
        | Ok(tokens) =>
          let last = Belt.Array.get(tokens, Belt.Array.length(tokens) - 1)

          switch last {
          | Some(token) =>
            let results = WarningFlagDescription.fuzzyLookup(token.flag)
            if Belt.Array.length(results) === 0 {
              ErrorSuggestion("No results")
            } else {
              let precedingTokens = Belt.Array.slice(
                tokens,
                ~offset=0,
                ~len=Belt.Array.length(tokens) - 1,
              )
              let modifier = token.enabled ? "+" : "-"
              FuzzySuggestions({
                modifier: modifier,
                precedingTokens: precedingTokens,
                results: results,
                selected: 0,
              })
            }
          | None => NoSuggestion
          }
        | Error(msg) =>
          // In case the user started with a + / -
          // show all available flags
          switch input {
          | "+" as modifier
          | "-" as modifier =>
            let results = WarningFlagDescription.lookupAll()

            FuzzySuggestions({
              modifier: modifier,
              precedingTokens: [],
              results: results,
              selected: 0,
            })
          | _ => ErrorSuggestion(msg)
          }
        }
      }
    }

    switch prev {
    | ShowTokenHint(_)
    | Typing(_) =>
      Typing({suggestion: suggestion, input: input})
    | HideSuggestion(_) => Typing({suggestion: suggestion, input: input})
    }
  }

  let selectPrevious = (prev: state) =>
    switch prev {
    | Typing({suggestion: FuzzySuggestions({selected, results} as suggestion)} as typing) =>
      let nextIdx = if selected > 0 {
        selected - 1
      } else {
        Belt.Array.length(results) - 1
      }
      Typing({
        ...typing,
        suggestion: FuzzySuggestions({...suggestion, selected: nextIdx}),
      })
    | ShowTokenHint(_)
    | Typing(_)
    | HideSuggestion(_) => prev
    }

  let selectNext = (prev: state) =>
    switch prev {
    | Typing({suggestion: FuzzySuggestions({selected, results} as suggestion)} as typing) =>
      let nextIdx = if selected < Belt.Array.length(results) - 1 {
        selected + 1
      } else {
        0
      }
      Typing({
        ...typing,
        suggestion: FuzzySuggestions({...suggestion, selected: nextIdx}),
      })
    | ShowTokenHint(_)
    | Typing(_)
    | HideSuggestion(_) => prev
    }

  @react.component
  let make = (
    ~onUpdate: array<WarningFlagDescription.Parser.token> => unit,
    ~flags: array<WarningFlagDescription.Parser.token>,
  ) => {
    let (state, setState) = React.useState(_ => HideSuggestion({input: ""}))

    // Used for the suggestion box list
    let listboxRef = React.useRef(Js.Nullable.null)

    // Used for the text input
    let inputRef = React.useRef(Js.Nullable.null)

    let focusInput = () =>
      React.Ref.current(inputRef)->Js.Nullable.toOption->Belt.Option.forEach(el => el->focus)

    let blurInput = () =>
      React.Ref.current(inputRef)->Js.Nullable.toOption->Belt.Option.forEach(el => el->blur)

    let chips = Belt.Array.mapWithIndex(flags, (i, token) => {
      let {WarningFlagDescription.Parser.flag: flag, enabled} = token

      let isActive = switch state {
      | ShowTokenHint({token}) => token.flag === flag
      | _ => false
      }

      let full = (enabled ? "+" : "-") ++ flag
      let color = switch (enabled, isActive) {
      | (true, false) => "text-dark-code-3"
      | (false, false) => "text-fire"
      | (true, true) => "bg-night-light text-dark-code-3"
      | (false, true) => "bg-night-light text-fire"
      }

      let hoverEnabled = switch state {
      | ShowTokenHint(_)
      | Typing(_) => true
      | HideSuggestion(_) => false
      }

      let (onMouseEnter, onMouseLeave) = if hoverEnabled {
        let enter = evt => {
          ReactEvent.Mouse.preventDefault(evt)
          ReactEvent.Mouse.stopPropagation(evt)

          setState(prev => ShowTokenHint({token: token, lastState: prev}))
        }

        let leave = evt => {
          ReactEvent.Mouse.preventDefault(evt)
          ReactEvent.Mouse.stopPropagation(evt)

          setState(prev =>
            switch prev {
            | ShowTokenHint({lastState}) => lastState
            | _ => prev
            }
          )
        }
        (Some(enter), Some(leave))
      } else {
        (None, None)
      }

      let onClick = evt => {
        // Removes clicked token from the current flags
        ReactEvent.Mouse.preventDefault(evt)

        let remaining = Belt.Array.keep(flags, t => t.flag !== flag)
        onUpdate(remaining)
      }

      <span
        onClick
        ?onMouseEnter
        ?onMouseLeave
        className={color ++ " hover:cursor-default text-16 inline-block border border-night-light rounded-full px-2 mr-1"}
        key={Belt.Int.toString(i) ++ flag}>
        {full->s}
      </span>
    })->ate

    let onKeyDown = evt => {
      let key = ReactEvent.Keyboard.key(evt)
      let ctrlKey = ReactEvent.Keyboard.ctrlKey(evt)

      let caretPosition = ReactEvent.Keyboard.target(evt)["selectionStart"]
      /* Js.log2("caretPosition", caretPosition); */

      let full = (ctrlKey ? "CTRL+" : "") ++ key
      switch full {
      | "Enter" =>
        switch state {
        | Typing({suggestion: FuzzySuggestions({precedingTokens, modifier, selected, results})}) =>
          // In case a selection was made correctly, add
          // the flag to the current flags
          switch Belt.Array.get(results, selected) {
          | Some((num, _)) =>
            let token = {
              WarningFlagDescription.Parser.enabled: modifier === "+",
              flag: num,
            }

            // TODO: merge tokens with flags
            let newTokens = Belt.Array.concat(precedingTokens, [token])

            let all = WarningFlagDescription.Parser.merge(flags, newTokens)

            onUpdate(all)
            setState(prev => updateInput(prev, ""))
          | None => ()
          }
        | _ => ()
        }
        ReactEvent.Keyboard.preventDefault(evt)
      | "Escape" => blurInput()
      | "Tab" =>
        switch state {
        | Typing({suggestion: FuzzySuggestions({modifier, precedingTokens, selected, results})}) =>
          switch Belt.Array.get(results, selected) {
          | Some((num, _)) =>
            let flag = modifier ++ num

            let completed = WarningFlagDescription.Parser.tokensToString(precedingTokens) ++ flag
            setState(prev => updateInput(prev, completed))
          | None => ()
          }
          // Prevents tab to change focus
          ReactEvent.Keyboard.preventDefault(evt)
        | _ => ()
        }
      | "ArrowDown"
      | "CTRL+n" =>
        setState(prev => selectNext(prev))
        ReactEvent.Keyboard.preventDefault(evt)
      | "ArrowUp"
      | "CTRL+p" =>
        setState(prev => selectPrevious(prev))
        ReactEvent.Keyboard.preventDefault(evt)
      | "ArrowRight"
      | "ArrowLeft" => ()
      | full =>
        switch state {
        | Typing({suggestion: ErrorSuggestion(_)}) =>
          if full !== "Backspace" {
            ReactEvent.Keyboard.preventDefault(evt)
          }
        | _ => Js.log(full)
        }
      }
    }

    let suggestions = switch state {
    | ShowTokenHint({token}) => WarningFlagDescription.lookup(token.flag)->Belt.Array.map(((
        num,
        description,
      )) => {
        let (modifier, color) = if token.enabled {
          ("(Enabled) ", "text-dark-code-3")
        } else {
          ("(Disabled) ", "text-fire")
        }

        <div key=num> <span className=color> {modifier->s} </span> {description->s} </div>
      })->ate->Some
    | Typing(typing) =>
      let suggestions = switch typing.suggestion {
      | NoSuggestion => "Type + / - followed by a number or letter (e.g. +a+1)"->s
      | ErrorSuggestion(msg) => msg->s
      | FuzzySuggestions({precedingTokens, selected, results, modifier}) =>
        Belt.Array.mapWithIndex(results, (i, (flag, desc)) => {
          let activeClass = selected === i ? "bg-night-light" : ""

          let ref = if selected === i {
            ReactDOMRe.Ref.callbackDomRef(dom => {
              let el = Js.Nullable.toOption(dom)
              let parent = React.Ref.current(listboxRef)->Js.Nullable.toOption

              switch (parent, el) {
              | (Some(parent), Some(el)) => scrollToElement(~parent, el)
              | _ => ()
              }
            })->Some
          } else {
            None
          }

          let onMouseEnter = evt => {
            ReactEvent.Mouse.preventDefault(evt)
            setState(prev =>
              switch prev {
              | Typing({suggestion: FuzzySuggestions(fuzzySuggestion)}) =>
                Typing({
                  ...typing,
                  suggestion: FuzzySuggestions({...fuzzySuggestion, selected: i}),
                })
              | _ => prev
              }
            )
          }

          let onClick = evt => {
            ReactEvent.Mouse.preventDefault(evt)
            setState(prev =>
              switch prev {
              | Typing(_) =>
                let full = modifier ++ flag
                let completed =
                  WarningFlagDescription.Parser.tokensToString(precedingTokens) ++ full
                updateInput(prev, completed)
              | _ => prev
              }
            )
          }

          <div ?ref onMouseEnter onMouseDown=onClick className=activeClass key=flag>
            {(modifier ++ (flag ++ (": " ++ desc)))->s}
          </div>
        })->ate
      }
      Some(suggestions)
    | HideSuggestion(_) => None
    }

    let suggestionBox =
      Belt.Option.map(suggestions, elements =>
        <div
          ref={ReactDOMRe.Ref.domRef(listboxRef)}
          className="p-2 absolute overflow-auto z-50 border-b rounded border-l border-r block w-full bg-gray-100"
          style={ReactDOMRe.Style.make(~maxHeight="15rem", ())}>
          elements
        </div>
      )->Belt.Option.getWithDefault(React.null)

    let onChange = evt => {
      ReactEvent.Form.preventDefault(evt)
      let input = ReactEvent.Form.target(evt)["value"]
      setState(prev => updateInput(prev, input))
    }

    let onBlur = evt => {
      ReactEvent.Focus.preventDefault(evt)
      ReactEvent.Focus.stopPropagation(evt)
      setState(prev => hide(prev))
    }

    let onFocus = evt => {
      let input = ReactEvent.Focus.target(evt)["value"]
      setState(prev => updateInput(prev, input))
    }

    let isActive = switch state {
    | ShowTokenHint(_)
    | Typing(_) => true
    | HideSuggestion(_) => false
    }

    let deleteButton = switch flags {
    | []
    | [{enabled: false, flag: "a"}] => React.null
    | _ =>
      let onMouseDown = evt => {
        ReactEvent.Mouse.preventDefault(evt)
        onUpdate([{WarningFlagDescription.Parser.enabled: false, flag: "a"}])
      }

      // For iOS12 compat
      let onClick = _ => ()
      let onFocus = evt => {
        ReactEvent.Focus.preventDefault(evt)
        ReactEvent.Focus.stopPropagation(evt)
      }

      <button
        onMouseDown
        onClick
        onFocus
        tabIndex=0
        className="focus:outline-none self-start focus:shadow-outline hover:cursor-pointer hover:bg-night-light p-2 rounded-full">
        <Icon.Close />
      </button>
    }

    let activeClass = if isActive {
      "border-white"
    } else {
      "border-night-light"
    }

    let areaOnFocus = evt =>
      if !isActive {
        focusInput()
      }

    let inputValue = switch state {
    | ShowTokenHint({lastState: Typing({input})})
    | Typing({input}) => input
    | HideSuggestion({input}) => input
    | ShowTokenHint(_) => ""
    }

    <div tabIndex={-1} className="relative" onFocus=areaOnFocus onKeyDown>
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
    </div>
  }
}

module ConsolePane = {
  @react.component
  let make = () =>
    <div className="p-4 pt-8">
      <AnsiPre> "> console not implemented yet (coming soon)" </AnsiPre>
    </div>
}

module Settings = {
  @react.component
  let make = (
    ~readyState: CompilerManagerHook.ready,
    ~dispatch: CompilerManagerHook.action => unit,
    ~setConfig: Api.Config.t => unit,
    ~editorCode: React.Ref.t<string>,
    ~config: Api.Config.t,
  ) => {
    let {Api.Config.warn_flags: warn_flags} = config

    let targetLangVersion = switch readyState.targetLang {
    | Res => (Api.Lang.Res, readyState.selected.compilerVersion)
    | Reason => (Reason, readyState.selected.reasonVersion)
    | OCaml => (OCaml, readyState.selected.ocamlVersion)
    }

    let availableTargetLangs = Api.Version.availableLanguages(readyState.selected.apiVersion)

    let onTargetLangSelect = lang =>
      dispatch(SwitchLanguage({lang: lang, code: React.Ref.current(editorCode)}))

    let onWarningFlagsUpdate = flags => {
      let normalizeEmptyFlags = flags =>
        switch flags {
        | [] => [{WarningFlagDescription.Parser.enabled: false, flag: "a"}]
        | other => other
        }
      let config = {
        ...config,
        warn_flags: flags->normalizeEmptyFlags->WarningFlagDescription.Parser.tokensToString,
      }
      setConfig(config)
    }

    let onModuleSystemUpdate = module_system => {
      let config = {...config, module_system: module_system}
      setConfig(config)
    }

    let warnFlagTokens =
      WarningFlagDescription.Parser.parse(warn_flags)->Belt.Result.getWithDefault([])

    let onResetClick = evt => {
      ReactEvent.Mouse.preventDefault(evt)
      let defaultConfig = {
        Api.Config.module_system: "nodejs",
        warn_flags: "+a-4-9-20-40-41-42-50-61-102",
      }
      setConfig(defaultConfig)
    }

    let onCompilerSelect = id =>
      dispatch(SwitchToCompiler({id: id, libraries: readyState.selected.libraries}))

    let titleClass = "text-18 font-bold mb-2"
    <div className="p-4 pt-8 bg-night-dark text-snow-darker">
      <div>
        <div className=titleClass> {"ReScript Version"->s} </div>
        <DropdownSelect
          name="compilerVersions"
          value=readyState.selected.id
          onChange={evt => {
            ReactEvent.Form.preventDefault(evt)
            let id = (evt->ReactEvent.Form.target)["value"]
            onCompilerSelect(id)
          }}>
          {Belt.Array.map(readyState.versions, version =>
            <option className="py-4" key=version value=version> {version->s} </option>
          )->ate}
        </DropdownSelect>
      </div>
      <div className="mt-6">
        <div className=titleClass> {"Syntax"->s} </div>
        <ToggleSelection
          values=availableTargetLangs
          toLabel={lang => lang->Api.Lang.toExt->Js.String2.toUpperCase}
          selected=readyState.targetLang
          onChange=onTargetLangSelect
        />
      </div>
      <div className="mt-6">
        <div className=titleClass> {"Module-System"->s} </div>
        <ToggleSelection
          values=["nodejs", "es6"]
          toLabel={value => value}
          selected=config.module_system
          onChange=onModuleSystemUpdate
        />
        <div className="mt-8">
          <div className=titleClass>
            {"Warning Flags"->s}
            <button onMouseDown=onResetClick className={"ml-6 text-14 " ++ Text.Link.standalone}>
              {"[reset]"->s}
            </button>
          </div>
          <div className="flex justify-end" />
          <div style={ReactDOMRe.Style.make(~maxWidth="40rem", ())}>
            <WarningFlagsWidget onUpdate=onWarningFlagsUpdate flags=warnFlagTokens />
          </div>
        </div>
      </div>
    </div>
  }
}

module ControlPanel = {
  module Button = {
    @react.component
    let make = (~children, ~onClick=?) =>
      <button
        ?onClick
        className="inline-block text-sky hover:cursor-pointer hover:bg-sky hover:text-white-80 rounded border active:bg-sky-80 border-sky-80 px-2 py-1 ">
        children
      </button>
  }
  module ShareButton = {
    let copyToClipboard: string => bool = %raw(
      j`
    function(str) {
      try {
      const el = document.createElement('textarea');
      el.value = str;
      el.setAttribute('readonly', '');
      el.style.position = 'absolute';
      el.style.left = '-9999px';
      document.body.appendChild(el);
      const selected =
        document.getSelection().rangeCount > 0 ? document.getSelection().getRangeAt(0) : false;
      el.select();
      document.execCommand('copy');
      document.body.removeChild(el);
      if (selected) {
        document.getSelection().removeAllRanges();
        document.getSelection().addRange(selected);
      }
      return true;
      } catch(e) {
        return false;
      }
    }
    `
    )

    @bs.val @bs.scope("document")
    external execCommand: [#copy] => unit = "execCommand"

    @bs.send external select: Dom.element => unit = "select"
    @bs.send
    external setSelectionRange: (Dom.element, int, int) => unit = "setSelectionRange"

    @bs.set external setValue: (Dom.element, string) => unit = "value"
    @bs.get external value: Dom.element => string = "value"

    type state =
      | Init
      | CopySuccess
      | CopyFailed

    @react.component
    let make = (~createShareLink: unit => string, ~actionIndicatorKey: string) => {
      let (state, setState) = React.useState(() => Init)

      React.useEffect1(() => {
        setState(_ => Init)
        None
      }, [actionIndicatorKey])

      let onClick = evt => {
        ReactEvent.Mouse.preventDefault(evt)
        let url = createShareLink()
        let ret = copyToClipboard(url)
        if ret {
          setState(_ => CopySuccess)
        }
      }

      let (text, className) = switch state {
      | Init => ("Copy Share Link", " bg-sky active:bg-sky-80 border-sky-80")
      | CopySuccess => ("Copied to clipboard!", "bg-dark-code-3 border-dark-code-3")
      | CopyFailed => ("Copy failed...", "")
      }

      <>
        <button
          onClick
          className={className ++ " w-40 transition-all duration-500 ease-in-out inline-block hover:cursor-pointer hover:text-white-80 text-white rounded border px-2 py-1 "}>
          {text->s}
        </button>
      </>
    }
  }

  @bs.val @bs.scope("window.location") external origin: string = "origin"
  @react.component
  let make = (
    ~actionIndicatorKey: string,
    ~state: CompilerManagerHook.state,
    ~dispatch: CompilerManagerHook.action => unit,
    ~editorCode: React.Ref.t<string>,
  ) => {
    let router = Next.Router.useRouter()
    let children = switch state {
    | Init => "Initializing..."->s
    | SwitchingCompiler(_, _, _) => "Switching Compiler..."->s
    | Compiling(ready, _)
    | Ready(ready) =>
      let onFormatClick = evt => {
        ReactEvent.Mouse.preventDefault(evt)
        dispatch(Format(React.Ref.current(editorCode)))
      }

      let createShareLink = () => {
        let params = switch ready.targetLang {
        | Res => []
        | lang => [("ext", Api.Lang.toExt(lang))]
        }

        Js.Array2.push(
          params,
          ("code", editorCode->React.Ref.current->LzString.compressToEncodedURIComponent),
        )->ignore

        let querystring = Belt.Array.reduce(params, "", (acc, next) => {
          let (key, value) = next

          if acc === "" {
            "?" ++ (key ++ ("=" ++ value))
          } else {
            acc ++ ("&" ++ (key ++ ("=" ++ value)))
          }
        })

        origin ++ (router.route ++ querystring)
      }
      <>
        <div className="mr-2"> <Button onClick=onFormatClick> {"Format"->s} </Button> </div>
        <ShareButton actionIndicatorKey createShareLink />
      </>
    | _ => React.null
    }

    <div className="flex justify-end items-center h-12 bg-night-10 px-4"> children </div>
  }
}

let locMsgToCmError = (~kind: CodeMirror.Error.kind, locMsg: Api.LocMsg.t): CodeMirror.Error.t => {
  let {Api.LocMsg.row: row, column, endColumn, endRow, shortMsg} = locMsg
  {
    CodeMirror.Error.row: row,
    column: column,
    endColumn: endColumn,
    endRow: endRow,
    text: shortMsg,
    kind: kind,
  }
}

module OutputPanel = {
  let codeFromResult = (result: FinalResult.t): string => {
    open Api
    switch result {
    | FinalResult.Comp(comp) =>
      switch comp {
      | CompilationResult.Success({js_code}) => js_code
      | UnexpectedError(_)
      | Unknown(_, _)
      | Fail(_) => "/* No JS code generated */"
      }
    | Nothing
    | Conv(_) => "/* No JS code generated */"
    }
  }

  @react.component
  let make = (
    ~actionIndicatorKey,
    ~compilerDispatch,
    ~compilerState: CompilerManagerHook.state,
    ~editorCode: React.Ref.t<string>,
  ) => {
    /*
       We need the prevState to understand different
       state transitions, and to be able to keep displaying
       old results until those transitions are done.

       Goal was to reduce the UI flickering during different
       state transitions
 */
    let prevState = React.useRef(None)

    let cmCode = switch React.Ref.current(prevState) {
    | Some(prev) =>
      switch (prev, compilerState) {
      | (_, Ready({result: Nothing})) => None
      | (Ready(prevReady), Ready(ready)) =>
        switch (prevReady.result, ready.result) {
        | (_, Comp(Success(_))) => codeFromResult(ready.result)->Some
        | _ => None
        }
      | (_, Ready({result: Comp(Success(_)) as result})) => codeFromResult(result)->Some
      | (Ready({result: Comp(Success(_)) as result}), Compiling(_, _)) =>
        codeFromResult(result)->Some
      | _ => None
      }
    | None =>
      switch compilerState {
      | Ready(ready) => codeFromResult(ready.result)->Some
      | _ => None
      }
    }

    React.Ref.setCurrent(prevState, Some(compilerState))

    let resultPane = switch compilerState {
    | Compiling(ready, _)
    | Ready(ready) =>
      switch ready.result {
      | Comp(Success(_))
      | Conv(Success(_)) => React.null
      | _ =>
        <ResultPane
          targetLang=ready.targetLang
          compilerVersion=ready.selected.compilerVersion
          result=ready.result
        />
      }

    | _ => React.null
    }

    let (code, showCm) = switch cmCode {
    | None => ("", false)
    | Some(code) => (code, true)
    }

    let codeElement =
      <pre
        style={ReactDOMRe.Style.make(~height="calc(100vh - 11.5rem)", ())}
        className={"whitespace-pre-wrap overflow-y-auto p-4 " ++ (showCm ? "block" : "hidden")}>
        {HighlightJs.renderHLJS(~code, ~darkmode=true, ~lang="js", ())}
      </pre>

    let output =
      <div
        className="relative w-full bg-night-dark text-snow-darker"
        style={ReactDOMRe.Style.make(~height="calc(100vh - 9rem)", ())}>
        resultPane codeElement
      </div>

    let errorPane = switch compilerState {
    | Compiling(ready, _)
    | Ready(ready)
    | SwitchingCompiler(ready, _, _) =>
      <ResultPane
        targetLang=ready.targetLang
        compilerVersion=ready.selected.compilerVersion
        result=ready.result
      />
    | SetupFailed(msg) => <div> {("Setup failed: " ++ msg)->s} </div>
    | Init => <div> {"Initalizing Playground..."->s} </div>
    }

    let settingsPane = switch compilerState {
    | Ready(ready)
    | Compiling(ready, _)
    | SwitchingCompiler(ready, _, _) =>
      let config = ready.selected.config
      let setConfig = config => compilerDispatch(UpdateConfig(config))

      <Settings readyState=ready dispatch=compilerDispatch editorCode setConfig config />
    | SetupFailed(msg) => <div> {("Setup failed: " ++ msg)->s} </div>
    | Init => <div> {"Initalizing Playground..."->s} </div>
    }

    let prevSelected = React.useRef(0)

    let selected = switch compilerState {
    | Compiling(_, _) => React.Ref.current(prevSelected)
    | Ready(ready) =>
      switch ready.result {
      | Comp(Success(_))
      | Conv(Success(_)) => 0
      | _ => 1
      }
    | _ => 0
    }

    React.Ref.setCurrent(prevSelected, selected)

    let tabs = [
      {Pane.title: "JavaScript", content: output},
      {
        title: "Problems",
        content: <div style={ReactDOMRe.Style.make(~height="50%", ())}> errorPane </div>,
      },
      {
        title: "Settings",
        content: <div style={ReactDOMRe.Style.make(~height="50%", ())}> settingsPane </div>,
      },
    ]

    let makeTabClass = active => {
      let activeClass = active ? "text-fire font-medium bg-night-dark hover:cursor-default" : ""

      "flex items-center h-12 px-4 pr-16 " ++ activeClass
    }

    <div className="h-full bg-night-dark"> <Pane tabs makeTabClass /> </div>
  }
}

let initialResContent = j`// Please note:
// ---
// The Playground is still a work in progress
// ReScript / old Reason syntax should parse just
// fine (go to the "Settings" panel for toggling syntax).
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
}
` // Please note:
// ---
// The Playground is still a work in progress
// ReScript / old Reason syntax should parse just
// fine (go to the "Settings" panel for toggling syntax).

// Feel free to play around and compile some
// ReScript code!

let initialReContent = j`Js.log("Hello Reason 3.6!");`

@react.component
let default = () => {
  let router = Next.Router.useRouter()

  let initialLang = switch Js.Dict.get(router.query, "ext") {
  | Some("re") => Api.Lang.Reason
  | _ => Api.Lang.Res
  }

  let initialContent = switch (Js.Dict.get(router.query, "code"), initialLang) {
  | (Some(compressedCode), _) => LzString.decompressToEncodedURIComponent(compressedCode)
  | (None, Reason) => initialReContent
  | (None, Res)
  | (None, _) => initialResContent
  }

  // We cleanup all the unwanted query attributes on load to make
  // sure the url is not getting out of sync with the actual content
  React.useEffect1(() => {
    // Clean out the url after loading all query params
    if router.asPath !== "/try" {
      Next.Router.replace(router, "/try")
    } else {
      ()
    }

    None
  }, [router.route])

  // We don't count to infinity. This value is only required to trigger
  // rerenders for specific components (ActivityIndicator)
  let (actionCount, setActionCount) = React.useState(_ => 0)
  let onAction = _ => setActionCount(prev => prev > 1000000 ? 0 : prev + 1)
  let (compilerState, compilerDispatch) = useCompilerManager(~initialLang, ~onAction, ())

  let overlayState = React.useState(() => false)

  let windowWidth = CodeMirror.useWindowWidth()

  // The user can focus an error / warning on a specific line & column
  // which is stored in this ref and triggered by hover / click states
  // in the CodeMirror editor
  let (focusedRowCol, setFocusedRowCol) = React.useState(_ => None)

  let editorCode = React.useRef(initialContent)

  /* In case the compiler did some kind of syntax conversion / reformatting,
   we take any success results and set the editor code to the new formatted code */
  switch compilerState {
  | Ready({result: FinalResult.Nothing} as ready) =>
    compilerDispatch(CompileCode(ready.targetLang, React.Ref.current(editorCode)))
  | Ready({result: FinalResult.Conv(Api.ConversionResult.Success({code}))}) =>
    React.Ref.setCurrent(editorCode, code)
  | _ => ()
  }

  /*
     The codemirror state and the compilerState are not dependent on eachother,
     so we need to sync a timeoutCompiler function with our compilerState to be
     able to do compilation on code changes.

     The typingTimer is a debounce mechanism to prevent compilation during editing
     and will be manipulated by the codemirror onChange function.
 */
  let typingTimer = React.useRef(None)
  let timeoutCompile = React.useRef(() => ())

  React.useEffect1(() => {
    React.Ref.setCurrent(timeoutCompile, () =>
      switch compilerState {
      | Ready(ready) =>
        compilerDispatch(CompileCode(ready.targetLang, React.Ref.current(editorCode)))
      | _ => ()
      }
    )
    None
  }, [compilerState])

  let cmErrors = switch compilerState {
  | Ready({result}) =>
    switch result {
    | FinalResult.Comp(Fail(result)) =>
      switch result {
      | SyntaxErr(locMsgs)
      | TypecheckErr(locMsgs)
      | OtherErr(locMsgs) =>
        Belt.Array.map(locMsgs, locMsgToCmError(~kind=#Error))
      | WarningErr(warnings) => Belt.Array.reduce(warnings, [], (acc, next) => {
          switch next {
          | Api.Warning.Warn({details})
          | WarnErr({details}) =>
            let warn = locMsgToCmError(~kind=#Warning, details)
            Js.Array2.push(acc, warn)->ignore
          }
          acc
        })
      | WarningFlagErr(_) => []
      }
    | Comp(Success({warnings})) => Belt.Array.reduce(warnings, [], (acc, next) => {
        switch next {
        | Api.Warning.Warn({details})
        | WarnErr({details}) =>
          let warn = locMsgToCmError(~kind=#Warning, details)
          Js.Array2.push(acc, warn)->ignore
        }
        acc
      })
    | Conv(Fail({details})) => Belt.Array.map(details, locMsgToCmError(~kind=#Error))
    | Comp(_)
    | Conv(_)
    | Nothing => []
    }
  | _ => []
  }

  <>
    <Meta title="ReScript Playground" description="Try ReScript in the browser" />
    <Next.Head> <style> {j`body { background-color: #010427; } `->s} </style> </Next.Head>
    <div className="text-16 bg-gray-100">
      <div className="text-night text-14">
        <Navigation fixed=false overlayState />
        <main
          className="bg-gray-100 lg:overflow-hidden lg:h-screen"
          style={ReactDOMRe.Style.make(~maxHeight="calc(100vh - 4.5rem)", ())}>
          <div className="w-full h-full flex flex-col lg:flex-row border-t-4 border-night">
            <div
              className="w-full lg:border-r-4 pl-2 border-night"
              style=?{windowWidth > 1024 ? Some(ReactDOMRe.Style.make(~maxWidth="65%", ())) : None}>
              <div className="bg-gray-100 text-snow-darker">
                <ControlPanel
                  actionIndicatorKey={Belt.Int.toString(actionCount)}
                  state=compilerState
                  dispatch=compilerDispatch
                  editorCode
                />
                <CodeMirror
                  className="w-full py-4"
                  minHeight="calc(100vh - 10rem)"
                  maxHeight="calc(100vh - 10rem)"
                  mode="reason"
                  errors=cmErrors
                  value={React.Ref.current(editorCode)}
                  onChange={value => {
                    React.Ref.setCurrent(editorCode, value)

                    switch React.Ref.current(typingTimer) {
                    | None => ()
                    | Some(timer) => Js.Global.clearTimeout(timer)
                    }
                    let timer = Js.Global.setTimeout(() => {
                      React.Ref.current(timeoutCompile)()
                      React.Ref.setCurrent(typingTimer, None)
                    }, 100)
                    React.Ref.setCurrent(typingTimer, Some(timer))
                  }}
                  onMarkerFocus={rowCol => setFocusedRowCol(prev => Some(rowCol))}
                  onMarkerFocusLeave={_ => setFocusedRowCol(_ => None)}
                />
              </div>
            </div>
            <div
              className="relative w-full overflow-x-hidden h-screen lg:h-auto lg:w-1/2"
              style={ReactDOMRe.Style.make(~maxWidth=windowWidth > 1024 ? "56rem" : "100%", ())}>
              <OutputPanel
                actionIndicatorKey={Belt.Int.toString(actionCount)}
                compilerDispatch
                compilerState
                editorCode
              />
              <div className="absolute bottom-0 w-full">
                <Statusbar
                  actionIndicatorKey={Belt.Int.toString(actionCount)} state=compilerState
                />
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  </>
}
