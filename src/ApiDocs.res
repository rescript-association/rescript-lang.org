module Docgen = RescriptTools.Docgen

type rec node = {
  name: string,
  path: array<string>,
  children: array<node>,
}

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

module SidebarTree = {
  @react.component
  let make = (~isOpen: bool, ~toggle: unit => unit, ~node: node) => {
    let router = Next.Router.useRouter()

    let moduleRoute =
      Webapi.URL.make("file://" ++ router.asPath).pathname
      ->Js.String2.replace("/docs/manual/latest/api/", "")
      ->Js.String2.split("/")

    let summaryClassName = "truncate py-1 md:h-auto tracking-tight text-gray-60 font-medium text-14 rounded-sm hover:bg-gray-20 hover:-ml-2 hover:py-1 hover:pl-2 "
    let classNameActive = " bg-fire-5 text-red-500 -ml-2 pl-2 font-medium hover:bg-fire-70"

    let rec renderNode = node => {
      let isCurrentRoute =
        Js.Array2.joinWith(moduleRoute, "/") === Js.Array2.joinWith(node.path, "/")

      let classNameActive = isCurrentRoute ? classNameActive : ""

      let hasChildren = node.children->Js.Array2.length > 0
      let href = node.path->Js.Array2.joinWith("/")

      switch hasChildren {
      | true =>
        let open_ =
          node.path->Js.Array2.joinWith("/") ===
            moduleRoute
            ->Js.Array2.slice(~start=0, ~end_=Js.Array2.length(moduleRoute) - 1)
            ->Js.Array2.joinWith("/")

        <details key={node.name} open_>
          <summary className={summaryClassName ++ classNameActive}>
            <Next.Link className={"inline-block w-10/12"} href>
              {node.name->React.string}
            </Next.Link>
          </summary>
          {if hasChildren {
            <ul className={"ml-5"}>
              {node.children
              ->Js.Array2.map(renderNode)
              ->React.array}
            </ul>
          } else {
            React.null
          }}
        </details>
      | false =>
        <li className={"list-none mt-1 leading-4"}>
          <summary className={summaryClassName ++ classNameActive}>
            <Next.Link className={"block"} href> {node.name->React.string} </Next.Link>
          </summary>
        </li>
      }
    }

    let url =
      router.asPath
      ->Url.parse
      ->Some

    let preludeSection =
      <div className="flex justify-between text-fire font-medium items-baseline">
        {React.string(node.name ++ " Module")}
        {switch url {
        | Some({version}) =>
          let onChange = evt => {
            open Url
            ReactEvent.Form.preventDefault(evt)
            let version = (evt->ReactEvent.Form.target)["value"]
            let url = Url.parse(router.asPath)

            let targetUrl =
              "/" ++
              (Js.Array2.joinWith(url.base, "/") ++
              ("/" ++ (version ++ ("/" ++ Js.Array2.joinWith(url.pagepath, "/")))))
            router->Next.Router.push(targetUrl)
          }
          let version = switch version {
          | Latest | NoVersion => "latest"
          | Version(version) => version
          }
          <VersionSelect onChange version availableVersions=ApiLayout.allApiVersions />
        | None => React.null
        }}
      </div>

    <div
      className={(
        isOpen ? "fixed w-full left-0 h-full z-20 min-w-320" : "hidden "
      ) ++ " md:block md:w-48 md:-ml-4 lg:w-1/5 md:h-auto md:relative overflow-y-visible bg-white"}>
      <aside
        id="sidebar-content"
        className="relative top-0 px-4 w-full block md:top-16 md:pt-16 md:sticky border-r border-gray-20 overflow-y-auto pb-24 h-[calc(100vh-4.5rem)]">
        <div className="flex justify-between">
          <div className="w-3/4 md:w-full"> React.null </div>
          <button
            onClick={evt => {
              ReactEvent.Mouse.preventDefault(evt)
              toggle()
            }}
            className="md:hidden h-16">
            <Icon.Close />
          </button>
        </div>
        preludeSection
        <div className="my-10">
          <div className="hl-overline block text-gray-80 mt-5 mb-2">
            {"Overview"->React.string}
          </div>
          <Next.Link
            className={"block " ++
            summaryClassName ++ (moduleRoute->Js.Array2.length == 1 ? classNameActive : "")}
            href={node.path->Js.Array2.joinWith("/")}>
            {node.name->React.string}
          </Next.Link>
        </div>
        <div className="hl-overline text-gray-80 mt-5 mb-2"> {"submodules"->React.string} </div>
        {node.children
        ->Js.Array2.sortInPlaceWith((v1, v2) => v1.name > v2.name ? 1 : -1)
        ->Js.Array2.map(renderNode)
        ->React.array}
      </aside>
    </div>
  }
}

type module_ = {
  id: string,
  docstrings: array<string>,
  deprecated: Js.Null.t<string>,
  name: string,
  items: array<item>,
}

type api = {
  module_: module_,
  toctree: node,
}

type params = {slug: array<string>}
type props = result<api, string>

module MarkdownStylize = {
  external asMarkdownH2: 'a => Markdown.H2.props<string, React.element> => React.element =
    "%identity"
  @react.component
  let make = (~content, ~rehypePlugins: option<array<MdxRemote.mdxPlugin>>=?) => {
    let components = {
      ...MarkdownComponents.default,
      h2: MarkdownComponents.default.h3->asMarkdownH2,
    }
    <ReactMarkdown components={components} ?rehypePlugins> content </ReactMarkdown>
  }
}

module DeprecatedMessage = {
  @react.component
  let make = (~deprecated) => {
    switch deprecated->Js.Null.toOption {
    | Some(content) =>
      <Markdown.Warn>
        <h4 className={"hl-4 mb-2"}> {"Deprecated"->React.string} </h4>
        <MarkdownStylize content />
      </Markdown.Warn>
    | None => React.null
    }
  }
}

module DocstringsStylize = {
  external asMdxPlugin: 'a => MdxRemote.mdxPlugin = "%identity"
  @react.component
  let make = (~docstrings, ~slugPrefix) => {
    let options = {"prefix": slugPrefix ++ "-"}->asMdxPlugin
    let rehypePlugins = [[MdxRemote.rehypeSlug, options]->asMdxPlugin]

    let content = switch docstrings->Js.Array2.length > 1 {
    | true => docstrings->Js.Array2.sliceFrom(1)
    | false => docstrings
    }->Js.Array2.joinWith("\n")

    <div className={"mt-3"}>
      <MarkdownStylize content rehypePlugins />
    </div>
  }
}

let default = (props: props) => {
  let (isSidebarOpen, setSidebarOpen) = React.useState(_ => false)
  let toggleSidebar = () => setSidebarOpen(prev => !prev)
  let router = Next.Router.useRouter()

  let title = switch props {
  | Ok({module_: {id}}) => id
  | _ => "API"
  }

  let item = {
    open Markdown
    switch props {
    | Ok({module_: {id, name, docstrings, items}}) =>
      let valuesAndType = items->Js.Array2.map(item => {
        switch item {
        | Value({name, signature, docstrings, deprecated}) =>
          let code = Js.String2.replaceByRe(signature, %re("/\\n/g"), "\n")
          let slugPrefix = "value-" ++ name
          <>
            <H2 id=slugPrefix> {name->React.string} </H2>
            <DeprecatedMessage deprecated />
            <CodeExample code lang="rescript" />
            <DocstringsStylize docstrings slugPrefix />
          </>
        | Type({name, signature, docstrings, deprecated}) =>
          let code = Js.String2.replaceByRe(signature, %re("/\\n/g"), "\n")
          let slugPrefix = "type-" ++ name
          <>
            <H2 id=slugPrefix> {name->React.string} </H2>
            <DeprecatedMessage deprecated />
            <CodeExample code lang="rescript" />
            <DocstringsStylize docstrings slugPrefix />
          </>
        }
      })

      <>
        <H1> {name->React.string} </H1>
        <DocstringsStylize docstrings slugPrefix=id />
        {valuesAndType->React.array}
      </>
    | _ => React.null
    }
  }

  // let valuesAndTypes = switch props {
  // | Ok({module_: {items}}) if Js.Array2.length(items) > 0 =>
  //   let valuesAndTypes = items->Belt.Array.keepMap(item => {
  //     switch item {
  //     | Value({name}) as kind | Type({name}) as kind =>
  //       let icon = switch kind {
  //       | Type(_) => "T"
  //       | Value(_) => "V"
  //       }
  //       let (textColor, bgColor) = switch kind {
  //       | Type(_) => ("text-fire-30", "bg-fire-5")
  //       | Value(_) => ("text-sky-30", "bg-sky-5")
  //       }
  //       let result =
  //         <li className="my-3 flex">
  //           <a
  //             className="flex font-normal text-14 text-gray-40 leading-tight hover:text-gray-80"
  //             href={`#${name}`}>
  //             <div
  //               className={`${bgColor} w-5 h-5 mr-3 flex justify-center items-center rounded-xl`}>
  //               <span style={ReactDOM.Style.make(~fontSize="10px", ())} className=textColor>
  //                 {icon->React.string}
  //               </span>
  //             </div>
  //             {React.string(name)}
  //           </a>
  //         </li>
  //       Some(result)
  //     }
  //   })
  //   valuesAndTypes->Some
  // | _ => None
  // }

  let version = switch Url.parse(router.asPath).version {
  | Latest | NoVersion => "latest"
  | Version(v) => v
  }

  let sidebar = switch props {
  | Ok({toctree}) => <SidebarTree isOpen=isSidebarOpen toggle=toggleSidebar node={toctree} />
  | Error(_) => React.null
  }

  let prefix = {
    {Url.name: "API", href: "/docs/manual/" ++ (version ++ "/api")}
  }

  let breadcrumbs = ApiLayout.makeBreadcrumbs(~prefix, router.asPath)

  let children =
    <>
      item
      // {switch valuesAndTypes {
      // | Some(elemets) =>
      //   <div className="pt-16 relative">
      //     <aside
      //       className="sticky top-18 overflow-auto px-8"
      //       style={ReactDOM.Style.make(~height="calc(100vh - 6rem)", ())}>
      //       <span className="font-normal block text-14 text-gray-40">
      //         {React.string("Types and Values")}
      //       </span>
      //       <ul> {elemets->React.array} </ul>
      //     </aside>
      //   </div>
      // | None => React.null
      // }}
    </>

  <SidebarLayout
    breadcrumbs
    metaTitle={title ++ " | ReScript API"}
    theme=#Reason
    components=ApiMarkdown.default
    sidebarState=(isSidebarOpen, setSidebarOpen)
    sidebar>
    children
  </SidebarLayout>
}

module Data = {
  type t = {
    mainModule: Js.Dict.t<Js.Json.t>,
    tree: Js.Dict.t<Js.Json.t>,
  }

  let dir = Node.Path.resolve("data", "api")

  let getVersion = (~version: string, ~moduleName: string) => {
    open Node

    let pathModule = Path.join([dir, version, `${moduleName}.json`])

    let moduleContent = Fs.readFileSync(pathModule)->Js.Json.parseExn

    let content = switch moduleContent {
    | Object(dict) => dict->Some
    | _ => None
    }

    let toctree = switch Path.join([dir, version, "toc_tree.json"])
    ->Fs.readFileSync
    ->Js.Json.parseExn {
    | Object(dict) => dict->Some
    | _ => None
    }

    switch (content, toctree) {
    | (Some(content), Some(toctree)) => Some({mainModule: content, tree: toctree})
    | _ => None
    }
  }
}

external asTocTree: Js.Json.t => node = "%identity"

let processStaticProps = (~slug: array<string>, ~version: string) => {
  let moduleName = slug->Belt.Array.getExn(0)
  let content = Data.getVersion(~version, ~moduleName)

  let modulePath = slug->Js.Array2.joinWith("/")

  switch content {
  | Some({mainModule, tree}) =>
    switch mainModule->Js.Dict.get(modulePath) {
    | Some(Object(mod)) =>
      let docItem = Docgen.decodeModule(mod)

      switch docItem {
      | Docgen.Module({id, name, docstrings, items, ?deprecated}) =>
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
        let module_ = {
          id,
          name,
          docstrings,
          deprecated: deprecated->Js.Null.fromOption,
          items,
        }

        let toctree = tree->Js.Dict.get(moduleName)

        switch toctree {
        | Some(toctree) => Ok({module_, toctree: toctree->asTocTree})
        | None => Error(`Failed to find toctree to ${modulePath}`)
        }
      | _ => Error(`Failed to find module ${modulePath}`)
      }
    | Some(_) => Error(`Expected an object for ${modulePath}`)
    | None => Error(`Failed to get key for ${modulePath}`)
    }
  | None => Error(`Failed to get API Data for version ${version} and module ${moduleName}`)
  }
}

let getStaticPropsByVersion = async (ctx: {"params": params, "version": string}) => {
  let params = ctx["params"]
  let version = ctx["version"]

  let slug = params.slug

  let result = processStaticProps(~slug, ~version)

  {"props": result}
}

let getStaticPathsByVersion = async (~version: string) => {
  open Node

  let pathDir = Path.join([Data.dir, version])

  let slugs =
    pathDir
    ->Fs.readdirSync
    ->Js.Array2.reduce((acc, file) => {
      switch file == "toc_tree.json" {
      | true => acc
      | false =>
        let paths = switch Path.join2(pathDir, file)
        ->Fs.readFileSync
        ->Js.Json.parseExn {
        | Object(dict) =>
          dict
          ->Js.Dict.keys
          ->Js.Array2.map(modPath => modPath->Js.String2.split("/"))
        | _ => acc
        }
        Js.Array2.concat(acc, paths)
      }
    }, [])

  let paths = slugs->Js.Array2.map(slug =>
    {
      "params": {
        "slug": slug,
      },
    }
  )

  {"paths": paths, "fallback": false}
}
