//
// TODO:
// -
// - Whitelist @reason-association
// - filter bs- prefixed packages (!???)
// - put official / non-official processing on the server side?
//

type urlResource = {
  name: string,
  keywords: array<string>,
  description: string,
  urlHref: string,
  official: bool,
}

external unsafeToUrlResource: Js.Json.t => array<urlResource> = "%identity"

type npmPackage = {
  name: string,
  version: string,
  keywords: array<string>,
  description: string,
  repositoryHref: Js.Null.t<string>,
  npmHref: string,
}

module SearchBox = {
  @bs.send external focus: Dom.element => unit = "focus"

  type state =
    | Active
    | Inactive

  @react.component
  let make = (
    ~completionValues: array<string>=[], // set of possible values
    ~value: string,
    ~onClear: unit => unit,
    ~placeholder: string="",
    ~onValueChange: string => unit,
  ) => {
    let (state, setState) = React.useState(_ => Inactive)
    let textInput = React.useRef(Js.Nullable.null)

    let onMouseDownClear = evt => {
      ReactEvent.Mouse.preventDefault(evt)
      onClear()
    }

    let focusInput = () =>
      textInput.current->Js.Nullable.toOption->Belt.Option.forEach(el => el->focus)

    let onAreaFocus = evt => {
      let el = ReactEvent.Focus.target(evt)
      let isDiv = Js.Null_undefined.isNullable(el["type"])

      if isDiv && state === Inactive {
        focusInput()
      }
    }

    let onFocus = _ => {
      setState(_ => Active)
    }

    let onBlur = _ => {
      setState(_ => Inactive)
    }

    let onKeyDown = evt => {
      let key = ReactEvent.Keyboard.key(evt)
      let ctrlKey = ReactEvent.Keyboard.ctrlKey(evt)

      let full = (ctrlKey ? "CTRL+" : "") ++ key

      switch full {
      | "Escape" => onClear()
      | "Tab" =>
        if Js.Array.length(completionValues) === 1 {
          let targetValue = Belt.Array.getExn(completionValues, 0)

          if targetValue !== value {
            ReactEvent.Keyboard.preventDefault(evt)
            onValueChange(targetValue)
          } else {
            ()
          }
        }
      | _ => ()
      }
    }

    let onChange = evt => {
      ReactEvent.Form.preventDefault(evt)
      let value = ReactEvent.Form.target(evt)["value"]
      onValueChange(value)
    }

    <div
      tabIndex={-1}
      onFocus=onAreaFocus
      onBlur
      className={(
        state === Active ? "" : ""
      ) ++ " flex bg-white items-center rounded-lg py-4 px-5"}>
      <Icon.MagnifierGlass
        className={(state === Active ? "text-gray-100" : "text-gray-60") ++ " w-5 h-5"}
      />
      <input
        value
        ref={ReactDOM.Ref.domRef(textInput)}
        onFocus
        onKeyDown
        onChange={onChange}
        placeholder
        className="text-16 font-medium text-gray-95 outline-none ml-4 w-full"
        type_="text"
      />
      <button onFocus className={value === "" ? "hidden" : "block"} onMouseDown=onMouseDownClear>
        <Icon.Close className="w-4 h-4 text-gray-60 hover:text-gray-100" />
      </button>
    </div>
  }
}
module Resource = {
  type t = Npm(npmPackage) | Url(urlResource)

  let getId = (res: t) => {
    switch res {
    | Npm({name})
    | Url({name}) => name
    }
  }

  let shouldFilter = (res: t) => {
    switch res {
    | Npm(pkg) =>
      if pkg.name->Js.String2.startsWith("@elm-react") {
        true
      } else {
        false
      }
    | Url(_) => false
    }
  }

  let filterKeywords = (keywords: array<string>): array<string> => {
    Belt.Array.keep(keywords, kw => {
      switch Js.String2.toLowerCase(kw) {
      | "reasonml"
      | "reason"
      | "ocaml"
      | "bucklescript"
      | "rescript" => false
      | _ => true
      }
    })
  }

  let isOfficial = (res: t) => {
    switch res {
    | Npm(pkg) => pkg.name === "bs-platform" || pkg.name->Js.String2.startsWith("@rescript/")
    | Url(urlRes) => urlRes.official
    }
  }

  let applyNpmSearch = (packages: array<npmPackage>, pattern: string): array<
    Fuse.match<npmPackage>,
  > => {
    let fuseOpts = Fuse.Options.t(
      ~shouldSort=true,
      ~includeScore=true,
      ~threshold=0.2,
      ~location=0,
      ~distance=30,
      ~minMatchCharLength=1,
      ~keys=["meta.uid", "name", "keywords"],
      (),
    )

    let fuser = Fuse.make(packages, fuseOpts)

    fuser->Fuse.search(pattern)
  }

  let applyUrlResourceSearch = (urls: array<urlResource>, pattern: string): array<
    Fuse.match<urlResource>,
  > => {
    let fuseOpts = Fuse.Options.t(
      ~shouldSort=true,
      ~includeScore=true,
      ~threshold=0.2,
      ~location=0,
      ~distance=30,
      ~minMatchCharLength=1,
      ~keys=["name", "keywords"],
      (),
    )

    let fuser = Fuse.make(urls, fuseOpts)

    fuser->Fuse.search(pattern)
  }

  let applySearch = (resources: array<t>, pattern: string): array<t> => {
    let (allNpms, allUrls) = Belt.Array.reduce(resources, ([], []), (acc, next) => {
      let (npms, resources) = acc

      switch next {
      | Npm(pkg) => Js.Array2.push(npms, pkg)->ignore
      | Url(res) => Js.Array2.push(resources, res)->ignore
      }
      (npms, resources)
    })

    let filteredNpm = applyNpmSearch(allNpms, pattern)->Belt.Array.map(m => Npm(m["item"]))
    let filteredUrls = applyUrlResourceSearch(allUrls, pattern)->Belt.Array.map(m => Url(m["item"]))

    Belt.Array.concat(filteredNpm, filteredUrls)
  }
}

module Card = {
  @react.component
  let make = (~value: Resource.t, ~onKeywordSelect: option<string => unit>=?) => {
    let icon = switch value {
    | Npm(_) => <Icon.Npm className="w-8 opacity-50" />
    | Url(_) => <span> <Icon.Hyperlink className="w-8 opacity-50" /> </span>
    }
    let linkBox = switch value {
    | Npm(pkg) =>
      let repositoryHref = Js.Null.toOption(pkg.repositoryHref)
      let repoEl = switch repositoryHref {
      | Some(href) =>
        let name = if Js.String2.startsWith(href, "https://github.com") {
          "Github"
        } else if Js.String2.startsWith(href, "https://gitlab.com") {
          "Gitlab"
        } else {
          "Repository"
        }
        <>
          <span> {React.string("|")} </span>
          <a href rel="noopener noreferrer" className="hover:text-fire" target="_blank">
            {React.string(name)}
          </a>
        </>
      | None => React.null
      }
      <div className="text-12 text-gray-40 space-x-2 mt-1">
        <a className="hover:text-fire" href={pkg.npmHref} target="_blank">
          {React.string("NPM")}
        </a>
        {repoEl}
      </div>
    | Url(_) => React.null
    }

    let titleHref = switch value {
    | Npm(pkg) => pkg.repositoryHref->Js.Null.toOption->Belt.Option.getWithDefault(pkg.npmHref)
    | Url(res) => res.urlHref
    }

    let (title, description, keywords) = switch value {
    | Npm({name, description, keywords})
    | Url({name, description, keywords}) => (name, description, keywords)
    }

    let versionEl = switch value {
    | Resource.Npm({version}) =>
      <span className="text-12 text-gray-40 font-medium"> {React.string(version)} </span>
    | _ => React.null
    }

    <div className="bg-white py-6 shadow-xs rounded-lg p-4">
      <div className="flex justify-between">
        <div>
          <div className="space-x-2">
            <a
              className="font-bold hover:text-fire font-semibold text-18"
              href=titleHref
              target="_blank">
              <span> {React.string(title)} </span>
            </a>
            versionEl
          </div>
          {linkBox}
        </div>
        <div className="text-gray-90"> {icon} </div>
      </div>
      <div className="mt-4 text-14"> {React.string(description)} </div>
      <div className="space-x-2 mt-4">
        {Belt.Array.map(keywords, keyword => {
          let onMouseDown = Belt.Option.map(onKeywordSelect, cb => {
            evt => {
              ReactEvent.Mouse.preventDefault(evt)
              cb(keyword)
            }
          })
          <button
            ?onMouseDown
            className="hover:pointer border border-fire-40 hover:border-gray-100 px-2 rounded text-gray-60-tr hover:text-gray-95 bg-fire-40 text-12"
            key={keyword}>
            {React.string(keyword)}
          </button>
        })->React.array}
      </div>
    </div>
  }
}

module Category = {
  type t =
    | Official
    | Community

  let toString = t =>
    switch t {
    | Official => "Official Resources"
    | Community => "Community Resources"
    }
}

module Filter = {
  type t = {
    searchterm: string,
    includeOfficial: bool,
    includeCommunity: bool,
    includeNpm: bool,
    includeUrlResource: bool,
  }
}

module InfoSidebar = {
  module Toggle = {
    @react.component
    let make = (~enabled, ~toggle, ~children) => {
      let className = "block px-4 rounded-lg " ++ (enabled ? "bg-fire text-white" : " bg-gray-10")

      let onMouseDown = evt => {
        ReactEvent.Mouse.preventDefault(evt)
        toggle()
      }

      <button onMouseDown className> children </button>
    }
  }

  @react.component
  let make = (~setFilter: (Filter.t => Filter.t) => unit, ~filter: Filter.t) => {
    let h2 = "group mb-3 text-14 uppercase  leading-1 font-sans font-medium text-gray-95"
    let link = "hover:underline"

    <aside className=" border-l-2 p-4 py-12 border-fire-30 space-y-16">
      <div>
        <h2 className=h2> {React.string("Filter for")} </h2>
        <div className="space-y-2">
          <Toggle
            enabled={filter.includeOfficial}
            toggle={() => {
              setFilter(prev => {
                {...prev, Filter.includeOfficial: !filter.includeOfficial}
              })
            }}>
            {React.string("Official")}
          </Toggle>
          <Toggle
            enabled={filter.includeCommunity}
            toggle={() => {
              setFilter(prev => {
                {...prev, Filter.includeCommunity: !filter.includeCommunity}
              })
            }}>
            {React.string("Community")}
          </Toggle>
          <Toggle
            enabled={filter.includeNpm}
            toggle={() => {
              setFilter(prev => {
                {...prev, Filter.includeNpm: !filter.includeNpm}
              })
            }}>
            {React.string("NPM package")}
          </Toggle>
          <Toggle
            enabled={filter.includeUrlResource}
            toggle={() => {
              setFilter(prev => {
                {...prev, Filter.includeUrlResource: !filter.includeUrlResource}
              })
            }}>
            {React.string("URL resources")}
          </Toggle>
        </div>
      </div>
      <div>
        <h2 className=h2> {React.string("Guidelines")} </h2>
        <ul className="space-y-4">
          <Next.Link href="/docs/guidelines/publishing-packages">
            <a className=link> {React.string("Publishing ReScript npm packages")} </a>
          </Next.Link>
          /* <li> */
          /* <Next.Link href="/docs/guidelines/writing-bindings"> */
          /* <a className=link> {React.string("Writing Bindings & Libraries")} </a> */
          /* </Next.Link> */
          /* </li> */
        </ul>
      </div>
    </aside>
  }
}

type props = {"packages": array<npmPackage>, "urlResources": array<urlResource>}

type state =
  | All
  | Filtered(string) // search term

let scrollToTop: unit => unit = %raw(`function() {
  window.scroll({
    top: 0, 
    left: 0, 
    behavior: 'smooth'
  });
}
`)

let default = (props: props) => {
  let (state, setState) = React.useState(_ => All)

  let (selectedCategory, setSelectedCategory) = React.useState(_ => {
    Category.Official
  })

  let (filter, setFilter) = React.useState(_ => {
    Filter.searchterm: "",
    includeOfficial: true,
    includeCommunity: true,
    includeNpm: true,
    includeUrlResource: true,
  })

  let allResources = {
    let npms = props["packages"]->Belt.Array.map(pkg => Resource.Npm(pkg))
    let urls = props["urlResources"]->Belt.Array.map(res => Resource.Url(res))

    Belt.Array.concat(npms, urls)
  }

  let resources = switch state {
  | All => allResources
  | Filtered(pattern) => Resource.applySearch(allResources, pattern)
  }

  let onValueChange = value => {
    setState(_ => {
      switch value {
      | "" => All
      | value => Filtered(value)
      }
    })
  }

  let searchValue = switch state {
  | All => ""
  | Filtered(value) => value
  }

  let onClear = () => {
    setState(_ => All)
  }

  let (officialResources, communityResources) = Belt.Array.reduce(resources, ([], []), (
    acc,
    next,
  ) => {
    let (official, community) = acc
    let isResourceIncluded = switch next {
    | Npm(_) => filter.includeNpm
    | Url(_) => filter.includeUrlResource
    }
    if !isResourceIncluded {
      ()
    } else if filter.includeOfficial && Resource.isOfficial(next) {
      Js.Array2.push(official, next)->ignore
    } else if filter.includeCommunity && !Resource.shouldFilter(next) {
      Js.Array2.push(community, next)->ignore
    }
    (official, community)
  })

  let onKeywordSelect = keyword => {
    scrollToTop()
    setState(_ => {
      Filtered(keyword)
    })
  }

  let officialCategory = switch officialResources {
  | [] => React.null
  | resources =>
    <div className="space-y-4">
      {Belt.Array.map(resources, res => {
        <Card key={Resource.getId(res)} onKeywordSelect value={res} />
      })->React.array}
    </div>
  }

  let communityCategory = switch communityResources {
  | [] => React.null
  | resources =>
    <div className="space-y-4">
      {Belt.Array.map(resources, res => {
        <Card onKeywordSelect key={Resource.getId(res)} value={res} />
      })->React.array}
    </div>
  }

  let searchOverview = switch state {
  | Filtered(search) =>
    let (numOfPackages, categoryName) = switch selectedCategory {
    | Official => (officialResources->Js.Array2.length, `"${Category.toString(selectedCategory)}"`)
    | Community => (
        communityResources->Js.Array2.length,
        `"${Category.toString(selectedCategory)}"`,
      )
    }

    let packagePluralSingular = if numOfPackages > 1 || numOfPackages === 0 {
      "packages"
    } else {
      "package"
    }
    <div className="font-medium">
      <div className="text-42 text-gray-95"> {React.string(search)} </div>
      <div className="text-gray-60-tr">
        <span className="text-gray-95"> {React.int(numOfPackages)} </span>
        {React.string(` ${packagePluralSingular} found in `)}
        <span className="text-gray-95"> {categoryName->React.string} </span>
      </div>
    </div>
  | All => React.null
  }

  let searchResult = switch selectedCategory {
  | Official => officialCategory
  | Community => communityCategory
  }

  let router = Next.Router.useRouter()

  // On first render, the router query is undefined so we set a flag.
  let firstRenderDone = React.useRef(false)

  React.useEffect0(() => {
    firstRenderDone.current = true

    None
  })

  // On second render, this hook runs one more time to actually trigger the search.
  React.useEffect1(() => {
    router.query->Js.Dict.get("search")->Belt.Option.forEach(onValueChange)

    None
  }, [firstRenderDone.current])

  let updateQuery = value =>
    router->Next.Router.replaceObj({
      pathname: router.pathname,
      query: value === "" ? Js.Dict.empty() : Js.Dict.fromArray([("search", value)]),
    })

  // When the search term changes, update the router query accordingly.
  React.useEffect1(() => {
    switch state {
    | All => updateQuery("")
    | Filtered(value) => updateQuery(value)
    }

    None
  }, [state])

  let overlayState = React.useState(() => false)
  <>
    <Meta
      title="Package Index | ReScript Documentation"
      description="Official and unofficial resources, libraries and bindings for ReScript"
    />
    <div className="mt-16">
      <div className="text-gray-80 text-lg">
        <Navigation overlayState />
        <div className="flex overflow-hidden">
          <div className="flex justify-between min-w-320 lg:align-center w-full">
            <Mdx.Provider components=Markdown.default>
              <main className="w-full">
                <div className="relative w-full bg-gray-100 py-16">
                  <div className="px-4 relative z-10 max-w-1280 flex justify-center">
                    // Centered Searchbox header thing
                    <div style={ReactDOM.Style.make(~maxWidth="47.5625rem", ())} className="w-full">
                      <h1
                        className="text-white mb-10 md:mb-2 text-42 leading-1 font-medium antialiased">
                        {React.string("Libraries and Bindings")}
                      </h1>
                      <SearchBox
                        placeholder="Enter a search term, keyword, etc"
                        onValueChange
                        onClear
                        value={searchValue}
                      />
                    </div>
                  </div>
                  <img
                    className="h-48 absolute bottom-0 right-0"
                    src="/static/illu_index_rescript@2x.png"
                  />
                </div>
                // Actual content
                <div className="bg-gray-5 px-4 lg:px-8 pb-48">
                  <div className="pt-6"> searchOverview </div>
                  // Box for the results
                  <div className="mt-12 space-y-8"> searchResult </div>
                  <div className="hidden lg:block h-full "> <InfoSidebar filter setFilter /> </div>
                </div>
              </main>
            </Mdx.Provider>
          </div>
        </div>
        <Footer />
      </div>
    </div>
  </>
}

type npmData = {
  "objects": array<{
    "package": {
      "name": string,
      "keywords": array<string>,
      "description": option<string>,
      "version": string,
      "links": {"npm": string, "repository": option<string>},
    },
  }>,
}

module Response = {
  type t
  @send external json: t => Js.Promise.t<npmData> = "json"
}

@val external fetchNpmPackages: string => Js.Promise.t<Response.t> = "fetch"

let getStaticProps: Next.GetStaticProps.revalidate<props, unit> = _ctx => {
  fetchNpmPackages("https://registry.npmjs.org/-/v1/search?text=keywords:rescript&size=250")
  ->Js.Promise.then_(response => {
    Response.json(response)
  }, _)
  ->Js.Promise.then_(data => {
    let pkges = Belt.Array.map(data["objects"], item => {
      let pkg = item["package"]
      {
        name: pkg["name"],
        version: pkg["version"],
        keywords: Resource.filterKeywords(pkg["keywords"]),
        description: Belt.Option.getWithDefault(pkg["description"], ""),
        repositoryHref: Js.Null.fromOption(pkg["links"]["repository"]),
        npmHref: pkg["links"]["npm"],
      }
    })

    let index_data_dir = Node.Path.join2(Node.Process.cwd(), "./data")
    let urlResources =
      Node.Path.join2(index_data_dir, "packages_url_resources.json")
      ->Node.Fs.readFileSync(#utf8)
      ->Js.Json.parseExn
      ->unsafeToUrlResource
    let props: props = {
      "packages": pkges,
      "urlResources": urlResources,
    }
    let ret = {
      "props": props,
      "revalidate": 43200,
    }
    Js.Promise.resolve(ret)
  }, _)
}
