let apiKey = "a2485ef172b8cd82a2dfa498d551399b"
let indexName = "rescript-lang"
let appId = "S32LNEY41T"

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

let hit = ({hit, children}: DocSearch.hitComponent) => {
  let toTitle = str =>
    str->Js.String2.charAt(0)->Js.String2.toUpperCase ++ Js.String2.sliceToEnd(str, ~from=1)

  let description = switch hit.url
  ->Js.String2.split("/")
  ->Js.Array2.sliceFrom(1)
  ->Belt.List.fromArray {
  | list{"blog" as r | "community" as r, ..._} => r->toTitle
  | list{"docs", doc, version, ...rest} =>
    let path = rest->Belt.List.toArray

    let info =
      path
      ->Js.Array2.slice(~start=0, ~end_=Js.Array2.length(path) - 1)
      ->Js.Array2.map(path =>
        switch path {
        | "api" => "API"
        | other => toTitle(other)
        }
      )

    [doc->toTitle, version->toTitle]->Js.Array2.concat(info)->Js.Array2.joinWith(" / ")
  | _ => ""
  }

  <Next.Link href={hit.url} className="flex flex-col w-full">
    <span className="text-gray-60 captions px-4 pt-3 pb-1 block">
      {description->React.string}
    </span>
    children
  </Next.Link>
}

let transformItems = (items: DocSearch.transformItems) => {
  items->Belt.Array.keepMap(item => {
    let url = try Webapi.URL.make(item.url)->Some catch {
    | Js.Exn.Error(obj) =>
      Js.Console.error2(`Failed to parse URL ${item.url}`, obj)
      None
    }
    switch url {
    | Some({pathname, hash}) => {...item, url: pathname ++ hash}->Some
    | None => None
    }
  })
}

@react.component
let make = () => {
  let (state, setState) = React.useState(_ => Inactive)
  let router = Next.Router.useRouter()

  let version = switch Url.parse(router.route).version {
  | Version(v) => v
  | _ => "latest"
  }

  let handleCloseModal = () => {
    let () = switch ReactDOM.querySelector(".DocSearch-Modal") {
    | Some(modal) =>
      switch ReactDOM.querySelector("body") {
      | Some(body) =>
        open Webapi
        body->Element.classList->ClassList.remove("DocSearch--active")
        modal->Element.addEventListener("transitionend", () => {
          setState(_ => Inactive)
        })
      | None => setState(_ => Inactive)
      }
    | None => ()
    }
  }

  React.useEffect(() => {
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
      | "Escape" => handleCloseModal()
      | _ => ()
      }
    }
    addKeyboardEventListener("keydown", handleGlobalKeyDown)
    Some(() => removeKeyboardEventListener("keydown", handleGlobalKeyDown))
  }, [setState])

  let onClick = _ => {
    setState(_ => Active)
  }

  let onClose = React.useCallback(() => {
    handleCloseModal()
  }, [setState])

  <>
    <button onClick type_="button" className="text-gray-60 hover:text-fire-50 p-2">
      <Icon.MagnifierGlass className="fill-current" />
    </button>
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
            searchParameters={facetFilters: ["version:" ++ version]}
            initialScrollY={window->scrollY}
            transformItems={transformItems}
            hitComponent=hit
          />,
          element,
        )
      | None => React.null
      }
    | Inactive => React.null
    }}
  </>
}
