/*
 * This SearchBox is used for fuzzy-find search scenarios, such as the syntax widget tool or
 * the package index
 */

@send external focus: Dom.element => unit = "focus"

type state =
  | Active
  | Inactive

@react.component
let make = (
  ~completionValues: array<string>=[], // set of possible values
  ~value: string,
  ~onClear: unit => unit,
  ~placeholder: string="",
  ~onValueChange: string => unit,
) => {
  let (state, setState) = React.useState(_ => Inactive)
  let textInput = React.useRef(Nullable.null)

  let onMouseDownClear = evt => {
    ReactEvent.Mouse.preventDefault(evt)
    onClear()
  }

  let focusInput = () => textInput.current->Nullable.forEach(el => el->focus)

  let onAreaFocus = evt => {
    let el = ReactEvent.Focus.target(evt)
    let isDiv = Nullable.isNullable(el["type"])

    if isDiv && state === Inactive {
      focusInput()
    }
  }

  let onFocus = _ => {
    setState(_ => Active)
  }

  let onBlur = _ => {
    setState(_ => Inactive)
  }

  let onKeyDown = evt => {
    let key = ReactEvent.Keyboard.key(evt)
    let ctrlKey = ReactEvent.Keyboard.ctrlKey(evt)

    let full = (ctrlKey ? "CTRL+" : "") ++ key

    switch full {
    | "Escape" => onClear()
    | "Tab" =>
      if Array.length(completionValues) === 1 {
        let targetValue = Belt.Array.getExn(completionValues, 0)

        if targetValue !== value {
          ReactEvent.Keyboard.preventDefault(evt)
          onValueChange(targetValue)
        } else {
          ()
        }
      }
    | _ => ()
    }
  }

  let onChange = evt => {
    ReactEvent.Form.preventDefault(evt)
    let value = ReactEvent.Form.target(evt)["value"]
    onValueChange(value)
  }

  <div
    tabIndex={-1}
    onFocus=onAreaFocus
    onBlur
    className={(
      state === Active ? "border-fire" : "border-fire-30"
    ) ++ " flex items-center border rounded-lg py-4 px-5"}>
    <Icon.MagnifierGlass
      className={(state === Active ? "text-fire" : "text-fire-70") ++ " w-4 h-4"}
    />
    <input
      value
      ref={ReactDOM.Ref.domRef(textInput)}
      onFocus
      onKeyDown
      onChange={onChange}
      placeholder
      className="text-16 outline-none ml-4 w-full"
      type_="text"
    />
    <button onFocus className={value === "" ? "hidden" : "block"} onMouseDown=onMouseDownClear>
      <Icon.Close className="w-4 h-4 text-fire" />
    </button>
  </div>
}
