// Structure defined by `scripts/extract-indices.js`
let indexData: Js.Dict.t<{
  "moduleName": string,
  "headers": array<{
    "name": string,
    "href": string,
  }>,
}> = %raw("require('index_data/latest_belt_api_index.json')")

module Category = SidebarLayout.Sidebar.Category
module NavItem = SidebarLayout.Sidebar.NavItem

let overviewNavs = [
  {
    open NavItem
    {name: "Introduction", href: "/docs/manual/latest/api/belt"}
  },
]

let setNavs = [
  {
    open NavItem
    {name: "HashSet", href: "/docs/manual/latest/api/belt/hash-set"}
  },
  {name: "HashSet.Int", href: "/docs/manual/latest/api/belt/hash-set-int"},
  {name: "HashSet.String", href: "/docs/manual/latest/api/belt/hash-set-string"},
  {name: "Set", href: "/docs/manual/latest/api/belt/set"},
  {name: "Set.Dict", href: "/docs/manual/latest/api/belt/set-dict"},
  {name: "Set.Int", href: "/docs/manual/latest/api/belt/set-int"},
  {name: "Set.String", href: "/docs/manual/latest/api/belt/set-string"},
]

let mapNavs = [
  {
    open NavItem
    {name: "HashMap", href: "/docs/manual/latest/api/belt/hash-map"}
  },
  {name: "HashMap.Int", href: "/docs/manual/latest/api/belt/hash-map-int"},
  {name: "HashMap.String", href: "/docs/manual/latest/api/belt/hash-map-string"},
  {name: "Map", href: "/docs/manual/latest/api/belt/map"},
  {name: "Map.Dict", href: "/docs/manual/latest/api/belt/map-dict"},
  {name: "Map.Int", href: "/docs/manual/latest/api/belt/map-int"},
  {name: "Map.String", href: "/docs/manual/latest/api/belt/map-string"},
]

let mutableCollectionsNavs = [
  {
    open NavItem
    {name: "MutableMap", href: "/docs/manual/latest/api/belt/mutable-map"}
  },
  {name: "MutableMap.Int", href: "/docs/manual/latest/api/belt/mutable-map-int"},
  {name: "MutableMap.String", href: "/docs/manual/latest/api/belt/mutable-map-string"},
  {name: "MutableQueue", href: "/docs/manual/latest/api/belt/mutable-queue"},
  {name: "MutableSet", href: "/docs/manual/latest/api/belt/mutable-set"},
  {name: "MutableSet.Int", href: "/docs/manual/latest/api/belt/mutable-set-int"},
  {name: "MutableSet.String", href: "/docs/manual/latest/api/belt/mutable-set-string"},
  {name: "MutableStack", href: "/docs/manual/latest/api/belt/mutable-stack"},
]

let basicNavs = [
  {
    open NavItem
    {name: "Array", href: "/docs/manual/latest/api/belt/array"}
  },
  {name: "List", href: "/docs/manual/latest/api/belt/list"},
  {name: "Float", href: "/docs/manual/latest/api/belt/float"},
  {name: "Int", href: "/docs/manual/latest/api/belt/int"},
  {name: "Range", href: "/docs/manual/latest/api/belt/range"},
  {name: "Id", href: "/docs/manual/latest/api/belt/id"},
  {name: "Option", href: "/docs/manual/latest/api/belt/option"},
  {name: "Result", href: "/docs/manual/latest/api/belt/result"},
]

let sortNavs = [
  {
    open NavItem
    {name: "SortArray", href: "/docs/manual/latest/api/belt/sort-array"}
  },
  {name: "SortArray.Int", href: "/docs/manual/latest/api/belt/sort-array-int"},
  {name: "SortArray.String", href: "/docs/manual/latest/api/belt/sort-array-string"},
]

let utilityNavs = [
  {
    open NavItem
    {name: "Debug", href: "/docs/manual/latest/api/belt/debug"}
  },
]

let categories = [
  {
    open Category
    {name: "Overview", items: overviewNavs}
  },
  {name: "Basics", items: basicNavs},
  {name: "Set", items: setNavs},
  {name: "Map", items: mapNavs},
  {name: "Mutable Collections", items: mutableCollectionsNavs},
  {name: "Sort Collections", items: sortNavs},
  {name: "Utilities", items: utilityNavs},
]

module Docs = {
  @react.component
  let make = (~components=ApiMarkdown.default, ~children) => {
    let router = Next.Router.useRouter()
    let route = router.route

    // Gather data for the CollapsibleSection
    let headers = {
      open Belt.Option
      Js.Dict.get(indexData, route)
      ->map(data =>
        data["headers"]->Belt.Array.map(header => (header["name"], "#" ++ header["href"]))
      )
      ->getWithDefault([])
    }

    let moduleName = {
      open Belt.Option
      Js.Dict.get(indexData, route)->map(data => data["moduleName"])->getWithDefault("?")
    }

    let url = route->Url.parse

    let version = switch url.version {
    | Version(version) => version
    | NoVersion => "latest"
    | Latest => "latest"
    }

    let prefix = {
      open Url
      {name: "API", href: "/docs/manual/" ++ (version ++ "/api")}
    }

    let breadcrumbs = ApiLayout.makeBreadcrumbs(~prefix, route)

    let activeToc = {
      open SidebarLayout.Toc
      {
        title: moduleName,
        entries: Belt.Array.map(headers, ((name, href)) => {header: name, href: href}),
      }
    }

    let title = "Belt Stdlib"
    let version = "latest"

    <ApiLayout components title version activeToc categories breadcrumbs> children </ApiLayout>
  }
}

module Prose = {
  @react.component
  let make = (~children) => <Docs components=ApiMarkdown.default> children </Docs>
}
