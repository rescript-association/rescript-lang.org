let apiJs: Js.Json.t = %raw("require('data/api_js.json')")

let apiBelt: Js.Json.t = %raw("require('data/api_belt.json')")

let apiDom: Js.Json.t = %raw("require('data/api_dom.json')")

type mod = Belt(Docgen.doc) | DOM(Docgen.doc) | JS(Docgen.doc)

type params = {slug: array<string>}

type props = {posts: array<string>}

let docs = [
  apiJs->Docgen.decodeFromJson,
  apiBelt->Docgen.decodeFromJson,
  apiDom->Docgen.decodeFromJson,
]

module Sidebar = SidebarLayout.Sidebar

let items = docs->Js.Array2.map(doc => {
  Sidebar.NavItem.name: doc.name,
  href: doc.name->Js.String2.toLowerCase,
})

let categories = [{Sidebar.Category.name: "Modules"->Some, items}]

let default = (props: props) => {
  Js.log(props)
  let overlayState = React.useState(() => false)
  let router = Next.Router.useRouter()
  let route = router.route

  let sidebar = <Sidebar categories route isOpen=false toggle={() => Js.log("clicked")} />

  let (isSidebarOpen, setSidebarOpen) = React.useState(_ => false)

  Js.log(route)

  let sidebarState = (isSidebarOpen, setSidebarOpen)

  let children = {
    <>
      <h1 className="hl-1 mb-6"> {"ReScript API"->React.string} </h1>
    </>
  }

  // <SidebarLayout
  //   metaTitle={"API"} theme=#Reason components=ApiMarkdown.default sidebarState sidebar>
  //   children
  // </SidebarLayout>

  // <h1> {"Heloo"->React.string} </h1>
  // <>
  //   <Meta
  //     siteName="ReScript API" title="API | ReScript API" description="ReScript API Documentation"
  //   />
  //   <div className="mt-16 pt-2">
  //     <div className="text-gray-80 text-18">
  //       <Navigation overlayState />
  //       <div className="flex overflow-hidden">
  //         <div
  //           className="flex justify-between min-w-320 px-4 pt-16 lg:align-center w-full lg:px-8 pb-48">
  //           <Mdx.Provider components=Markdown.default>
  //             <main className="max-w-1280 w-full flex justify-center">
  //               sidebar
  //               // <Markdown.Intro> overview </Markdown.Intro>

  //               // {React.string(overview)}
  //               // <div style={ReactDOM.Style.make(~maxWidth="44.0625rem", ())} className="w-full">
  //               //   <Markdown.H1> {React.string("ReScript API")} </Markdown.H1>
  //               // </div>
  //             </main>
  //           </Mdx.Provider>
  //         </div>
  //       </div>
  //       <Footer />
  //     </div>
  //   </div>
  // </>

  <>
    <Meta title="API | ReScript API" />
    <div className={"mt-16 min-w-320 "}>
      <div className="w-full">
        <Navigation overlayState />
        <div className="flex lg:justify-center">
          <div className="flex w-full max-w-1280 md:mx-8">
            sidebar
            <main className="px-4 w-full pt-16 md:ml-12 lg:mr-8 mb-32 md:max-w-576 lg:max-w-740">
              //width of the right content part
              {"Hello"->React.string}
            </main>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  </>
}

let getStaticProps: Next.GetStaticProps.t<props, params> = async ctx => {
  // let (archived, nonArchived) = BlogApi.getAllPosts()->Belt.Array.partition(data => data.archived)

  let {params} = ctx
  let props = {
    posts: params.slug,
  }

  {"props": props}
}

let getStaticPaths: Next.GetStaticPaths.t<params> = async () => {
  open Next.GetStaticPaths

  let paths = ["js", "belt", "dom"]->Belt.Array.map(name => {
    params: {
      slug: [name, "id"],
    },
  })

  {paths: [], fallback: false}
}
