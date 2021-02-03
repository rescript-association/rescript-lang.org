module Link = Next.Link

module CallToActionButton = {
  @react.component
  let make = (~children) =>
    <button
      className="transition-colors duration-200 inline-block text-base text-white hover:bg-fire-80 hover:text-white bg-fire rounded border border-fire-80 px-5 py-2">
      children
    </button>
}

module SubtleButton = {
  @react.component
  let make = (~children) =>
    <button
      className="transition-colors duration-200 inline-block text-base text-fire rounded border-2 border-fire-80 hover:bg-fire-10 px-5 py-2">
      children
    </button>
}

@react.component
let make = (~components=Markdown.default, ~children) => {
  let overlayState = React.useState(() => false)

  <>
    <Meta />
    <div className="mt-4 xs:mt-16">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <div className="absolute top-18 w-full">
          <div
            className="flex justify-center overflow-hidden"
            style={ReactDOM.Style.make(~backgroundColor="#0E1529", ())}>
            <div className="max-w-1280 w-full">
              <div
                className="relative overflow-hidden w-full"
                style={ReactDOM.Style.make(~paddingBottom="23.5587189%", ())}>
                <img
                  src="/static/hero.jpg"
                  className="absolute top-0 left-0 object-cover w-full h-full"
                />
              </div>
            </div>
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
                      <p className="text-14 italic">
                        {React.string("Previously known as BuckleScript and Reason (")}
                        <Next.Link href="/bucklescript-rebranding">
                          <a className="text-fire hover:pointer hover:underline">
                            {React.string("Learn more")}
                          </a>
                        </Next.Link>
                        {React.string(")")}
                      </p>
                    </div>
                    <div
                      className="mt-16 text-center flex space-y-4 flex-col xs:space-y-0 xs:flex-row xs:space-x-8 pb-48">
                      <Link href="/docs/manual/latest/installation">
                        <a>
                          <CallToActionButton>
                            {React.string("Getting started")}
                          </CallToActionButton>
                        </a>
                      </Link>
                      <Link href="/docs/manual/latest/introduction">
                        <a>
                          <SubtleButton> {React.string("Read the Documentation")} </SubtleButton>
                        </a>
                      </Link>
                    </div>
                    <PlaygroundWidget initialCode="let a = 1" />
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
