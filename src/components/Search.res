let apiKey = "d3d9d7cebf13a7b665e47cb85dc9c582"
let indexName = "rescript-lang"
let appId = "BH4D9OD16A"

@val @scope("document")
external activeElement: option<Dom.element> = "activeElement"

type keyboardEventLike = {key: string, ctrlKey: bool, metaKey: bool}
@val @scope("window")
external addKeyboardEventListener: (string, keyboardEventLike => unit) => unit = "addEventListener"

@val @scope("window")
external removeKeyboardEventListener: (string, keyboardEventLike => unit) => unit =
  "addEventListener"

type window
@val external window: window = "window"
@get external scrollY: window => int = "scrollY"

@send
external keyboardEventPreventDefault: keyboardEventLike => unit = "preventDefault"

@get external tagName: Dom.element => string = "tagName"
@get external isContentEditable: Dom.element => bool = "isContentEditable"

type state = Active | Inactive

@react.component
let make = () => {
  let (state, setState) = React.useState(_ => Inactive)

  React.useEffect1(() => {
    let isEditableTag = el =>
      switch el->tagName {
      | "TEXTAREA" | "SELECT" | "INPUT" => true
      | _ => false
      }

    let focusSearch = e => {
      switch activeElement {
      | Some(el) if el->isEditableTag || el->isContentEditable => ()
      | _ =>
        setState(_ => Active)
        e->keyboardEventPreventDefault
      }
    }

    let handleGlobalKeyDown = e => {
      switch e.key {
      | "/" => focusSearch(e)
      | "k" if e.ctrlKey || e.metaKey => focusSearch(e)
      | "Escape" => setState(_ => Inactive)
      | _ => ()
      }
    }
    addKeyboardEventListener("keydown", handleGlobalKeyDown)
    Some(() => removeKeyboardEventListener("keydown", handleGlobalKeyDown))
  }, [setState])

  let onClick = _ => setState(_ => Active)

  let onClose = React.useCallback1(() => {
    setState(_ => Inactive)
  }, [state])

  <button onClick type_="button" className="text-gray-60 hover:text-fire-50">
    <Icon.MagnifierGlass className="fill-current" />
    {switch state {
    | Active =>
      switch ReactDOM.querySelector("body") {
      | Some(element) =>
        ReactDOM.createPortal(
          <DocSearch
            apiKey
            appId
            indexName
            onClose
            initialScrollY={window->scrollY}
            transformItems={items => {
              // Transform absolute URL intro relative url
              items->Js.Array2.map(item => {
                let url = try Util.Url.make(item.url).pathname catch {
                | Js.Exn.Error(obj) =>
                  switch Js.Exn.message(obj) {
                  | Some(m) =>
                    Js.Console.error("Failed to constructor URL " ++ m)
                    item.url
                  | None => item.url
                  }
                }

                {...item, url}
              })
            }}
          />,
          element,
        )
      | None => React.null
      }
    | Inactive => React.null
    }}
  </button>
}
