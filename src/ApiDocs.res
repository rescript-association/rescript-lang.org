type apiIndex = Js.Dict.t<Js.Json.t>

let apiJs: apiIndex = %raw("require('data/js.json')")
let apiBelt: apiIndex = %raw("require('data/belt.json')")
let apiDom: apiIndex = %raw("require('data/dom.json')")
let modulePaths: array<string> = %raw("require('data/api_module_paths.json')")

type params = {slug: array<string>}

type props = {doc: Js.Json.t}

let default = (props: props) => {
  let overlayState = React.useState(() => false)

  let {doc} = props

  let docItem = switch doc->Js.Json.decodeObject {
  | Some(obj) => Docgen.decodeModule(obj)->Some
  | None => None
  }

  open Markdown

  let item = switch docItem {
  | Some(Docgen.Module({id, docstrings, items})) =>
    let valuesAndType = items->Js.Array2.map(item => {
      switch item {
      | Value({name, signature, docstrings}) =>
        let code = Js.String2.replaceByRe(signature, %re("/\\n/g"), "\n")
        <>
          <H2 id=name> {name->React.string} </H2>
          <CodeExample code lang="rescript" />
          <P> {docstrings->Js.Array2.map(doc => React.string(doc))->React.array} </P>
        </>
      | Type({name, signature, docstrings}) =>
        let code = Js.String2.replaceByRe(signature, %re("/\\n/g"), "\n")
        <>
          <H2 id=name> {name->React.string} </H2>
          <CodeExample code lang="rescript" />
          <P> {docstrings->Js.Array2.map(doc => React.string(doc))->React.array} </P>
        </>
      | _ => React.null
      }
    })

    <>
      <H1> {id->React.string} </H1>
      <P> {docstrings->Js.Array2.map(doc => React.string(doc))->React.array} </P>
      {valuesAndType->React.array}
    </>
  | _ => React.null
  }

  let valuesAndTypes = switch docItem {
  | Some(Docgen.Module({items})) if Js.Array2.length(items) > 0 =>
    let valuesAndTypes = items->Belt.Array.keepMap(item => {
      switch item {
      | Value({name}) as kind | Type({name}) as kind =>
        let icon = switch kind {
        | Type(_) => "T"
        | Value(_) => "V"
        | _ => ""
        }
        let (textColor, bgColor) = switch kind {
        | Type(_) => ("text-fire-30", "bg-fire-5")
        | Value(_) => ("text-sky-30", "bg-sky-5")
        | _ => ("", "")
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
      | _ => None
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
  let topLevelModule = slug->Js.Array2.unsafe_get(0)

  let apiContent = switch topLevelModule {
  | "js" => apiJs
  | "belt" => apiBelt
  | "dom" => apiDom
  | _ => assert false
  }

  let content = apiContent->Js.Dict.unsafeGet(moduleId)

  let props = {
    doc: content,
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
