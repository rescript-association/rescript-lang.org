type t

type options = {
  apiKey: string,
  indexName: string,
  inputSelector: string,
}

@bs.val @bs.scope("window")
external docsearch: option<options => unit> = "docsearch"

type state =
  | Active
  | Inactive

@bs.send external focus: Dom.element => unit = "focus"
@bs.send external blur: Dom.element => unit = "blur"
@bs.set external value: (Dom.element, string) => unit = "value"

@react.component
let make = () => {
  React.useEffect1(() => {
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
  }, [])

  // Used for the text input
  let inputRef = React.useRef(Js.Nullable.null)
  let (state, setState) = React.useState(_ => Inactive)

  let focusInput = () =>
    React.Ref.current(inputRef)->Js.Nullable.toOption->Belt.Option.forEach(el => el->focus)

  let clearInput = () =>
    React.Ref.current(inputRef)->Js.Nullable.toOption->Belt.Option.forEach(el => el->value(""))

  let blurInput = () =>
    React.Ref.current(inputRef)->Js.Nullable.toOption->Belt.Option.forEach(el => el->blur)

  let onClick = evt => {
    /* ReactEvent.Mouse.preventDefault(evt); */
    setState(_ => Active)
    clearInput()
    focusInput()
  }

  let onBlur = evt => {
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

  let activeClass = isActive ? "text-white border border-white-80" : ""
  let activeInput = isActive ? "w-32 mr-3" : "w-0"

  <div
    className={activeClass ++ " bg-night hover:text-white hover:cursor-pointer flex justify-center p-2 px-3 rounded"}
    onClick>
    <input
      ref={ReactDOMRe.Ref.domRef(inputRef)}
      type_="text"
      id="docsearch"
      onBlur
      onKeyDown
      className={"transition-all ease-in-out duration-150 text-white bg-night border-none focus:outline-none " ++
      activeInput}
    />
    <Icon.MagnifierGlass className="w-5 h-5" />
  </div>
}

module Textbox = {
  @react.component
  let make = (~id: string) => {
    React.useEffect1(() => {
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
    }, [])

    // Used for the text input
    let inputRef = React.useRef(Js.Nullable.null)
    let (state, setState) = React.useState(_ => Inactive)

    let focusInput = () =>
      React.Ref.current(inputRef)->Js.Nullable.toOption->Belt.Option.forEach(el => el->focus)

    let clearInput = () =>
      React.Ref.current(inputRef)->Js.Nullable.toOption->Belt.Option.forEach(el => el->value(""))

    let blurInput = () =>
      React.Ref.current(inputRef)->Js.Nullable.toOption->Belt.Option.forEach(el => el->blur)

    let onClick = evt => {
      /* ReactEvent.Mouse.preventDefault(evt); */
      setState(_ => Active)
      focusInput()
    }

    let onBlur = evt =>
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
      className={activeClass ++ " hover:text-white hover:cursor-pointer bg-night flex items-center p-2 px-3 rounded"}
      onClick>
      <Icon.MagnifierGlass className="w-5 h-5 mr-3" />
      <input
        ref={ReactDOMRe.Ref.domRef(inputRef)}
        type_="text"
        id
        onBlur
        onKeyDown
        className={"w-32 bg-night focus:outline-none " ++ activeInput}
      />
    </div>
  }
}
