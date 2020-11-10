module Link = Next.Link

@react.component
let make = (~children, ~components=Markdown.default) => {
  let overlayState = React.useState(() => false)

  <>
    <div className="mb-32 mt-4 xs:mt-16">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <div className="flex xs:justify-center overflow-hidden">
          <main className="mt-32 min-w-320 lg:align-center w-full px-4 md:px-8 max-w-1280 ">
            <Mdx.Provider components> children </Mdx.Provider>
          </main>
        </div>
      </div>
    </div>
  </>
}
