/** scrollDir is not memo-friendly.
  It must be used with pattern matching.
  Do not pass it directly to child components. */
type scrollDir =
  | Up({scrollY: int})
  | Down({scrollY: int})

/**
  This will cause highly frequent events, so use it only once in a root as possible.
  And split the children components to prevent heavy ones from being re-rendered unnecessarily. */
let useScrollDirection = () => {
  let (_, startScrollEventTransition) = React.useTransition()
  let (scrollDir, setScrollDir) = React.useState(() => Up({scrollY: %raw(`Infinity`)}))

  React.useEffect(() => {
    let onScroll = _e => {
      startScrollEventTransition(() => {
        setScrollDir(
          prev => {
            let Up({scrollY}) | Down({scrollY}) = prev
            if scrollY === 0 || scrollY > Webapi.Window.scrollY {
              Up({scrollY: Webapi.Window.scrollY})
            } else {
              Down({scrollY: Webapi.Window.scrollY})
            }
          },
        )
      })
    }
    Webapi.Window.addEventListener("scroll", onScroll)
    Some(() => Webapi.Window.removeEventListener("scroll", onScroll))
  }, [])

  scrollDir
}
