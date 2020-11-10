open Util.ReactStuff
module Link = Next.Link

let link = "no-underline block text-inherit hover:cursor-pointer hover:text-white text-white-80 mb-px"
let activeLink = "text-inherit font-normal border-b border-fire"

let linkOrActiveLink = (~target, ~route) => target === route ? activeLink : link

let linkOrActiveLinkSubroute = (~target, ~route) =>
  Js.String2.startsWith(route, target) ? activeLink : link

let linkOrActiveApiSubroute = (~route) => {
  let url = Url.parse(route)
  switch Belt.Array.get(url.pagepath, 0) {
  | Some("api") => activeLink
  | _ => link
  }
}

let linkOrActiveDocsSubroute = (~route) => {
  let url = Url.parse(route)
  switch url {
  | {base: ["docs"]}
  | {base: ["docs", "gentype"]}
  | {base: ["docs", "manual"]} =>
    switch Belt.Array.get(url.pagepath, 0) {
    | Some("api") => link
    | _ => activeLink
    }
  | _ => link
  }
}

let githubHref = "https://github.com/reason-association/rescript-lang.org#rescript-langorg"
//let twitterHref = "https://twitter.com/rescriptlang"
let discourseHref = "https://forum.rescript-lang.org"

module CollapsibleLink = {
  // KeepOpen = Menu has been opened and should stay open
  type state =
    | KeepOpen
    | HoverOpen
    | Closed

  @react.component
  let _make = (
    ~title: string,
    ~onStateChange: (~id: string, state) => unit,
    ~allowHover=true,
    /* ~allowInteraction=true, */
    ~id: string,
    ~state: state,
    ~active=false,
    ~children,
  ) => {
    // This is not onClick, because we want to prevent
    // text selection on multiple clicks
    let onMouseDown = evt => {
      ReactEvent.Mouse.preventDefault(evt)
      ReactEvent.Mouse.stopPropagation(evt)

      onStateChange(
        ~id,
        switch state {
        | Closed => KeepOpen
        | HoverOpen => Closed
        | KeepOpen => Closed
        },
      )
    }

    let onMouseEnter = evt => {
      ReactEvent.Mouse.preventDefault(evt)
      if allowHover {
        onStateChange(~id, HoverOpen)
      }
    }

    let isOpen = switch state {
    | Closed => false
    | KeepOpen
    | HoverOpen => true
    }

    // This onClick is required for iOS12 safari.
    // There seems to be a bug where mouse events
    // won't be registered, unless an onClick event
    // is attached
    // DO NOT REMOVE, OTHERWISE THE COLLAPSIBLE WON'T WORK
    let onClick = _ => ()

    let direction = isOpen ? #Up : #Down

    <div className="relative" onMouseEnter>
      <div className="flex items-center">
        <a
          onMouseDown
          onClick
          className={(active ? activeLink : link) ++
          (" border-none flex items-center hover:cursor-pointer " ++
          (isOpen ? " text-white" : ""))}>
          <span className={active ? "border-b border-fire" : ""}> {title->s} </span>
          <span className="fill-current flex-no-wrap inline-block ml-2 w-2">
            <Icon.Caret direction className={active ? "text-inherit" : "text-night-light"} />
          </span>
        </a>
      </div>
      <div
        className={(
          isOpen ? "flex" : "hidden"
        ) ++ " fixed left-0 border-night border-t bg-onyx min-w-320 w-full h-full sm:h-auto sm:justify-center"}
        style={Style.make(~marginTop="1.375rem", ())}>
        <div className="max-w-xl w-full"> children </div>
      </div>
    </div>
  }
}

let useOutsideClick: (ReactDOMRe.Ref.t, unit => unit) => unit = %raw(
  j`(outerRef, trigger) => {
      function handleClickOutside(event) {
        if (outerRef.current && !outerRef.current.contains(event.target)) {
          trigger();
        }
      }

      React.useEffect(() => {
        document.addEventListener("mousedown", handleClickOutside);
        return () => {
          document.removeEventListener("mousedown", handleClickOutside);
        };
      });

    }`
)

let useWindowWidth: unit => option<int> = %raw(
  j` () => {
  const isClient = typeof window === 'object';

  function getSize() {
    return {
      width: isClient ? window.innerWidth : undefined,
      height: isClient ? window.innerHeight : undefined
    };
  }

  const [windowSize, setWindowSize] = React.useState(getSize);

  React.useEffect(() => {
    if (!isClient) {
      return false;
    }

    function handleResize() {
      setWindowSize(getSize());
    }

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []); // Empty array ensures that effect is only run on mount and unmount

  if(windowSize) {
    return windowSize.width;
  }
  return null;
  }
  `
)

type collapsible = {
  title: string,
  children: string => React.element,
  href: string,
  state: CollapsibleLink.state,
}

@@warning("-60")
module SubNav = {
  @@warning("-60")
  module DocsLinks = {
    @react.component
    let _make = (~route: string) => {
      let reTheme = ColorTheme.toCN(#Reason)
      let jsTheme = ColorTheme.toCN(#Js)

      let languageItems = [("Introduction", "/docs/manual/latest/introduction")]

      let recompItems = [
        ("Overview", "/docs/reason-compiler/latest/interop-overview"),
        ("ReasonReact", "/docs/reason-react/latest/introduction"),
        ("GenType", "/docs/gentype/latest/introduction"),
      ]

      let activeThemeLink = "font-normal text-primary border-b border-primary"

      let sectionClass = "pb-12 mt-12 border-b border-night last:border-b-0 lg:w-1/3"
      let overlineClass = "font-black uppercase text-sm tracking-wide text-primary-80"

      let sectionUl = "flex flex-wrap mt-8 list-primary list-inside lg:w-auto max-w-md"

      <div className="lg:flex lg:flex-row px-4 max-w-xl">
        <div className={reTheme ++ (" " ++ sectionClass)}>
          <Link href="/docs/manual/latest/introduction">
            <a className=overlineClass> {"Language Manual"->s} </a>
          </Link>
          <ul className=sectionUl> {languageItems->Belt.Array.mapWithIndex((idx, (title, href)) => {
              let active = route == href ? activeThemeLink ++ " hover:text-primary cursor-auto" : ""
              <li className="w-1/2 xs:w-1/2 h-10" key={Belt.Int.toString(idx)}>
                <Link href>
                  <a className={"text-white-80 hover:text-white hover:cursor-pointer " ++ active}>
                    {title->s}
                  </a>
                </Link>
              </li>
            })->ate} </ul>
        </div>
        <div className={jsTheme ++ (" " ++ sectionClass)}>
          <Link href="/docs/reason-compiler/latest/interop-overview">
            <a className=overlineClass> {"JavaScript & Interop"->s} </a>
          </Link>
          <ul className=sectionUl> {recompItems->Belt.Array.mapWithIndex((idx, (title, href)) => {
              let active = route == href ? activeThemeLink ++ " hover:text-primary cursor-auto" : ""
              <li className="w-1/2 xs:w-1/2 h-10" key={Belt.Int.toString(idx)}>
                <Link href>
                  <a className={"text-white-80 hover:text-white hover:cursor-pointer " ++ active}>
                    {title->s}
                  </a>
                </Link>
              </li>
            })->ate} </ul>
        </div>
      </div>
    }
  }
  /*
   module ApiLinks = {
     [@react.component]
     let make = (~route: string) => {
       let reTheme = ColorTheme.toCN(`Reason);

       let jsItems = [|
         ("Belt Stdlib", "/apis/latest/belt"),
         ("Js Module", "/apis/latest/js"),
         /*("Module 3", "/apis/latest/mod3"),*/
         /*("Module 4", "/apis/latest/mod4"),*/
       |];

       let sectionClass = "pb-12 mt-12 border-b border-night last:border-b-0 lg:w-1/4";
       let overlineClass = "font-black uppercase text-sm tracking-wide text-primary-80";

       let sectionUl = "flex flex-wrap mt-8 list-primary list-inside lg:w-auto max-w-md";

       <div className="lg:flex lg:flex-row px-4 max-w-xl">
         <div className={reTheme ++ " " ++ sectionClass}>
           <Link href="/apis">
             <a className=overlineClass> "Overview"->s </a>
           </Link>
         </div>
         <div className={reTheme ++ " " ++ sectionClass}>
           <Link href="/apis/latest">
             <a className=overlineClass> "JavaScript"->s </a>
           </Link>
           <ul className=sectionUl>
             {jsItems
              ->Belt.Array.mapWithIndex((idx, (title, href)) => {
                  let active =
                    Js.String2.startsWith(route, href) ? "text-primary" : "";
                  <li
                    className="w-1/2 xs:w-1/2 h-10"
                    key={Belt.Int.toString(idx)}>
                    <Link href>
                      <a
                        className={
                          "text-white-80 hover:text-white hover:cursor-pointer "
                          ++ active
                        }>
                        title->s
                      </a>
                    </Link>
                  </li>;
                })
              ->ate}
           </ul>
         </div>
       </div>;
     };
   };
 */
}

module MobileNav = {
  @react.component
  let make = (~route: string) => {
    let base = "font-light mx-4 py-5 text-white-80 border-b border-night"
    let extLink = "block hover:cursor-pointer hover:text-white text-night-light"
    <div className="border-night border-t">
      <ul>
        <li className=base> <DocSearch.Textbox id="docsearch-mobile" /> </li>
        <li className=base>
          <Link href="/try">
            <a className={linkOrActiveLink(~target="/try", ~route)}> {"Playground"->s} </a>
          </Link>
        </li>
        <li className=base>
          <Link href="/blog">
            <a className={linkOrActiveLinkSubroute(~target="/blog", ~route)}> {"Blog"->s} </a>
          </Link>
        </li>
        /*
         <li className=base>
           <Link href="/community">
             <a className={linkOrActiveLink(~target="/community", ~route)}>
               "Community"->s
             </a>
           </Link>
         </li>
 */
        <li className=base>
          <a
            href="https://twitter.com/rescriptlang"
            rel="noopener noreferrer"
            target="_blank"
            className=extLink>
            {"Twitter"->s}
          </a>
        </li>
        <li className=base>
          <a href=githubHref rel="noopener noreferrer" target="_blank" className=extLink>
            {"Github"->s}
          </a>
        </li>
        <li className=base>
          <a href=discourseHref rel="noopener noreferrer" target="_blank" className=extLink>
            {"Forum"->s}
          </a>
        </li>
      </ul>
    </div>
  }
}

/* isOverlayOpen: if the mobile overlay is toggled open */
@react.component
let make = (~fixed=true, ~overlayState: (bool, (bool => bool) => unit)) => {
  let minWidth = "20rem"
  let router = Next.Router.useRouter()

  let route = router.route

  let (_collapsibles, setCollapsibles) = React.useState(_ => [/* { */
  /* title: "Docs", */
  /* href: "/docs", */
  /* children: route => { */
  /* <SubNav.DocsLinks route />; */
  /* }, */
  /* state: Closed, */
  /* }, */
  /* { */
  /* title: "API", */
  /* href: "/apis", */
  /* children: route => <SubNav.ApiLinks route />, */
  /* state: Closed, */
  /* }, */])

  let (isOverlayOpen, setOverlayOpen) = overlayState

  let toggleOverlay = () => setOverlayOpen(prev => !prev)

  let resetCollapsibles = () =>
    setCollapsibles(prev => Belt.Array.map(prev, c => {...c, state: Closed}))

  let outerRef = React.useRef(Js.Nullable.null)
  useOutsideClick(ReactDOMRe.Ref.domRef(outerRef), resetCollapsibles)

  let windowWidth = useWindowWidth()

  // Don't allow hover behavior for collapsibles if mobile navigation is on
  let _allowHover = switch windowWidth {
  | Some(width) => width > 576 // Value noted in tailwind config
  | None => true
  }

  let nonCollapsibleOnMouseEnter = evt => {
    ReactEvent.Mouse.preventDefault(evt)
    resetCollapsibles()
  }

  // Client side navigation requires us to reset the collapsibles
  // whenever a route change had occurred, otherwise the collapsible
  // will stay open, even though you clicked a link
  React.useEffect1(() => {
    open Next.Router.Events
    let {Next.Router.events: events} = router

    let onChangeComplete = _url => {
      resetCollapsibles()
      setOverlayOpen(_ => false)
    }

    events->on(#routeChangeComplete(onChangeComplete))
    events->on(#hashChangeComplete(onChangeComplete))

    Some(
      () => {
        events->off(#routeChangeComplete(onChangeComplete))
        events->off(#hashChangeComplete(onChangeComplete))
      },
    )
  }, [])

  let fixedNav = fixed ? "fixed z-30 top-0" : ""

  <nav
    ref={ReactDOMRe.Ref.domRef(outerRef)}
    id="header"
    style={Style.make(~minWidth, ())}
    className={fixedNav ++ " flex xs:justify-center w-full h-18 bg-gray-95 shadow text-white-80 text-base"}>
    <div className="flex justify-between mx-4 md:mx-8 items-center h-full w-full max-w-1280">
      <div className="h-8 w-8">
        <a
          href="/"
          className="block hover:cursor-pointer w-full h-full flex justify-center items-center font-bold">
          <img src="/static/nav-logo@2x.png" />
        </a>
      </div>
      /* Desktop horizontal navigation */
      <div className="flex items-center xs:justify-end w-full bg-gray-95 sm:h-auto sm:relative">
        <div className="flex ml-10 w-full max-w-320" style={Style.make(~maxWidth="26rem", ())}>
          <Link href="/docs/latest">
            <a
              className={"mr-5 " ++ linkOrActiveDocsSubroute(~route)}
              onMouseEnter=nonCollapsibleOnMouseEnter>
              {"Docs"->s}
            </a>
          </Link>
          <Link href="/docs/manual/latest/api">
            <a
              className={"mr-5 " ++ linkOrActiveApiSubroute(~route)}
              onMouseEnter=nonCollapsibleOnMouseEnter>
              {"API"->s}
            </a>
          </Link>
          <Link href="/try">
            <a
              className={"hidden xs:block mr-5 " ++ linkOrActiveLink(~target="/try", ~route)}
              onMouseEnter=nonCollapsibleOnMouseEnter>
              {"Playground"->s}
            </a>
          </Link>
          <Link href="/blog">
            <a
              className={"hidden xs:block mr-5 " ++
              linkOrActiveLinkSubroute(~target="/blog", ~route)}
              onMouseEnter=nonCollapsibleOnMouseEnter>
              {"Blog"->s}
            </a>
          </Link>
          <Link href="/community">
            <a
              className={"hidden xs:block " ++ linkOrActiveLink(~target="/community", ~route)}
              onMouseEnter=nonCollapsibleOnMouseEnter>
              {"Community"->s}
            </a>
          </Link>
        </div>
        <div className="hidden sm:flex items-center">
          <a
            href=githubHref
            rel="noopener noreferrer"
            target="_blank"
            className={"mr-5 " ++ link}
            onMouseEnter=nonCollapsibleOnMouseEnter>
            <Icon.Github className="w-6 h-6 opacity-50 hover:opacity-100" />
          </a>
          <a
            href="https://twitter.com/rescriptlang"
            rel="noopener noreferrer"
            target="_blank"
            className={"mr-5 " ++ link}
            onMouseEnter=nonCollapsibleOnMouseEnter>
            <Icon.Twitter className="w-6 h-6 opacity-50 hover:opacity-100" />
          </a>
          <a
            href=discourseHref
            rel="noopener noreferrer"
            target="_blank"
            className=link
            onMouseEnter=nonCollapsibleOnMouseEnter>
            <Icon.Discourse className="w-6 h-6 opacity-50 hover:opacity-100" />
          </a>
        </div>
        <div className="hidden sm:block ml-8"> <DocSearch /> </div>
      </div>
    </div>
    /* Burger Button */
    <button
      className="h-full px-4 xs:hidden flex items-center hover:text-white"
      onClick={evt => {
        ReactEvent.Mouse.preventDefault(evt)
        resetCollapsibles()
        toggleOverlay()
      }}>
      <Icon.DrawerDots className={"h-1 w-auto block " ++ (isOverlayOpen ? "text-fire" : "")} />
    </button>
    /* Mobile overlay */
    <div
      style={Style.make(~minWidth, ~top="4.5rem", ())}
      className={(
        isOverlayOpen ? "flex" : "hidden"
      ) ++ " sm:hidden flex-col fixed top-0 left-0 h-full w-full z-30 sm:w-9/12 bg-gray-100 sm:h-auto sm:flex sm:relative sm:flex-row sm:justify-between"}>
      <MobileNav route />
    </div>
  </nav>
}
