/*
    This is the master layout for displaying sidebar based API docs.
    Most of the modules defined in here are here to be reused
    in other API related layouts, such as the Markdown representation
    or the Sidebar component.
 */
open Util.ReactStuff
module Link = Next.Link

module Toc = {
  type raw = Js.Dict.t<{
    "title": string,
    "category": Js.Nullable.t<string>,
    "headers": array<{
      "name": string,
      "href": string,
    }>,
  }>

  type entry = {
    header: string,
    href: string,
  }

  type t = {
    title: string,
    entries: array<entry>,
  }

  @react.component
  let make = (~entries: array<entry>) =>
    <ul className="mt-2 py-1 mb-4 border-l border-primary">
      {Belt.Array.map(entries, ({header, href}) =>
        <li key=header className="pl-2 mt-3 first:mt-1">
          <Link href>
            <a
              className="font-medium block text-sm text-night-light leading-tight tracking-tight hover:text-primary">
              {header->s}
            </a>
          </Link>
        </li>
      )->ate}
    </ul>
}

module Sidebar = {
  module Title = {
    @react.component
    let make = (~children) => {
      let className = "font-sans font-black text-night-light tracking-wide text-xs uppercase mt-5"

      <div className> children </div>
    }
  }

  module NavItem = {
    // Navigation point information
    type t = {
      name: string,
      href: string,
    }
    @react.component
    let make = (
      ~getActiveToc: option<t => option<Toc.t>>=?,
      ~isItemActive: t => bool=_nav => false,
      ~isHidden=false,
      ~items: array<t>,
    ) => <ul className="mt-2 text-sm font-medium"> {Belt.Array.map(items, m => {
          let hidden = isHidden ? "hidden" : "block"
          let active = isItemActive(m)
            ? j` bg-fire-15 text-fire leading-5 -ml-2 pl-2 font-semibold block hover:bg-fire-15 `
            : ""

          let activeToc = switch getActiveToc {
          | Some(getActiveToc) => getActiveToc(m)
          | None => None
          }

          <li key=m.name className={hidden ++ " mt-1 leading-4"}>
            <Link href=m.href>
              <a
                className={"truncate block py-1 md:h-auto tracking-tight text-night-darker rounded-sm  hover:bg-gray-5 hover:-ml-2 hover:py-1 hover:pl-2 " ++
                active}>
                {m.name->s}
              </a>
            </Link>
            {switch activeToc {
            | Some({entries}) =>
              if Belt.Array.length(entries) === 0 {
                React.null
              } else {
                <Toc entries />
              }
            | None => React.null
            }}
          </li>
        })->ate} </ul>
  }

  module Category = {
    type t = {
      name: string,
      items: array<NavItem.t>,
    }

    @react.component
    let make = (~getActiveToc=?, ~isItemActive: option<NavItem.t => bool>=?, ~category: t) =>
      <div key=category.name className="my-12">
        <Title> {category.name->s} </Title>
        <NavItem ?isItemActive ?getActiveToc items=category.items />
      </div>
  }

  // subitems: list of functions inside given module (defined by route)
  @react.component
  let make = (
    ~categories: array<Category.t>,
    ~route: string,
    ~toplevelNav=React.null,
    ~title: option<string>=?,
    ~preludeSection=React.null,
    ~activeToc: option<Toc.t>=?,
    ~isOpen: bool,
    ~toggle: unit => unit,
  ) => {
    let isItemActive = (navItem: NavItem.t) => navItem.href === route

    let getActiveToc = (navItem: NavItem.t) =>
      if navItem.href === route {
        activeToc
      } else {
        None
      }

    <>
      <div
        id="sidebar"
        className={(
          isOpen ? "fixed w-full left-0 h-full z-20 min-w-320" : "hidden "
        ) ++ " md:block md:w-48 md:-ml-4 lg:w-1/4 md:h-auto md:relative overflow-y-visible bg-white md:relative"}
        style={Style.make(~minWidth="12.9375rem", ())}>
        <aside
          id="sidebar-content"
          className="relative top-0 px-4 w-full block md:top-18 md:pt-24 md:sticky border-r border-snow-dark overflow-y-auto scrolling-touch pb-24"
          style={Style.make(~height="calc(100vh - 4.5rem", ())}>
          <div className="flex justify-between">
            <div className="w-3/4 md:w-full"> toplevelNav </div>
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
          /* Firefox ignores padding in scroll containers, so we need margin
               to make a bottom gap for the sidebar.
               See https://stackoverflow.com/questions/29986977/firefox-ignores-padding-when-using-overflowscroll
 */
          <div className="mb-56">
            {categories
            ->Belt.Array.map(category =>
              <div key=category.name> <Category getActiveToc isItemActive category /> </div>
            )
            ->ate}
          </div>
        </aside>
      </div>
    </>
  }
}

module BreadCrumbs = {
  @react.component
  let make = (~crumbs: list<Url.breadcrumb>) =>
    <div className="w-full font-medium tracking-tight overflow-x-auto text-14 text-night">
      {Belt.List.mapWithIndex(crumbs, (i, crumb) => {
        let item = if i === Belt.List.length(crumbs) - 1 {
          <span key={Belt.Int.toString(i)}> {crumb.name->s} </span>
        } else {
          <Link key={Belt.Int.toString(i)} href=crumb.href> <a> {crumb.name->s} </a> </Link>
        }
        if i > 0 {
          <span key={Belt.Int.toString(i)}> {" / "->s} item </span>
        } else {
          item
        }
      })->Belt.List.toArray->ate}
    </div>
}

module MobileDrawerButton = {
  @react.component
  let make = (~hidden: bool, ~onClick) =>
    <button className={(hidden ? "hidden" : "") ++ " md:hidden mr-3"} onMouseDown=onClick>
      <img className="h-4" src="/static/ic_sidebar_drawer.svg" />
    </button>
}

@react.component
let make = (
  ~metaTitle: string,
  ~theme: ColorTheme.t,
  ~components: Mdx.Components.t,
  ~sidebarState: (bool, (bool => bool) => unit),
  // (Sidebar, toggleSidebar) ... for toggling sidebar in mobile view
  ~sidebar: React.element,
  ~breadcrumbs: option<list<Url.breadcrumb>>=?,
  ~children,
) => {
  let (isNavOpen, setNavOpen) = React.useState(() => false)
  let router = Next.Router.useRouter()

  let theme = ColorTheme.toCN(theme)

  let hasBreadcrumbs = switch breadcrumbs {
  | None => false
  | Some(l) => List.length(l) > 0
  }

  let breadcrumbs =
    breadcrumbs->Belt.Option.mapWithDefault(React.null, crumbs => <BreadCrumbs crumbs />)

  let (isSidebarOpen, setSidebarOpen) = sidebarState
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

  <>
    <Meta title=metaTitle />
    <div className={"mt-16 min-w-320 " ++ theme}>
      <div className="w-full text-night font-base">
        <Navigation overlayState=(isNavOpen, setNavOpen) />
        <div className="flex justify-center">
          <div className="w-full max-w-1280 md:mx-8">
            <div className="flex">
              sidebar
              <main
                className="px-6 w-full md:ml-12 md:mx-8 pt-16 md:mt-2 md:pt-24 mb-32 text-lg max-w-705">
                <div
                  className="z-10 fixed border-b shadow top-18 left-0 pl-4 bg-white w-full py-4 md:relative md:border-none md:shadow-none md:p-0 md:top-auto flex items-center">
                  <MobileDrawerButton
                    hidden=isNavOpen
                    onClick={evt => {
                      ReactEvent.Mouse.preventDefault(evt)
                      toggleSidebar()
                    }}
                  />
                  <div className="truncate overflow-x-auto touch-scroll"> breadcrumbs </div>
                </div>
                <div className={hasBreadcrumbs ? "mt-10" : "-mt-4"}>
                  <Mdx.Provider components> children </Mdx.Provider>
                </div>
              </main>
            </div>
          </div>
        </div>
      </div>
    </div>
  </>
}
