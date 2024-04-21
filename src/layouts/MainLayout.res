@react.component
let make = (~components=MarkdownComponents.default, ~navbarCollapsible=false, ~children) => {
  let (isOverlayOpen, setOverlayOpen) = React.useState(() => false)
  let scrollDir = ScrollDirectionHook.useScrollDirection()

  let navAppearanceCascading = switch (navbarCollapsible, scrollDir) {
  | (true, Up(_)) => " group nav-appear"
  | (true, Down(_)) => " group nav-disappear"
  | _ => ""
  }

  <>
    <div className={"mt-4 xs:mt-16" ++ navAppearanceCascading}>
      <div className="text-gray-80">
        <Navigation isOverlayOpen setOverlayOpen />
        <div className="flex xs:justify-center overflow-hidden pb-48">
          <main className="mt-16 min-w-320 lg:align-center w-full px-4 md:px-8 max-w-1280 ">
            <MdxProvider components> children </MdxProvider>
          </main>
        </div>
        <Footer />
      </div>
    </div>
  </>
}
