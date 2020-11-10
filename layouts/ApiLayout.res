module Link = Next.Link
open Util.ReactStuff

// This is used for the version dropdown in the api layouts
let allApiVersions = ["latest", "v8.0.0"]

// Used for replacing "latest" with "vX.X.X" in the version dropdown
let latestVersionLabel = "v8.2.0"

module Sidebar = SidebarLayout.Sidebar
module Toc = SidebarLayout.Toc

module OldDocsWarning = {
  @react.component
  let make = (~version: string, ~route: string) => {
    let url = Url.parse(route)
    let latestUrl =
      "/" ++
      (Js.Array2.joinWith(url.base, "/") ++
      ("/latest/" ++ Js.Array2.joinWith(url.pagepath, "/")))
    open Markdown
    <div className="mb-10">
      <Info>
        <P>
          {("You are currently looking at the " ++
          (version ++
          " docs (Reason v3.6 syntax edition). You can find the latest API docs "))->s}
          <A href=latestUrl> {"here"->s} </A>
          {"."->s}
        </P>
      </Info>
    </div>
  }
}

let makeBreadcrumbs = (~prefix: Url.breadcrumb, route: string): list<Url.breadcrumb> => {
  let url = route->Url.parse

  let (_, rest) = // Strip the "api" part of the url before creating the rest of the breadcrumbs
  Js.Array2.sliceFrom(url.pagepath, 1)->Belt.Array.reduce((prefix.href, []), (acc, path) => {
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
  Belt.Array.concat([prefix], rest)->Belt.List.fromArray
}

@react.component
let make = (
  ~breadcrumbs=?,
  ~categories: array<Sidebar.Category.t>,
  ~title="",
  ~version: option<string>=?,
  ~activeToc: option<Toc.t>=?,
  ~components=ApiMarkdown.default,
  ~children,
) => {
  let router = Next.Router.useRouter()
  let route = router.route

  let (isSidebarOpen, setSidebarOpen) = React.useState(_ => false)
  let toggleSidebar = () => setSidebarOpen(prev => !prev)

  React.useEffect1(() => {
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
  }, [])

  let preludeSection =
    <div className="flex justify-between text-primary font-medium items-baseline">
      {title->s}
      {switch version {
      | Some(version) =>
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
        <VersionSelect latestVersionLabel onChange version availableVersions=allApiVersions />
      | None => React.null
      }}
    </div>

  let sidebar =
    <Sidebar preludeSection isOpen=isSidebarOpen toggle=toggleSidebar categories ?activeToc route />

  let pageTitle = switch breadcrumbs {
  | Some(list{_, {Url.name: name}}) => name
  | Some(list{_, module_, {name}}) => module_.name ++ ("." ++ name)
  | _ => "API"
  }
  <SidebarLayout
    ?breadcrumbs
    metaTitle={pageTitle ++ " | ReScript API"}
    theme=#Reason
    components
    sidebarState=(isSidebarOpen, setSidebarOpen)
    sidebar>
    children
  </SidebarLayout>
}
