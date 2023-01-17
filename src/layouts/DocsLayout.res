// This module is used for all plain prose text related
// Docs, mostly /docs/manual/latest and similar sections

module Sidebar = SidebarLayout.Sidebar

module NavItem = Sidebar.NavItem
module Category = Sidebar.Category

/*
let makeBreadcrumbsFromPaths = (~basePath: string, paths: array<string>): list<Url.breadcrumb> => {
  let (_, rest) = Belt.Array.reduce(paths, (basePath, []), (acc, path) => {
    let (baseHref, ret) = acc

    let href = baseHref ++ ("/" ++ path)

    Js.Array2.push(
      ret,
      {
        open Url
        {name: prettyString(path), href: href}
      },
    )->ignore
    (href, ret)
  })
  rest->Belt.List.fromArray
}
*/

let makeBreadcrumbs = (~basePath: string, route: string): list<Url.breadcrumb> => {
  let url = route->Url.parse

  let (_, rest) = url.pagepath->Belt.Array.reduce((basePath, []), (acc, path) => {
    let (baseHref, ret) = acc

    let href = baseHref ++ ("/" ++ path)

    Js.Array2.push(
      ret,
      {
        open Url
        {name: prettyString(path), href}
      },
    )->ignore
    (href, ret)
  })
  rest->Belt.List.fromArray
}

@react.component
let make = (
  ~breadcrumbs: option<list<Url.breadcrumb>>=?,
  ~title: string,
  ~metaTitleCategory: option<string>=?, // e.g. Introduction | My Meta Title Category
  ~frontmatter=?,
  ~version: option<string>=?,
  ~availableVersions: option<array<(string, string)>>=?,
  ~activeToc: option<SidebarLayout.Toc.t>=?,
  ~categories: array<Category.t>,
  ~components=Markdown.default,
  ~theme=#Reason,
  ~children,
) => {
  let router = Next.Router.useRouter()
  let route = router.route

  let (isSidebarOpen, setSidebarOpen) = React.useState(_ => false)
  let toggleSidebar = () => setSidebarOpen(prev => !prev)

  React.useEffect0(() => {
    open Next.Router.Events
    let {Next.Router.events: events} = router

    let onChangeComplete = _url => setSidebarOpen(_ => false)

    events->on(#routeChangeComplete(onChangeComplete))
    events->on(#hashChangeComplete(onChangeComplete))

    Some(
      () => {
        events->off(#routeChangeComplete(onChangeComplete))
        events->off(#hashChangeComplete(onChangeComplete))
      },
    )
  })

  let preludeSection =
    <div className="flex justify-between text-fire font-medium items-baseline">
      {React.string(title)}
      {switch version {
      | Some(version) =>
        switch availableVersions {
        | Some(availableVersions) =>
          let onChange = evt => {
            open Url
            ReactEvent.Form.preventDefault(evt)
            let version = (evt->ReactEvent.Form.target)["value"]
            let url = Url.parse(route)

            let targetUrl =
              "/" ++
              (Js.Array2.joinWith(url.base, "/") ++
              ("/" ++ (version ++ ("/" ++ Js.Array2.joinWith(url.pagepath, "/")))))
            router->Next.Router.push(targetUrl)
          }
          <VersionSelect onChange version availableVersions />
        | None => <span className="font-mono text-14"> {React.string(version)} </span>
        }
      | None => React.null
      }}
    </div>

  let sidebar =
    <Sidebar
      isOpen=isSidebarOpen toggle=toggleSidebar preludeSection title ?activeToc categories route
    />

  let metaTitle = switch metaTitleCategory {
  | Some(titleCategory) => titleCategory ++ (" | " ++ "ReScript Documentation")
  | None => title
  }

  let (metaElement, editHref) = switch frontmatter {
  | Some(frontmatter) =>
    switch DocFrontmatter.decode(frontmatter) {
    | Some(fm) =>
      let canonical = Js.Null.toOption(fm.canonical)
      let description = Js.Null.toOption(fm.description)
      let title = switch metaTitleCategory {
      | Some(titleCategory) =>
        // We will prefer an existing metaTitle over just a title
        let metaTitle = switch Js.Null.toOption(fm.metaTitle) {
        | Some(metaTitle) => metaTitle
        | None => fm.title
        }
        metaTitle ++ (" | " ++ titleCategory)
      | None => title
      }
      let meta = <Meta title ?description ?canonical />
      (meta, Some(fm.ghEditHref))
    | None => (React.null, None)
    }
  | None => (React.null, None)
  }

  <SidebarLayout
    metaTitle
    theme
    components
    sidebarState=(isSidebarOpen, setSidebarOpen)
    sidebar
    categories
    ?breadcrumbs
    ?editHref>
    metaElement
    children
  </SidebarLayout>
}

module type StaticContent = {
  /* let categories: array(SidebarLayout.Sidebar.Category.t); */
  let tocData: SidebarLayout.Toc.raw
}

module Make = (Content: StaticContent) => {
  @react.component
  let make = (
    // base breadcrumbs without the very last element (the currently shown document)
    ~breadcrumbs: option<list<Url.breadcrumb>>=?,
    ~title: string,
    ~metaTitleCategory: option<string>=?,
    ~frontmatter=?,
    ~version: option<string>=?,
    ~availableVersions: option<array<(string, string)>>=?,
    /* ~activeToc: option(SidebarLayout.Toc.t)=?, */
    ~components: option<Mdx.Components.t>=?,
    ~theme: option<ColorTheme.t>=?,
    ~children: React.element,
  ) => {
    let router = Next.Router.useRouter()
    let route = router.route

    // Extend breadcrumbs with document title
    let breadcrumbs = Js.Dict.get(Content.tocData, route)->Belt.Option.mapWithDefault(
      breadcrumbs,
      data => {
        let title = data["title"]

        Belt.Option.map(breadcrumbs, bc =>
          Belt.List.concat(bc, list{{Url.name: title, href: route}})
        )
      },
    )

    let activeToc: option<SidebarLayout.Toc.t> = {
      open Belt.Option
      Js.Dict.get(Content.tocData, route)->map(data => {
        open SidebarLayout.Toc
        let title = data["title"]
        let entries = Belt.Array.map(data["headers"], header => {
          header: header["name"],
          href: "#" ++ header["href"],
        })
        {title, entries}
      })
    }

    let categories = {
      let groups = Js.Dict.entries(Content.tocData)->Belt.Array.reduce(Js.Dict.empty(), (
        acc,
        next,
      ) => {
        let (_, value) = next
        switch Js.Nullable.toOption(value["category"]) {
        | Some(category) =>
          switch acc->Js.Dict.get(category) {
          | None => acc->Js.Dict.set(category, [next])
          | Some(arr) =>
            Js.Array2.push(arr, next)->ignore
            acc->Js.Dict.set(category, arr)
          }
        | None =>
          Js.log2("has NO category", next)
          ()
        }
        acc
      })
      Js.Dict.entries(groups)->Belt.Array.map(((name, values)) => {
        open Category
        {
          name,
          items: Belt.Array.map(values, ((href, value)) => {
            NavItem.name: value["title"],
            href,
          }),
        }
      })
    }

    make({
      "breadcrumbs": breadcrumbs,
      "title": title,
      "metaTitleCategory": metaTitleCategory,
      "frontmatter": frontmatter,
      "version": version,
      "availableVersions": availableVersions,
      "activeToc": activeToc,
      "categories": categories,
      "components": components,
      "theme": theme,
      "children": children,
    })
  }
}
