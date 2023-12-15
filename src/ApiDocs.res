module Docgen = RescriptTools.Docgen

type apiIndex = Js.Dict.t<Js.Json.t>

@module("data/js.json") external apiJs: apiIndex = "default"
@module("data/belt.json") external apiBelt: apiIndex = "default"
@module("data/dom.json") external apiDom: apiIndex = "default"
@module("data/api_module_paths.json") external modulePaths: array<string> = "default"

type params = {slug: array<string>}

type field = {
  name: string,
  docstrings: array<string>,
  signature: string,
  optional: bool,
  deprecated: Js.Null.t<string>,
}
type constructor = {
  name: string,
  docstrings: array<string>,
  signature: string,
  deprecated: Js.Null.t<string>,
}

type detail =
  | Record({items: array<field>})
  | Variant({items: array<constructor>})

type item =
  | Value({
      id: string,
      docstrings: array<string>,
      signature: string,
      name: string,
      deprecated: Js.Null.t<string>,
    })
  | Type({
      id: string,
      docstrings: array<string>,
      signature: string,
      name: string,
      deprecated: Js.Null.t<string>,
      detail: Js.Null.t<detail>,
    })

type mod = {
  id: string,
  docstrings: array<string>,
  deprecated: Js.Null.t<string>,
  name: string,
  items: array<item>,
}

type props = result<mod, string>

type aliasH2 = Markdown.H2.props<string, React.element> => React.element
external asMarkdownH2: 'a => aliasH2 = "%identity"

let default = (props: props) => {
  let overlayState = React.useState(() => false)

  open Markdown

  let docstringsMarkdown = docstrings => {
    let components = {
      ...MarkdownComponents.default,
      h2: MarkdownComponents.default.h3->asMarkdownH2,
    }

    docstrings
    ->Js.Array2.map(doc => <ReactMarkdown components={components}> doc </ReactMarkdown>)
    ->React.array
  }

  let item = switch props {
  | Ok({id, docstrings, items}) =>
    let valuesAndType = items->Js.Array2.map(item => {
      switch item {
      | Value({name, signature, docstrings}) =>
        let code = Js.String2.replaceByRe(signature, %re("/\\n/g"), "\n")
        <>
          <H2 id=name> {name->React.string} </H2>
          <CodeExample code lang="rescript" />
          {docstrings->docstringsMarkdown}
        </>
      | Type({name, signature, docstrings}) =>
        let code = Js.String2.replaceByRe(signature, %re("/\\n/g"), "\n")
        <>
          <H2 id=name> {name->React.string} </H2>
          <CodeExample code lang="rescript" />
          {docstrings->docstringsMarkdown}
        </>
      }
    })

    <>
      <H1> {id->React.string} </H1>
      {docstrings->docstringsMarkdown}
      {valuesAndType->React.array}
    </>
  | _ => React.null
  }

  let valuesAndTypes = switch props {
  | Ok({items}) if Js.Array2.length(items) > 0 =>
    let valuesAndTypes = items->Belt.Array.keepMap(item => {
      switch item {
      | Value({name}) as kind | Type({name}) as kind =>
        let icon = switch kind {
        | Type(_) => "T"
        | Value(_) => "V"
        }
        let (textColor, bgColor) = switch kind {
        | Type(_) => ("text-fire-30", "bg-fire-5")
        | Value(_) => ("text-sky-30", "bg-sky-5")
        }
        let result =
          <li className="my-3 flex">
            <a
              className="flex font-normal text-14 text-gray-40 leading-tight hover:text-gray-80"
              href={`#${name}`}>
              <div
                className={`${bgColor} w-5 h-5 mr-3 flex justify-center items-center rounded-xl`}>
                <span style={ReactDOM.Style.make(~fontSize="10px", ())} className=textColor>
                  {icon->React.string}
                </span>
              </div>
              {React.string(name)}
            </a>
          </li>
        Some(result)
      }
    })
    valuesAndTypes->Some
  | _ => None
  }

  <>
    <Meta title="API | ReScript API" />
    <div className={"mt-16 min-w-320 "}>
      <div className="w-full">
        <Navigation overlayState />
        <div className="flex lg:justify-center">
          <div className="flex w-full max-w-1280 md:mx-8">
            <main className="px-4 w-full pt-16 md:ml-12 lg:mr-8 mb-32 md:max-w-576 lg:max-w-740">
              item
            </main>
            {switch valuesAndTypes {
            | Some(elemets) =>
              <div className="pt-16 relative">
                <aside
                  className="sticky top-18 overflow-auto px-8"
                  style={ReactDOM.Style.make(~height="calc(100vh - 6rem)", ())}>
                  <span className="font-normal block text-14 text-gray-40">
                    {React.string("Types and Values")}
                  </span>
                  <ul> {elemets->React.array} </ul>
                </aside>
              </div>
            | None => React.null
            }}
          </div>
        </div>
      </div>
      <Footer />
    </div>
  </>
}

let getStaticProps: Next.GetStaticProps.t<props, params> = async ctx => {
  let {params} = ctx

  let slug = params.slug

  let moduleId = slug->Js.Array2.joinWith("/")

  let content = switch slug->Belt.Array.get(0) {
  | Some(topLevelModule) =>
    let apiContent = switch topLevelModule {
    | "js" => apiJs->Some
    | "belt" => apiBelt->Some
    | "dom" => apiDom->Some
    | _ => None
    }

    switch apiContent {
    | Some(content) => content->Js.Dict.get(moduleId)
    | None => None
    }
  | None => None
  }

  let docItem = switch content {
  | Some(json) =>
    switch json->Js.Json.decodeObject {
    | Some(obj) => Docgen.decodeModule(obj)->Some
    | None => None
    }
  | None => None
  }

  let props = switch docItem {
  | Some(Docgen.Module({id, name, docstrings, items, ?deprecated})) =>
    let items = items->Js.Array2.map(item =>
      switch item {
      | Docgen.Value({id, docstrings, signature, name, ?deprecated}) =>
        Value({
          id,
          docstrings,
          signature,
          name,
          deprecated: deprecated->Js.Null.fromOption,
        })
      | Type({id, docstrings, signature, name, ?deprecated, ?detail}) =>
        let detail = switch detail {
        | Some(kind) =>
          switch kind {
          | Docgen.Record({items}) =>
            let items = items->Js.Array2.map(({
              name,
              docstrings,
              signature,
              optional,
              ?deprecated,
            }) => {
              {
                name,
                docstrings,
                signature,
                optional,
                deprecated: deprecated->Js.Null.fromOption,
              }
            })
            Record({items: items})->Js.Null.return
          | Variant({items}) =>
            let items = items->Js.Array2.map(({name, docstrings, signature, ?deprecated}) => {
              {
                name,
                docstrings,
                signature,
                deprecated: deprecated->Js.Null.fromOption,
              }
            })

            Variant({items: items})->Js.Null.return
          }
        | None => Js.Null.empty
        }
        Type({
          id,
          docstrings,
          signature,
          name,
          deprecated: deprecated->Js.Null.fromOption,
          detail,
        })
      | _ => assert(false)
      }
    )
    {
      id,
      name,
      docstrings,
      deprecated: deprecated->Js.Null.fromOption,
      items,
    }->Ok
  | _ => Error(`Failed to find module ${moduleId}`)
  }

  {"props": props}
}

let getStaticPaths: Next.GetStaticPaths.t<params> = async () => {
  open Next.GetStaticPaths

  let paths = modulePaths->Js.Array2.map(slug => {
    params: {
      slug: slug->Js.String2.split("/"),
    },
  })

  {paths, fallback: false}
}
