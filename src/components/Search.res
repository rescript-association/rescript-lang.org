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

@val @scope(("window", "location")) external pathname: string = "pathname"
let transformItems = (items: DocSearch.transformItems) => {
  let version = switch pathname {
  | "/" => Url.Latest
  | other => Url.parse(other).version
  }

  items->Belt.Array.keepMap(item => {
    // Transform absolute URL into relative
    let url = try Util.Url.make(item.url)->Some catch {
    | Js.Exn.Error(obj) =>
      Js.Console.error2(`Failed to parse URL ${item.url}`, obj)
      None
    }
    switch url {
    | Some({pathname, hash}) =>
      let versionStr = switch version {
      | Latest | NoVersion => "latest"
      | Version(v) => v
      }
      let urlVersion = switch Url.parse(pathname).version {
      | Latest | NoVersion => "latest"
      | Version(v) => v
      }

      if urlVersion == versionStr {
        let (lvl1, type_) = switch item.hierarchy.lvl1->Js.Nullable.toOption {
        | Some(_) => (item.hierarchy.lvl1, item.type_)
        | None => (item.hierarchy.lvl0->Js.Nullable.return, #lvl1)
        }
        let hierarchy = {...item.hierarchy, lvl1}
        {...item, url: pathname ++ hash, hierarchy, type_}->Some
      } else {
        None
      }
    | None => None
    }
  })
}

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
