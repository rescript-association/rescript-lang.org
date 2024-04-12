@react.component
let make = (~components=MarkdownComponents.default, ~children) => {
  let overlayState = React.useState(() => false)

  <>
    <div className="mt-4 xs:mt-16">
      <div className="text-gray-80">
        <Navigation overlayState />
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
