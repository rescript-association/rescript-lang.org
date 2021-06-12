// Structure defined by `scripts/extract-syntax.js`
type syntaxData = {
  "file": string,
  "id": string,
  "keywords": array<string>,
  "name": string,
  "summary": string,
  "category": string,
}

let indexData: array<syntaxData> = %raw("require('index_data/syntax_index.json')")

module MdxComp = {
  type props
  type t = props => React.element

  let render: t => React.element = %raw(`
    function(c) {
      return React.createElement(c, {});
    }
  `)

  /* @get */
  /* external frontmatter: t => Js.Json.t = "frontmatter" */
}

let requireSyntaxFile: string => MdxComp.t = %raw(`
  function(name) {
    return require("misc_docs/syntax/" + name + ".mdx").default
  }
`)

module Category = {
  type t = Decorators | Operators | LanguageConstructs | SpecialValues | Other

  let toString = t =>
    switch t {
    | Decorators => "Decorators"
    | Operators => "Operators"
    | LanguageConstructs => "Language Constructs"
    | SpecialValues => "Special Values"
    | Other => "Other"
    }

  let fromString = (s: string): t => {
    switch s {
    | "decorators" => Decorators
    | "specialvalues" => SpecialValues
    | "operators" => Operators
    | "languageconstructs" => LanguageConstructs
    | _ => Other
    }
  }

  @react.component
  let make = (~title, ~children) => {
    <div>
      <h3 className="font-sans font-medium text-gray-100 tracking-wide text-14 uppercase mb-2">
        {React.string(title)}
      </h3>
      <div className="flex flex-wrap"> children </div>
    </div>
  }
}

// The data representing a syntax construct
// handled in the widget
type item = {
  id: string,
  keywords: array<string>,
  name: string,
  summary: string,
  category: Category.t,
  component: MdxComp.t,
}

let toItem = (syntaxData: syntaxData): item => {
  let file = syntaxData["file"]
  let id = syntaxData["id"]
  let keywords = syntaxData["keywords"]
  let name = syntaxData["name"]
  let summary = syntaxData["summary"]
  let category = syntaxData["category"]
  let item: item = {
    id: id,
    keywords: keywords,
    name: name,
    summary: summary,
    category: Category.fromString(category),
    component: requireSyntaxFile(file),
  }
  item
}

let allItems = indexData->Belt.Array.map(toItem)

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

module Tag = {
  @react.component
  let make = (~text: string) => {
    <span className="hover:bg-fire hover:text-white bg-fire-10 py-1 px-3 rounded text-fire text-16">
      {React.string(text)}
    </span>
  }
}

module DetailBox = {
  @react.component
  let make = (~summary: string, ~children: React.element) => {
    let summaryEl = switch Js.String2.split(summary, "`") {
    | [] => React.null
    | [first, second, third] =>
      [
        React.string(first),
        <span className="text-fire"> {React.string(second)} </span>,
        React.string(third),
      ]
      ->Belt.Array.mapWithIndex((i, el) => {
        <span key={Belt.Int.toString(i)}> el </span>
      })
      ->React.array
    | more => Belt.Array.map(more, s => React.string(s))->React.array
    }

    <div>
      <div className="text-21 border-b border-gray-40 pb-4 mb-4 font-semibold"> summaryEl </div>
      <div className="mt-16"> children </div>
    </div>
  }
}

type state =
  | ShowAll
  | ShowFiltered(string, array<item>) // (search, filteredItems)
  | ShowDetails(item)

type action =
  | URLChanged(string)
  | SearchValueChanged(string)
  | ItemSelected(item)

let stateFromPath = path =>
  getAnchor(path)
  ->Belt.Option.flatMap(anchor =>
    Js.Array2.find(allItems, item => GithubSlugger.slug(item.id) === anchor)
  )
  ->Belt.Option.map(item => ShowDetails(item))
  ->Belt.Option.getWithDefault(ShowAll)

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let (state, dispatch) = ReactUpdate.useReducerWithMapState(
    (_state, action) => {
      let noCancel = () => None
      switch action {
      | URLChanged(path) => Update(stateFromPath(path))
      | SearchValueChanged("") =>
        UpdateWithSideEffects(ShowAll, _ => router->Next.Router.push("syntax-lookup")->noCancel)
      | SearchValueChanged(search) =>
        let filtered =
          fuse
          ->Fuse.search(search)
          ->Belt.Array.map(m => {
            m["item"]
          })
        switch filtered {
        | [item] if item.name == search =>
          UpdateWithSideEffects(
            ShowDetails(item),
            _ =>
              router->Next.Router.push("syntax-lookup#" ++ GithubSlugger.slug(item.id))->noCancel,
          )
        | _ => Update(ShowFiltered(search, filtered))
        }
      | ItemSelected(item) =>
        UpdateWithSideEffects(
          ShowDetails(item),
          _ => router->Next.Router.push("syntax-lookup#" ++ GithubSlugger.slug(item.id))->noCancel,
        )
      }
    },
    // Build initial state from URL
    () => stateFromPath(router.asPath),
  )

  // When the back button is used, re-build the state from the new URL.
  React.useEffect0(() => {
    router->Next.Router.beforePopState(({url}) => {
      dispatch(URLChanged(url))
      true
    })
    None
  })

  let details = switch state {
  | ShowFiltered(_, _)
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
    let initial = [
      Decorators,
      Operators,
      LanguageConstructs,
      SpecialValues,
      Other,
    ]->Belt.Array.map(cat => {
      (cat->toString, [])
    })

    let items = switch state {
    | ShowAll => allItems
    | ShowDetails(_) => []
    | ShowFiltered(_, items) => items
    }

    Belt.Array.reduce(items, Js.Dict.fromArray(initial), (acc, item) => {
      let key = item.category->toString
      Js.Dict.get(acc, key)->Belt.Option.mapWithDefault(acc, items => {
        Js.Array2.push(items, item)->ignore
        Js.Dict.set(acc, key, items)
        acc
      })
    })
    ->Js.Dict.entries
    ->Belt.Array.reduce([], (acc, entry) => {
      let (title, items) = entry
      if Js.Array.length(items) === 0 {
        acc
      } else {
        let children = Belt.Array.map(items, item => {
          let onMouseDown = evt => {
            ReactEvent.Mouse.preventDefault(evt)
            dispatch(ItemSelected(item))
          }
          <span className="mr-2 mb-2 cursor-pointer" onMouseDown key=item.name>
            <Tag text={item.name} />
          </span>
        })
        let el =
          <div key=title className="first:mt-0 mt-12">
            <Category title> {React.array(children)} </Category>
          </div>
        Js.Array2.push(acc, el)->ignore
        acc
      }
    })
  }

  let (searchValue, completionItems) = switch state {
  | ShowFiltered(search, items) => (search, items)
  | ShowAll => ("", allItems)
  | ShowDetails(item) => (item.name, [item])
  }

  <div>
    <div className="flex flex-col items-center">
      <div className="text-center" style={ReactDOM.Style.make(~maxWidth="21rem", ())}>
        <Markdown.H1> {React.string("Syntax Lookup")} </Markdown.H1>
        <div className="mb-8 text-gray-60-tr text-14">
          {React.string("Enter some language construct you want to know more about.")}
        </div>
      </div>
      <div className="w-full" style={ReactDOM.Style.make(~maxWidth="34rem", ())}>
        <SearchBox
          placeholder="Enter keywords or syntax..."
          completionValues={Belt.Array.map(completionItems, item => item.name)}
          value=searchValue
          onClear={() => dispatch(SearchValueChanged(""))}
          onValueChange={value => dispatch(SearchValueChanged(value))}
        />
      </div>
    </div>
    <div className="mt-10"> {details} {React.array(categories)} </div>
  </div>
}
