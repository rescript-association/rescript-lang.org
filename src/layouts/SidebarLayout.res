/*
    This is the master layout for displaying sidebar based API docs.
    Most of the modules defined in here are here to be reused
    in other API related layouts, such as the Markdown representation
    or the Sidebar component.
 */
module Link = Next.Link

module Toc = {
  type raw = Dict.t<{
    "title": string,
    "category": Nullable.t<string>,
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
    <ul className="mt-3 py-1 mb-4 border-l border-fire-10">
      {Array.map(entries, ({header, href}) =>
        <li key=header className="pl-2 mt-2 first:mt-1">
          <Link
            href
            className="font-normal block text-14 text-gray-40 leading-tight hover:text-gray-80">
            {//links, nested
            React.string(header)}
          </Link>
        </li>
      )->React.array}
    </ul>
}

module Sidebar = {
  module Title = {
    @react.component
    let make = (~children) => {
      let className = "hl-overline text-gray-80 mt-5" //overline

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
    ) =>
      <ul className="mt-2 text-14 font-medium">
        {Array.map(items, m => {
          let hidden = isHidden ? "hidden" : "block"
          let active = isItemActive(m)
            ? ` bg-fire-5 text-red-500 leading-5 -ml-2 pl-2 font-medium block hover:bg-fire-70 `
            : ""

          let activeToc = switch getActiveToc {
          | Some(getActiveToc) => getActiveToc(m)
          | None => None
          }

          <li key=m.name className={hidden ++ " mt-1 leading-4"}>
            <Link
              href=m.href
              className={"truncate block py-1 md:h-auto tracking-tight text-gray-60 rounded-sm hover:bg-gray-20 hover:-ml-2 hover:py-1 hover:pl-2 " ++
              active}>
              {React.string(m.name)}
            </Link>
            {switch activeToc {
            | Some({entries}) =>
              if Array.length(entries) === 0 {
                React.null
              } else {
                <Toc entries />
              }
            | None => React.null
            }}
          </li>
        })->React.array}
      </ul>
  }

  module Category = {
    type t = {
      name: string,
      items: array<NavItem.t>,
    }

    @react.component
    let make = (~getActiveToc=?, ~isItemActive: option<NavItem.t => bool>=?, ~category: t) =>
      <div key=category.name className="my-10">
        <Title> {React.string(category.name)} </Title>
        <NavItem ?isItemActive ?getActiveToc items=category.items />
      </div>
  }

  // subitems: list of functions inside given module (defined by route)
  @react.component
  let make = (
    ~categories: array<Category.t>,
    ~route: string,
    ~toplevelNav=React.null,
    ~title as _: option<string>=?,
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
        ) ++ " md:block md:w-48 md:-ml-4 lg:w-1/5 md:h-auto md:relative overflow-y-visible bg-white"}>
        <aside
          id="sidebar-content"
          className="relative top-0 px-4 w-full block md:top-16 md:pt-16 md:sticky border-r border-gray-20 overflow-y-auto pb-24"
          style={ReactDOMStyle.make(~height="calc(100vh - 4.5rem", ())}>
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
            ->Array.map(category =>
              <div key=category.name>
                <Category getActiveToc isItemActive category />
              </div>
            )
            ->React.array}
          </div>
        </aside>
      </div>
    </>
  }
}

module BreadCrumbs = {
  @react.component
  let make = (~crumbs: list<Url.breadcrumb>) =>
    <div className="w-full captions overflow-x-auto text-gray-60">
      {List.mapWithIndex(crumbs, (crumb, i) => {
        let item = if i === List.length(crumbs) - 1 {
          <span key={Int.toString(i)}> {React.string(crumb.name)} </span>
        } else {
          <Link key={Int.toString(i)} href=crumb.href> {React.string(crumb.name)} </Link>
        }
        if i > 0 {
          <span key={Int.toString(i)}>
            {React.string(" / ")}
            item
          </span>
        } else {
          item
        }
      })
      ->List.toArray
      ->React.array}
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
  ~components: MarkdownComponents.t,
  ~editHref: option<string>=?,
  ~sidebarState: (bool, (bool => bool) => unit),
  // (Sidebar, toggleSidebar) ... for toggling sidebar in mobile view
  ~sidebar: React.element,
  ~rightSidebar: option<React.element>=?,
  ~categories: option<array<Sidebar.Category.t>>=?,
  ~breadcrumbs: option<list<Url.breadcrumb>>=?,
  ~children,
) => {
  let (isNavOpen, setNavOpen) = React.useState(() => false)
  let router = Next.Router.useRouter()
  let version = Url.parse(router.route).version

  let theme = ColorTheme.toCN(theme)

  let hasBreadcrumbs = switch breadcrumbs {
  | None => false
  | Some(l) => List.length(l) > 0
  }

  let breadcrumbs = breadcrumbs->Option.mapOr(React.null, crumbs => <BreadCrumbs crumbs />)

  let (_isSidebarOpen, setSidebarOpen) = sidebarState
  let toggleSidebar = () => setSidebarOpen(prev => !prev)

  React.useEffect(() => {
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

  let handleDrawerButtonClick = React.useCallback(evt => {
    ReactEvent.Mouse.preventDefault(evt)
    toggleSidebar()
  }, [])

  let editLinkEl = switch editHref {
  | Some(href) =>
    <a href className="inline text-14 hover:underline text-fire" rel="noopener noreferrer">
      {React.string("Edit")}
    </a>
  | None => React.null
  }

  let pagination = switch categories {
  | Some(categories) =>
    let items = categories->Array.flatMap(c => c.items)

    switch items->Array.findIndex(item => item.href === router.route) {
    | -1 => React.null
    | i =>
      let previous = switch items->Array.get(i - 1) {
      | Some({name, href}) =>
        <Link
          href
          className={"flex items-center text-fire hover:text-fire-70 border-2 border-red-300 rounded py-1.5 px-3"}>
          <Icon.ArrowRight className={"rotate-180 mr-2"} />
          {React.string(name)}
        </Link>
      | None => React.null
      }
      let next = switch items->Array.get(i + 1) {
      | Some({name, href}) =>
        <Link
          href
          className={"flex items-center text-fire hover:text-fire-70 ml-auto border-2 border-red-300 rounded py-1.5 px-3"}>
          {React.string(name)}
          <Icon.ArrowRight className={"ml-2"} />
        </Link>
      | None => React.null
      }
      <div className={"flex justify-between mt-9"}>
        previous
        next
      </div>
    }
  | None => React.null
  }

  <>
    <Meta title=metaTitle version />
    <div className={"mt-16 min-w-320 " ++ theme}>
      <div className="w-full">
        <Navigation isOverlayOpen=isNavOpen setOverlayOpen=setNavOpen />
        <div className="flex lg:justify-center">
          <div className="flex w-full max-w-1280 md:mx-8">
            sidebar
            <main className="px-4 w-full pt-16 md:ml-12 lg:mr-8 mb-32 md:max-w-576 lg:max-w-740">
              //width of the right content part
              <div
                className={"z-10 fixed border-b shadow top-16 left-0 pl-4 bg-white w-full py-4 md:relative md:border-none md:shadow-none md:p-0 md:top-auto flex items-center transition duration-300 ease-out group-[.nav-disappear]:-translate-y-32 md:group-[.nav-disappear]:transform-none"}>
                <MobileDrawerButton hidden=isNavOpen onClick={handleDrawerButtonClick} />
                <div
                  className="truncate overflow-x-auto touch-scroll flex items-center space-x-4 md:justify-between mr-4 w-full">
                  breadcrumbs
                  editLinkEl
                </div>
              </div>
              <div className={hasBreadcrumbs ? "mt-10" : "-mt-4"}>
                <MdxProvider components> children </MdxProvider>
              </div>
              pagination
            </main>
            {switch rightSidebar {
            | Some(ele) => ele
            | None => React.null
            }}
          </div>
        </div>
      </div>
      <Footer />
    </div>
  </>
}
