module MdxComp = {
  type props
  type t = Js.t<props> => React.element

  let render: t => React.element = %raw(
    `
    function(c) {
      return React.createElement(c, {});
    }
  `
  )

  @bs.get
  external frontmatter: t => Js.Json.t = "frontmatter"
}

@module("misc_docs/syntax/decorator_module.mdx")
external decorator_module: MdxComp.t = "default"

@module("misc_docs/syntax/decorator_as.mdx")
external decorator_as: MdxComp.t = "default"

@module("misc_docs/syntax/controlflow_ifelse.mdx")
external controlflow_ifelse: MdxComp.t = "default"

module Category = {
  type t = Decorators | ControlFlow | Operators | Other

  let toString = t =>
    switch t {
    | Decorators => "Decorators"
    | Operators => "Operators"
    | ControlFlow => "Control Flow"
    | Other => "Other"
    }

  @react.component
  let make = (~title, ~children) => {
    <div>
      <h3 className="font-sans font-black text-night-light tracking-wide text-xs uppercase">
        {React.string(title)}
      </h3>
      children
    </div>
  }
}

type item = {
  keywords: array<string>,
  name: string,
  summary: string,
  category: Category.t,
  component: MdxComp.t,
}

let allItems = [
  {
    keywords: ["@bs.module"],
    name: "@module",
    summary: "This is the @module decorator.",
    category: Decorators,
    component: decorator_module,
  },
  {
    keywords: ["@bs.as"],
    name: "@as",
    summary: "This is the @as decorator.",
    category: Decorators,
    component: decorator_as,
  },
  {
    keywords: ["if", "else", "if else"],
    name: "if / else",
    summary: "This is the if / else control flow structure.",
    category: ControlFlow,
    component: controlflow_ifelse,
  },
]

decorator_as->MdxComp.frontmatter->Js.log

let fuseOpts = Fuse.Options.t(
  ~shouldSort=false,
  ~includeScore=true,
  ~threshold=0.2,
  ~location=0,
  ~distance=30,
  ~minMatchCharLength=1,
  ~keys=["keywords", "name"],
  (),
)

let fuse: Fuse.t<item> = Fuse.make(allItems, fuseOpts)

let getAnchor = path => {
  switch Js.String2.split(path, "#") {
  | [_, anchor] => Some(anchor)
  | _ => None
  }
}

module SearchBox = {
  @react.component
  let make = (~onChange) => {
    <div className="bg-">
      <input onChange={onChange} className="border border-snow-dark bg-snow-light" type_="text" />
    </div>
  }
}

module Tag = {
  @react.component
  let make = (~text: string) => {
    <span className="bg-fire-15 p-1 px-2 font-semibold rounded-lg text-fire text-16">
      {React.string(text)}
    </span>
  }
}

module DetailBox = {
  @react.component
  let make = (~summary, ~children) => {
    <div>
      <div className="text-21 text-center mb-4 font-semibold"> {React.string(summary)} </div>
      <div className="border rounded-lg shadow-xs p-4"> children </div>
    </div>
  }
}

type state =
  | ShowAll
  | ShowFiltered(array<item>)
  | ShowDetails(item)

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let (state, setState) = React.useState(_ => ShowAll)

  React.useEffect0(() => {
    switch getAnchor(router.asPath) {
    | Some(anchor) =>
      Js.Array2.find(allItems, item =>
        GithubSlugger.slug(item.name) === anchor
      )->Belt.Option.forEach(item => {
        setState(_ => ShowDetails(item))
      })
    | None => ()
    }
    None
  })

  /*
  This effect syncs the url anchor with the currently shown final match
  within the fuzzy finder. If there is a new match that doesn't align with
  the current anchor, the url will be rewritten with the correct anchor.

  In case a selection got removed, it will also remove the anchor from the url.
  We don't replace on every state change, because replacing the url is expensive
 */
  React.useEffect1(() => {
    switch (state, getAnchor(router.asPath)) {
    | (ShowDetails(item), Some(anchor)) =>
      let slug = GithubSlugger.slug(item.name)

      if slug !== anchor {
        router->Next.Router.replace("syntax-lookup#" ++ anchor)
      } else {
        ()
      }
    | (ShowDetails(item), None) =>
      router->Next.Router.replace("syntax-lookup#" ++ GithubSlugger.slug(item.name))
    | (_, Some(_)) => router->Next.Router.replace("syntax-lookup")
    | _ => ()
    }
    None
  }, [state])

  let onChange = evt => {
    ReactEvent.Form.preventDefault(evt)
    let value = ReactEvent.Form.target(evt)["value"]

    setState(_ =>
      switch value {
      | "" => ShowAll
      | search =>
        let filtered = fuse->Fuse.search(search)->Belt.Array.map(m => {
          m["item"]
        })
        if Js.Array.length(filtered) === 1 {
          ShowDetails(Js.Array2.unsafe_get(filtered, 0))
        } else {
          ShowFiltered(filtered)
        }
      }
    )
    /* if value === "" { */
    /* setState(_prev => All) */
    /* } else { */
    /* setState(_prev => Filtered(value)) */
    /* } */
  }

  let details = switch state {
  | ShowFiltered(_)
  | ShowAll => React.null
  | ShowDetails(item) =>
    <div className="mb-16">
      <DetailBox summary={item.summary}> {MdxComp.render(item.component)} </DetailBox>
    </div>
  }

  /*
    Order all items in tag groups
 */
  let categories = {
    open Category
    let initial = [Decorators, Operators, ControlFlow, Other]->Belt.Array.map(cat => {
      (cat->toString, [])
    })

    let items = switch state {
    | ShowAll => allItems
    | ShowDetails(_) => []
    | ShowFiltered(items) => items
    }

    Belt.Array.reduce(items, Js.Dict.fromArray(initial), (acc, item) => {
      let key = item.category->toString
      Js.Dict.get(acc, key)->Belt.Option.mapWithDefault(acc, items => {
        Js.Array2.push(items, item)->ignore
        Js.Dict.set(acc, key, items)
        acc
      })
    })->Js.Dict.entries->Belt.Array.reduce([], (acc, entry) => {
      let (title, items) = entry
      if Js.Array.length(items) === 0 {
        acc
      } else {
        let children = Belt.Array.map(items, item => {
          let onMouseDown = evt => {
            ReactEvent.Mouse.preventDefault(evt)
            setState(_ => ShowDetails(item))
          }
          <span className="mr-2 cursor-pointer" onMouseDown key=item.name>
            <Tag text={item.name} />
          </span>
        })
        let el = <Category key=title title> {React.array(children)} </Category>
        Js.Array2.push(acc, el)->ignore
        acc
      }
    })
  }

  <div>
    <div className="text-center">
      <Markdown.H1> {React.string("Syntax Lookup")} </Markdown.H1>
      <div className="mb-8">
        {React.string("Enter some language construct you want to know more about.")}
      </div>
      <div> <SearchBox onChange /> </div>
    </div>
    <div className="mt-10"> {details} {React.array(categories)} </div>
  </div>
}
