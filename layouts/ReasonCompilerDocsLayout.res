module Link = Next.Link

// Structure defined by `scripts/extract-tocs.js`
let tocData: Js.Dict.t<{
  "title": string,
  "headers": array<{
    "name": string,
    "href": string,
  }>,
}> = %raw("require('../index_data/reason_compiler_toc.json')")

module NavItem = SidebarLayout.Sidebar.NavItem
module Category = SidebarLayout.Sidebar.Category
module Toc = SidebarLayout.Toc

let interopNavs = [
  {
    open NavItem
    {
      name: "Overview",
      href: "/docs/reason-compiler/latest/interop-overview",
    }
  },
  {
    name: "Better Data Structures Printing (Debug Mode)",
    href: "/docs/reason-compiler/latest/better-data-structures-printing-debug-mode",
  },
  {name: "Miscellaneous", href: "/docs/reason-compiler/latest/interop-misc"},
  {name: "Decorators", href: "/docs/reason-compiler/latest/decorators"},
]

let advancedNavs = [
  {
    open NavItem
    {
      name: "Conditional Compilation",
      href: "/docs/reason-compiler/latest/conditional-compilation",
    }
  },
  {
    name: "Extended Compiler Options",
    href: "/docs/reason-compiler/latest/extended-compiler-options",
  },
  {
    name: "Compiler Architecture & Principles",
    href: "/docs/reason-compiler/latest/compiler-architecture-principles",
  },
  {
    name: "Comparison to Js_of_ocaml",
    href: "/docs/reason-compiler/latest/comparison-to-jsoo",
  },
]

let categories = [
  {
    open Category
    {name: "Interop", items: interopNavs}
  },
  {name: "Advanced", items: advancedNavs},
]

@react.component
let make = (~components=Markdown.default, ~children) => {
  let router = Next.Router.useRouter()
  let route = router.route

  let activeToc: option<Toc.t> = {
    open Belt.Option
    Js.Dict.get(tocData, route)->map(data => {
      let title = data["title"]
      let entries = Belt.Array.map(data["headers"], header => {
        Toc.header: header["name"],
        href: "#" ++ header["href"],
      })
      {Toc.title: title, entries: entries}
    })
  }

  let url = route->Url.parse

  let version = switch url.version {
  | Version(version) => version
  | NoVersion => "latest"
  | Latest => "latest"
  }

  let prefix = list{
    {
      open Url
      {name: "Docs", href: "/docs/" ++ version}
    },
    {
      open Url
      {
        name: "Old Docs",
        href: "/docs/reason-compiler/" ++ (version ++ "/interop-overview"),
      }
    },
  }

  let breadcrumbs = Belt.List.concat(
    prefix,
    DocsLayout.makeBreadcrumbs(~basePath="/docs/manual/" ++ version, route),
  )

  let title = "Old Docs"
  let version = "BS@8.2.0"

  <DocsLayout theme=#Js components categories version title ?activeToc breadcrumbs>
    <Markdown.Warn>
      <div className="font-bold"> {"IMPORTANT!"->React.string} </div>
      {`This section is still
        about ReasonML & BuckleScript.\nIt will be rewritten to ReScript very soon.`->React.string}
    </Markdown.Warn>
    children
  </DocsLayout>
}
