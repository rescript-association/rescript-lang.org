module Link = Next.Link

@react.component
let make = (~children, ~components=Markdown.default) => {
  let overlayState = React.useState(() => false)

  <>
    <Meta />
    <div className="mt-4 xs:mt-16">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <div className="absolute top-18 w-full">
          <div
            className="relative overflow-hidden"
            style={ReactDOM.Style.make(~backgroundColor="#0E1529", ~paddingBottom="23.54%", ())}>
            <img
              src="/static/hero.jpg" className="absolute top-0 left-0 object-cover h-auto w-full"
            />
          </div>
          <div className="relative flex xs:justify-center overflow-hidden pb-32">
            <main className="mt-10 min-w-320 lg:align-center w-full px-4 md:px-8 max-w-1280 ">
              <Mdx.Provider components>
                <div className="flex justify-center">
                  <div className="w-full max-w-705">
                    <div>
                      <h1 className="text-80 xs:text-100 font-semibold">
                        {React.string("ReScript")}
                      </h1>
                      <p className="text-21 font-bold mb-2">
                        {React.string("The JavaScript-like language you have been waiting for.")}
                      </p>
                    </div>
                    children
                  </div>
                </div>
              </Mdx.Provider>
            </main>
          </div>
          <Footer />
        </div>
      </div>
    </div>
  </>
}
