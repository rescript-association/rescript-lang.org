type package = {
  name: string,
  version: string,
  keywords: array<string>,
  description: string,
  repositoryHref: Js.Null.t<string>,
  npmHref: string,
}

let applySearch = (packages: array<package>, pattern: string): array<Fuse.match<package>> => {
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
        state === Active ? "border-fire" : "border-fire-40"
      ) ++ " flex items-center border rounded-lg py-4 px-5"}>
      <Icon.MagnifierGlass
        className={(state === Active ? "text-fire" : "text-fire-80") ++ " w-4 h-4"}
      />
      <input
        value
        ref={ReactDOM.Ref.domRef(textInput)}
        onFocus
        onKeyDown
        onChange={onChange}
        placeholder
        className="text-16 outline-none ml-4 w-full"
        type_="text"
      />
      <button onFocus className={value === "" ? "hidden" : "block"} onMouseDown=onMouseDownClear>
        <Icon.Close className="w-4 h-4 text-fire" />
      </button>
    </div>
  }
}

module NpmCard = {
  @react.component
  let make = (
    ~keywords: array<string>=[],
    ~name: string,
    ~description: string,
    ~onKeywordSelect: option<string => unit>=?,
    ~repositoryHref: option<string>=?,
    ~npmHref,
  ) => {
    let repoEl = switch repositoryHref {
    | Some(href) =>
      let name = if Js.String2.startsWith(href, "https://github.com") {
        "Github"
      } else if Js.String2.startsWith(href, "https://gitlab.com") {
        "Gitlab"
      } else {
        "Repository"
      }
      <a href rel="noopener noreferrer" target="_blank"> {React.string(name)} </a>
    | None => React.null
    }

    let titleHref = Belt.Option.getWithDefault(repositoryHref, npmHref)

    <div className="bg-gray-10 py-6 rounded-lg p-4">
      <a className="font-bold" href=titleHref target="_blank"> {React.string(name)} </a>
      <div className="space-x-2">
        <a href=npmHref target="_blank"> {React.string("NPM")} </a> {repoEl}
      </div>
      <div className="mt-4 text-16"> {React.string(description)} </div>
      <div className="space-x-2 mt-4"> {Belt.Array.map(keywords, keyword => {
          let onMouseDown = Belt.Option.map(onKeywordSelect, cb => {
            evt => {
              ReactEvent.Mouse.preventDefault(evt)
              cb(keyword)
            }
          })
          <button
            ?onMouseDown className="hover:pointer px-2 rounded-lg bg-sky-15 text-14" key={keyword}>
            {React.string(keyword)}
          </button>
        })->React.array} </div>
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

  @react.component
  let make = (~title: string, ~children) => {
    <div>
      <h3 className="font-sans font-medium text-gray-100 tracking-wide text-14 uppercase mb-2">
        {React.string(title)}
      </h3>
      <div> children </div>
    </div>
  }
}

module PackageFilter = {
  let shouldPackageFilter = (pkg: package) => {
    if pkg.name->Js.String2.startsWith("@elm-react") {
      true
    } else {
      false
    }
  }

  let isOfficialPackage = (pkg: package) => {
    pkg.name === "bs-platform" || pkg.name->Js.String2.startsWith("@rescript/")
  }
}

type props = {"packages": array<package>}

type state =
  | All
  | Filtered(string) // search term

let default = (props: props) => {
  open Markdown

  let (state, setState) = React.useState(_ => All)

  let allPackages = props["packages"]

  let packages = switch state {
  | All => allPackages
  | Filtered(pattern) =>
    let matches = applySearch(allPackages, pattern)

    // TODO: filter by score if necessary
    Belt.Array.map(matches, m => m["item"])
  }

  let onValueChange = value => {
    setState(_ => {
      switch value {
      | "" => All
      | value => Filtered(value)
      }
    })
    ()
  }

  let searchValue = switch state {
  | All => ""
  | Filtered(value) => value
  }

  let onClear = () => {
    setState(_ => All)
  }

  let (officialPackages, communityPackages) = Belt.Array.reduce(packages, ([], []), (acc, next) => {
    let (official, community) = acc
    if PackageFilter.isOfficialPackage(next) {
      Js.Array2.push(official, next)->ignore
    } else if (
      // Community package filter
      !PackageFilter.shouldPackageFilter(next)
    ) {
      Js.Array2.push(community, next)->ignore
    }
    (official, community)
  })

  let onKeywordSelect = keyword => {
    setState(_ => {
      Filtered(keyword)
    })
  }

  let officialCategory = switch officialPackages {
  | [] => React.null
  | pkges =>
    <Category title={Category.toString(Official)}>
      <div className="space-y-4"> {Belt.Array.map(pkges, pkg => {
          let repositoryHref = Js.Null.toOption(pkg.repositoryHref)
          let {description, npmHref, name, keywords} = pkg

          <NpmCard onKeywordSelect key={name} name ?repositoryHref keywords description npmHref />
        })->React.array} </div>
    </Category>
  }

  let communityCategory = switch communityPackages {
  | [] => React.null
  | pkges =>
    <Category title={Category.toString(Community)}>
      <div className="space-y-4"> {Belt.Array.map(pkges, pkg => {
          let repositoryHref = Js.Null.toOption(pkg.repositoryHref)
          let {description, npmHref, name, keywords} = pkg

          <NpmCard onKeywordSelect key={name} name ?repositoryHref keywords description npmHref />
        })->React.array} </div>
    </Category>
  }

  <div>
    <H1> {React.string("Community Packages")} </H1>
    <SearchBox
      placeholder="Enter a search term, name, keyword, etc"
      onValueChange
      onClear
      value={searchValue}
    />
    <div className="mt-12 space-y-8"> officialCategory communityCategory </div>
  </div>
}

type npmData = {
  "objects": array<{
    "package": {
      "name": string,
      "keywords": array<string>,
      "description": string,
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
  fetchNpmPackages("https://registry.npmjs.org/-/v1/search?text=keywords:rescript")
  ->Js.Promise.then_(response => {
    Response.json(response)
  }, _)
  ->Js.Promise.then_(data => {
    let pkges = Belt.Array.map(data["objects"], item => {
      let pkg = item["package"]
      {
        name: pkg["name"],
        version: pkg["version"],
        keywords: pkg["keywords"],
        description: pkg["description"],
        repositoryHref: Js.Null.fromOption(pkg["links"]["repository"]),
        npmHref: pkg["links"]["npm"],
      }
    })
    let props: props = {"packages": pkges}
    let ret = {
      "props": props,
      "revalidate": 43200,
    }
    Js.Promise.resolve(ret)
  }, _)
}
