open Util.ReactStuff
module Link = Next.Link

// Structure defined by `scripts/extract-tocs.js`
let tocData: Js.Dict.t<{
  "title": string,
  "headers": array<{
    "name": string,
    "href": string,
  }>,
}> = %raw("require('../index_data/manual_v800_toc.json')")

module NavItem = SidebarLayout.Sidebar.NavItem
module Category = SidebarLayout.Sidebar.Category
module Toc = SidebarLayout.Toc

let overviewNavs = [
  {
    open NavItem
    {name: "Introduction", href: "/docs/manual/v8.0.0/introduction"}
  },
  {
    name: "Migrate to New Syntax",
    href: "/docs/manual/v8.0.0/migrate-from-bucklescript-reason",
  },
  {name: "Installation", href: "/docs/manual/v8.0.0/installation"},
  {name: "Try", href: "/docs/manual/v8.0.0/try"},
  {name: "Editor Plugins", href: "/docs/manual/v8.0.0/editor-plugins"},
]

let basicNavs = [
  {
    open NavItem
    {name: "Overview", href: "/docs/manual/v8.0.0/overview"}
  },
  {name: "Let Binding", href: "/docs/manual/v8.0.0/let-binding"},
  {name: "Type", href: "/docs/manual/v8.0.0/type"},
  {name: "Primitive Types", href: "/docs/manual/v8.0.0/primitive-types"},
  {name: "Tuple", href: "/docs/manual/v8.0.0/tuple"},
  {name: "Record", href: "/docs/manual/v8.0.0/record"},
  {name: "Object", href: "/docs/manual/v8.0.0/object"},
  {name: "Variant", href: "/docs/manual/v8.0.0/variant"},
  {
    name: "Null, Undefined & Option",
    href: "/docs/manual/v8.0.0/null-undefined-option",
  },
  {name: "Array & List", href: "/docs/manual/v8.0.0/array-and-list"},
  {name: "Function", href: "/docs/manual/v8.0.0/function"},
  {name: "Control Flow", href: "/docs/manual/v8.0.0/control-flow"},
  {name: "Pipe", href: "/docs/manual/v8.0.0/pipe"},
  {
    name: "Pattern Matching/Destructuring",
    href: "/docs/manual/v8.0.0/pattern-matching-destructuring",
  },
  {name: "Mutation", href: "/docs/manual/v8.0.0/mutation"},
  {name: "JSX", href: "/docs/manual/v8.0.0/jsx"},
  {name: "Exception", href: "/docs/manual/v8.0.0/exception"},
  {name: "Lazy Values", href: "/docs/manual/v8.0.0/lazy-values"},
  {name: "Promise", href: "/docs/manual/v8.0.0/promise"},
  {name: "Module", href: "/docs/manual/v8.0.0/module"},
  {name: "Import & Export", href: "/docs/manual/v8.0.0/import-export"},
  {name: "Reserved Keywords", href: "/docs/manual/v8.0.0/reserved-keywords"},
]

let buildsystemNavs = [
  {
    open NavItem
    {name: "Overview", href: "/docs/manual/v8.0.0/build-overview"}
  },
  {name: "Configuration", href: "/docs/manual/v8.0.0/build-configuration"},
  {
    name: "Interop with JS Build System",
    href: "/docs/manual/v8.0.0/interop-with-js-build-systems",
  },
  {name: "Performance", href: "/docs/manual/v8.0.0/build-performance"},
]

let jsInteropNavs = [
  {
    open NavItem
    {
      name: "Embed Raw JavaScript",
      href: "/docs/manual/v8.0.0/embed-raw-javascript",
    }
  },
  {name: "Shared Data Types", href: "/docs/manual/v8.0.0/shared-data-types"},
  {name: "External (Bind to Any JS Library)", href: "/docs/manual/v8.0.0/external"},
  {name: "Bind to JS Object", href: "/docs/manual/v8.0.0/bind-to-js-object"},
  {
    name: "Bind to JS Function",
    href: "/docs/manual/v8.0.0/bind-to-js-function",
  },
  {
    name: "Import from/Export to JS",
    href: "/docs/manual/v8.0.0/import-from-export-to-js",
  },
  {
    name: "Bind to Global JS Values",
    href: "/docs/manual/v8.0.0/bind-to-global-js-values",
  },
  {name: "JSON", href: "/docs/manual/v8.0.0/json"},
  {
    name: "Use Illegal Identifier Names",
    href: "/docs/manual/v8.0.0/use-illegal-identifier-names",
  },
  {
    name: "Browser Support & Polyfills",
    href: "/docs/manual/v8.0.0/browser-support-polyfills",
  },
  {
    name: "Interop Cheatsheet",
    href: "/docs/manual/v8.0.0/interop-cheatsheet",
  },
]

let guidesNavs = [
  {
    open NavItem
    {
      name: "Converting from JavaScript",
      href: "/docs/manual/v8.0.0/converting-from-js",
    }
  },
  {name: "Libraries", href: "/docs/manual/v8.0.0/libraries"},
]

let extraNavs = [
  {
    open NavItem
    {
      name: "Newcomer Examples",
      href: "/docs/manual/v8.0.0/newcomer-examples",
    }
  },
  {name: "Project Structure", href: "/docs/manual/v8.0.0/project-structure"},
  {name: "FAQ", href: "/docs/manual/v8.0.0/faq"},
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
    let version = "v8.0.0"

    let url = Url.parse(route)
    let latestUrl =
      "/" ++
      (Js.Array2.joinWith(url.base, "/") ++
      ("/latest/" ++ Js.Array2.joinWith(url.pagepath, "/")))

    let warnBanner = {
      open Markdown
      <div className="mb-10">
        <Info>
          <P>
            {("You are currently looking at the " ++
            (version ++
            " docs (Reason v3.6 syntax edition). You can find the latest manual page "))->s}
            <A href=latestUrl> {"here"->s} </A>
            {"."->s}
          </P>
        </Info>
      </div>
    }

    <DocsLayout
      theme=#Reason
      components
      categories
      version
      availableVersions=ManualDocsLayout.allManualVersions
      latestVersionLabel=ManualDocsLayout.latestVersionLabel
      ?frontmatter
      title
      metaTitleCategory="ReScript Language Manual"
      ?activeToc
      breadcrumbs>
      warnBanner children
    </DocsLayout>
  }
}

module Prose = {
  @react.component
  let make = (~frontmatter: option<Js.Json.t>=?, ~children) =>
    <Docs ?frontmatter components=Markdown.default> children </Docs>
}
