type options = {
  apiKey: string,
  indexName: string,
  inputSelector: string,
}

@val @scope("document")
external activeElement: option<Dom.element> = "activeElement"

@val @scope("window")
external docsearch: option<options => unit> = "docsearch"

type keyboardEventLike = {key: string, ctrlKey: bool, metaKey: bool}

@val @scope("window")
external addKeyboardEventListener: (string, keyboardEventLike => unit) => unit = "addEventListener"

@val @scope("window")
external removeKeyboardEventListener: (string, keyboardEventLike => unit) => unit =
  "addEventListener"

@send
external keyboardEventPreventDefault: keyboardEventLike => unit = "preventDefault"

type state =
  | Active
  | Inactive

@get external isContentEditable: Dom.element => bool = "isContentEditable"
@get external tagName: Dom.element => string = "tagName"
@send external focus: Dom.element => unit = "focus"
@send external blur: Dom.element => unit = "blur"
@set external value: (Dom.element, string) => unit = "value"

@react.component
let make = () => {
  // Used for the text input
  let inputRef = React.useRef(Js.Nullable.null)
  let (state, setState) = React.useState(_ => Inactive)

  React.useEffect0(() => {
    switch docsearch {
    | Some(init) =>
      init({
        apiKey: "d3d9d7cebf13a7b665e47cb85dc9c582",
        indexName: "rescript-lang",
        inputSelector: "#docsearch",
      })
    | None => ()
    }

    None
  })

  React.useEffect1(() => {
    let isEditableTag = el =>
      switch el->tagName {
      | "TEXTAREA" | "SELECT" | "INPUT" => true
      | _ => false
      }

    let focusSearch = e => {
      switch activeElement {
      | Some(el) if el->isEditableTag => ()
      | Some(el) if el->isContentEditable => ()
      | _ => {
          setState(_ => Active)
          inputRef.current->Js.Nullable.toOption->Belt.Option.forEach(focus)

          e->keyboardEventPreventDefault
        }
      }
    }

    let handleGlobalKeyDown = e => {
      switch e.key {
      | "/" => focusSearch(e)
      | "k" if e.ctrlKey || e.metaKey => focusSearch(e)
      | _ => ()
      }
    }

    addKeyboardEventListener("keydown", handleGlobalKeyDown)
    Some(() => removeKeyboardEventListener("keydown", handleGlobalKeyDown))
  }, [setState])

  let focusInput = () =>
    inputRef.current->Js.Nullable.toOption->Belt.Option.forEach(el => el->focus)

  let clearInput = () =>
    inputRef.current->Js.Nullable.toOption->Belt.Option.forEach(el => el->value(""))

  let blurInput = () => inputRef.current->Js.Nullable.toOption->Belt.Option.forEach(el => el->blur)

  let onClick = _ => {
    /* ReactEvent.Mouse.preventDefault(evt); */
    setState(_ => Active)
    clearInput()
    focusInput()
  }

  let onBlur = _ => {
    /* ReactEvent.Focus.preventDefault(evt); */
    /* ReactEvent.Focus.stopPropagation(evt); */
    clearInput()
    setState(_ => Inactive)
  }

  let onKeyDown = evt => {
    let key = ReactEvent.Keyboard.key(evt)

    switch key {
    | "Escape" => blurInput()
    | _ => ()
    }
  }

  let isActive = switch state {
  | Active => true
  | Inactive => false
  }

  let activeClass = isActive ? "text-white border border-gray-60" : ""
  let activeInput = isActive ? "w-32 mr-3" : "w-0"

  <div
    className={activeClass ++ " bg-gray-100 border border-gray-70 hover:text-white hover:cursor-pointer flex justify-center p-2 px-3 rounded-lg"}
    onClick>
    <input
      ref={ReactDOM.Ref.domRef(inputRef)}
      type_="text"
      id="docsearch"
      onBlur
      onKeyDown
      className={"transition-all ease-in-out duration-150 text-white bg-gray-100 border-none focus:outline-none " ++
      activeInput}
    />
    <Icon.MagnifierGlass className="text-gray-60 w-5 h-5" />
  </div>
}

module Textbox = {
  @react.component
  let make = (~id: string) => {
    React.useEffect0(() => {
      switch docsearch {
      | Some(init) =>
        init({
          apiKey: "d3d9d7cebf13a7b665e47cb85dc9c582",
          indexName: "rescript-lang",
          inputSelector: "#" ++ id,
        })
      | None => ()
      }
      None
    })

    // Used for the text input
    let inputRef = React.useRef(Js.Nullable.null)
    let (state, setState) = React.useState(_ => Inactive)

    let focusInput = () =>
      inputRef.current->Js.Nullable.toOption->Belt.Option.forEach(el => el->focus)

    let _clearInput = () =>
      inputRef.current->Js.Nullable.toOption->Belt.Option.forEach(el => el->value(""))

    let blurInput = () =>
      inputRef.current->Js.Nullable.toOption->Belt.Option.forEach(el => el->blur)

    let onClick = _ => {
      /* ReactEvent.Mouse.preventDefault(evt); */
      setState(_ => Active)
      focusInput()
    }

    let onBlur = _ =>
      /* ReactEvent.Focus.preventDefault(evt); */
      /* ReactEvent.Focus.stopPropagation(evt); */
      setState(_ => Inactive)

    let onKeyDown = evt => {
      let key = ReactEvent.Keyboard.key(evt)

      switch key {
      | "Escape" => blurInput()
      | _ => ()
      }
    }

    let isActive = switch state {
    | Active => true
    | Inactive => false
    }

    let activeClass = isActive ? "text-white border border-white-80" : "opacity-75"
    let activeInput = isActive ? "" : ""

    <div
      className={activeClass ++ " hover:text-white hover:cursor-pointer bg-gray-80 flex items-center p-2 px-3 rounded"}
      onClick>
      <Icon.MagnifierGlass className="w-5 h-5 mr-3" />
      <input
        ref={ReactDOM.Ref.domRef(inputRef)}
        type_="text"
        id
        onBlur
        onKeyDown
        className={"w-32 bg-gray-80 focus:outline-none " ++ activeInput}
      />
    </div>
  }
}
