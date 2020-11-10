module Link = Next.Link

// This is used for the version dropdown in the manual layouts
let allManualVersions = ["latest", "v8.0.0"]

// Used for replacing "latest" with "vX.X.X" in the version dropdown
let latestVersionLabel = "v8.2.0"

// Structure defined by `scripts/extract-tocs.js`
let tocData: Js.Dict.t<{
  "title": string,
  "headers": array<{
    "name": string,
    "href": string,
  }>,
}> = %raw("require('../index_data/manual_toc.json')")

module NavItem = SidebarLayout.Sidebar.NavItem
module Category = SidebarLayout.Sidebar.Category
module Toc = SidebarLayout.Toc

let overviewNavs = [
  {
    open NavItem
    {name: "Introduction", href: "/docs/manual/latest/introduction"}
  },
  {
    name: "Migrate from BuckleScript/Reason",
    href: "/docs/manual/latest/migrate-from-bucklescript-reason",
  },
  {name: "Installation", href: "/docs/manual/latest/installation"},
  {name: "Try", href: "/docs/manual/latest/try"},
  {name: "Editor Plugins", href: "/docs/manual/latest/editor-plugins"},
]

let basicNavs = [
  {
    open NavItem
    {name: "Overview", href: "/docs/manual/latest/overview"}
  },
  {name: "Let Binding", href: "/docs/manual/latest/let-binding"},
  {name: "Type", href: "/docs/manual/latest/type"},
  {name: "Primitive Types", href: "/docs/manual/latest/primitive-types"},
  {name: "Tuple", href: "/docs/manual/latest/tuple"},
  {name: "Record", href: "/docs/manual/latest/record"},
  {name: "Object", href: "/docs/manual/latest/object"},
  {name: "Variant", href: "/docs/manual/latest/variant"},
  {
    name: "Null, Undefined & Option",
    href: "/docs/manual/latest/null-undefined-option",
  },
  {name: "Array & List", href: "/docs/manual/latest/array-and-list"},
  {name: "Function", href: "/docs/manual/latest/function"},
  {name: "Control Flow", href: "/docs/manual/latest/control-flow"},
  {name: "Pipe", href: "/docs/manual/latest/pipe"},
  {
    name: "Pattern Matching/Destructuring",
    href: "/docs/manual/latest/pattern-matching-destructuring",
  },
  {name: "Mutation", href: "/docs/manual/latest/mutation"},
  {name: "JSX", href: "/docs/manual/latest/jsx"},
  {name: "Exception", href: "/docs/manual/latest/exception"},
  {name: "Lazy Value", href: "/docs/manual/latest/lazy-values"},
  {name: "Async & Promise", href: "/docs/manual/latest/promise"},
  {name: "Module", href: "/docs/manual/latest/module"},
  {name: "Import & Export", href: "/docs/manual/latest/import-export"},
  {name: "Attribute (Decorator)", href: "/docs/manual/latest/attribute"},
  {name: "Unboxed", href: "/docs/manual/latest/unboxed"},
  {name: "Reserved Keywords", href: "/docs/manual/latest/reserved-keywords"},
]

let buildsystemNavs = [
  {
    open NavItem
    {name: "Overview", href: "/docs/manual/latest/build-overview"}
  },
  {name: "Configuration", href: "/docs/manual/latest/build-configuration"},
  {name: "Configuration Schema", href: "/docs/manual/latest/build-configuration-schema"},
  {
    name: "Interop with JS Build System",
    href: "/docs/manual/latest/interop-with-js-build-systems",
  },
  {name: "Performance", href: "/docs/manual/latest/build-performance"},
]

let jsInteropNavs = [
  {
    open NavItem
    {
      name: "Embed Raw JavaScript",
      href: "/docs/manual/latest/embed-raw-javascript",
    }
  },
  {name: "Shared Data Types", href: "/docs/manual/latest/shared-data-types"},
  {name: "External (Bind to Any JS Library)", href: "/docs/manual/latest/external"},
  {name: "Bind to JS Object", href: "/docs/manual/latest/bind-to-js-object"},
  {
    name: "Bind to JS Function",
    href: "/docs/manual/latest/bind-to-js-function",
  },
  {
    name: "Import from/Export to JS",
    href: "/docs/manual/latest/import-from-export-to-js",
  },
  {
    name: "Bind to Global JS Values",
    href: "/docs/manual/latest/bind-to-global-js-values",
  },
  {name: "JSON", href: "/docs/manual/latest/json"},
  {name: "Inlining Constants", href: "/docs/manual/latest/inlining-constants"},
  {
    name: "Use Illegal Identifier Names",
    href: "/docs/manual/latest/use-illegal-identifier-names",
  },
  {
    name: "Browser Support & Polyfills",
    href: "/docs/manual/latest/browser-support-polyfills",
  },
  {
    name: "Interop Cheatsheet",
    href: "/docs/manual/latest/interop-cheatsheet",
  },
]

let guidesNavs = [
  {
    open NavItem
    {
      name: "Converting from JavaScript",
      href: "/docs/manual/latest/converting-from-js",
    }
  },
  {name: "Libraries", href: "/docs/manual/latest/libraries"},
]

let extraNavs = [
  {
    open NavItem
    {
      name: "Newcomer Examples",
      href: "/docs/manual/latest/newcomer-examples",
    }
  },
  {name: "Project Structure", href: "/docs/manual/latest/project-structure"},
  {name: "FAQ", href: "/docs/manual/latest/faq"},
]

let categories = [
  {
    open Category
    {name: "Overview", items: overviewNavs}
  },
  {name: "Language Features", items: basicNavs},
  {name: "JavaScript Interop", items: jsInteropNavs},
  {name: "Build System", items: buildsystemNavs},
  {name: "Guides", items: guidesNavs},
  {name: "Extra", items: extraNavs},
]

module Docs = {
  @react.component
  let make = (~frontmatter: option<Js.Json.t>=?, ~components=Markdown.default, ~children) => {
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
          name: "Language Manual",
          href: "/docs/manual/" ++ (version ++ "/introduction"),
        }
      },
    }

    let breadcrumbs = Belt.List.concat(
      prefix,
      DocsLayout.makeBreadcrumbs(~basePath="/docs/manual/" ++ version, route),
    )

    let title = "Language Manual"
    let version = "latest"

    <DocsLayout
      theme=#Reason
      components
      categories
      version
      title
      metaTitleCategory="ReScript Language Manual"
      availableVersions=allManualVersions
      latestVersionLabel
      ?frontmatter
      ?activeToc
      breadcrumbs>
      children
    </DocsLayout>
  }
}

module Prose = {
  @react.component
  let make = (~frontmatter: option<Js.Json.t>=?, ~children) =>
    <Docs ?frontmatter components=Markdown.default> children </Docs>
}
