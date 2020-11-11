type package = {
  name: string,
  version: string,
  keywords: array<string>,
  description: string,
  repositoryHref: Js.Null.t<string>,
  npmHref: string,
}

module SearchBox = {
  let applySearch = (packages: array<package>, pattern: string): array<Fuser.result<package>> => {
    let fuseOpts = Fuser.Options.t(
      ~id="meta.uid",
      ~shouldSort=true,
      ~matchAllTokens=true,
      ~includeScore=true,
      ~threshold=0.4,
      ~location=0,
      ~distance=100,
      ~maxPatternLength=32,
      ~minMatchCharLength=1,
      ~keys=["name", "description"],
      (),
    )

    let fuser = Fuser.make(packages, fuseOpts)

    fuser->Fuser.search(pattern)
  }

  @react.component
  let make = (~onChange) => {
    <div>
      <input onChange={onChange} className="border border-snow-dark bg-snow-light" type_="text" />
    </div>
  }
}

type props = {"packages": array<package>}

type state =
  | All
  | Filtered(string)

let default = (props: props) => {
  open Markdown

  let (state, setState) = React.useState(_ => All)

  let pkges = props["packages"]

  let packages = switch state {
  | All => pkges
  | Filtered(pattern) =>
    let matches = SearchBox.applySearch(pkges, pattern)

    // TODO: filter by score if necessary
    Belt.Array.map(matches, m => m["item"])
  }

  let onChange = evt => {
    ReactEvent.Form.preventDefault(evt)
    let value = ReactEvent.Form.target(evt)["value"]

    if value === "" {
      setState(_prev => All)
    } else {
      setState(_prev => Filtered(value))
    }
  }

  <div>
    <H1> {React.string("Community Packages")} </H1>
    <SearchBox onChange />
    {Belt.Array.map(packages, pkg => {
      let href = Js.Null.toOption(pkg.repositoryHref)->Belt.Option.getWithDefault(pkg.npmHref)

      <li key={pkg.name} className="mb-4">
        <a className="font-bold" href target="_blank"> {React.string(pkg.name)} </a>
        <p className="pl-6"> {React.string(pkg.description)} </p>
      </li>
    })->React.array}
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
