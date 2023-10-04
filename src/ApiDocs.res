type item = {
  id: string,
  name: string,
  docstring: array<string>,
  signature: string,
}
type moduleItem = {
  name: string,
  docstring: array<string>,
  items: array<item>,
}
type apiIndex = {
  name: string,
  docstring: array<string>,
  submodules: Js.Dict.t<moduleItem>,
}
let apiJs: apiIndex = %raw("require('index_data/js.json')")
let apiBelt: apiIndex = %raw("require('index_data/belt.json')")
let apiDom: apiIndex = %raw("require('index_data/dom.json')")

let modulePaths: Js.Dict.t<array<array<string>>> = %raw("require('index_data/modules_paths.json')")

// type mod = Belt(Docgen.doc) | DOM(Docgen.doc) | JS(Docgen.doc)

type params = {slug: array<string>}

type props = {content: moduleItem}

// let docs = [
//   apiJs->Docgen.decodeFromJson,
//   apiBelt->Docgen.decodeFromJson,
//   apiDom->Docgen.decodeFromJson,
// ]

// module Sidebar = SidebarLayout.Sidebar

// let items = docs->Js.Array2.map(doc => {
//   Sidebar.NavItem.name: doc.name,
//   href: doc.name->Js.String2.toLowerCase,
// })

// let categories = [{Sidebar.Category.name: "Modules"->Some, items}]
external toReactElement: string => React.element = "%identity"
let default = (props: props) => {
  let overlayState = React.useState(() => false)
  // let router = Next.Router.useRouter()
  // let route = router.route

  let {content} = props

  <>
    <Meta title="API | ReScript API" />
    <div className={"mt-16 min-w-320 "}>
      <div className="w-full">
        <Navigation overlayState />
        <div className="flex lg:justify-center">
          <div className="flex w-full max-w-1280 md:mx-8">
            // sidebar
            <main className="px-4 w-full pt-16 md:ml-12 lg:mr-8 mb-32 md:max-w-576 lg:max-w-740">
              //width of the right content part
              <Markdown.H1> {content.name->React.string} </Markdown.H1>
              <p> {content.docstring->Js.Array2.joinWith("\n")->React.string} </p>
              // <Markdown.P> {content.docstring->Js.Array2.joinWith("\n")->React.string} </Markdown.P>
              {content.items
              ->Js.Array2.map(item => {
                <>
                  <Markdown.H3 id=item.name> {item.name->React.string} </Markdown.H3>
                </>
              })
              ->React.array}

              // {pcontent.na->Js.Array2.joinWith("/")->React.string}
            </main>
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

  let topLevelModule = slug->Js.Array2.unsafe_get(0)
  let subModuleTarget = slug->Js.Array2.joinWith(".")

  let processModule = async (moduleItem: moduleItem) => {
    {docstring: moduleItem.docstring, name: moduleItem.name, items: []}
  }

  let result = await switch topLevelModule {
  | "belt" => apiBelt.submodules->Js.Dict.unsafeGet(subModuleTarget)
  | "js" => apiJs.submodules->Js.Dict.unsafeGet(subModuleTarget)
  | "dom" => apiDom.submodules->Js.Dict.unsafeGet(subModuleTarget)
  | _ => assert false
  }->processModule

  let props = {
    content: result,
  }

  {"props": props}
}

@send external flat: array<array<'t>> => array<'t> = "flat"

let getStaticPaths: Next.GetStaticPaths.t<params> = async () => {
  open Next.GetStaticPaths

  let paths =
    modulePaths
    ->Js.Dict.keys
    ->Js.Array2.map(name => {
      let submodulesPaths =
        Js.Dict.unsafeGet(modulePaths, name)->Js.Array2.map(i => Js.Array2.concat([name], i))
      Js.Array2.concat([[name]], submodulesPaths)
    })
    ->flat
    ->Js.Array2.map(slug => {
      params: {
        slug: slug,
      },
    })

  {paths, fallback: false}
}
