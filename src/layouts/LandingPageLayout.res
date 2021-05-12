/* module Link = Next.Link */

// Copy Brainstorming Gist:
// https://gist.github.com/chenglou/3624a93d63dbd32c4a3d087f9c9e06bc

module CallToActionButton = {
  @react.component
  let make = (~children) =>
    <button
      className="transition-colors duration-200 inline-block text-base text-white hover:bg-water-70 hover:text-white hover:border-water-70 bg-water rounded border border-water px-5 py-2">
      children
    </button>
}

module Intro = {
  @react.component
  let make = () => {
    <div className="flex flex-col items-center">
      <h1
        className="text-56 text-gray-95 tracking-tight leading-2 font-semibold text-center"
        style={ReactDOM.Style.make(~maxWidth="54rem", ())}>
        {React.string("A simple and fast language for JavaScript developers")}
      </h1>
      <h2 className="text-gray-40 text-center my-4">
        {React.string(
          "ReScript looks like JS, acts like JS, and compiles to the highest quality of clean, readable and performant JS, directly runnable in browsers and Node.",
        )}
      </h2>
      <CallToActionButton> {React.string("Get started")} </CallToActionButton>
    </div>
  }
}

module PlaygroundHero = {
  @react.component
  let make = () => {
    <section
      className="relative flex justify-center px-12 bg-gray-10"
      style={ReactDOM.Style.make(~height="35rem", ())}>
      // Playground widget
      <div
        className="bg-gray-90 max-w-740 w-full -mt-12"
        style={ReactDOM.Style.make(~height="30rem", ())}>
        {React.string("Playground Widget etc.")}
      </div>
    </section>
  }
}

// Main unique selling points
module MainUSP = {
  
  module Item = {
    @react.component
    let make = (~title: string, ~paragraph: React.element) => {
      <div className="w-full" style={ReactDOM.Style.make(~maxWidth="30rem", ())}>
        <h3
          className="text-gray-10 mt-16 mb-6 text-32 leading-1 font-semibold"
          style={ReactDOM.Style.make(~maxWidth="25rem", ())}>
          {React.string(title)}
        </h3>
        <div className="text-gray-60 text-16"> paragraph </div>
      </div>
    }
  }

  let item1 =
    <Item
      title={"The fastest build system on the web"}
      paragraph={React.string(`ReScript cares about a consistent and fast feedback loop for any
            codebase size. No need for memory hungry build processes, and no
            corrupted caches. Switch branches as you please without worrying
            about stale caches or wrong type information.`)}
    />

  let item2 =
    <Item
      title={"Robust Type System"}
      paragraph={React.string(` Every ReScript app is fully typed and provides
      correct type information to any given value. We prioritize simpler types
      / discourage complex types for the sake of clarity and easy debugability.
      No \`any\`, no magic types, no surprise \`undefined\`.
      `)}
    />

  let item3 =
    <Item
      title={"Seamless JS Integration"}
      paragraph={React.string(`Use any library from javascript, export rescript
      libraries to javascript, generate typescript and flow types, etc. It's
      like you've never left the good parts of javascript at all.`)}
    />

  @react.component
  let make = (~children as _) => {
    let (selected, setSelected) = React.useState(_ => item1)

    let createTab = (text, selectedItem) => {
      <button
        className="text-fire-50 text-21"
        onClick={_evt => {
          setSelected(_ => selectedItem)
        }}>
        {React.string(text)}
      </button>
    }

    <section className="flex h-full w-full">
      <div className="flex justify-center bg-gray-90 pb-32 w-full space-y-4 text-white-80">
        <div>
          <div className="flex space-x-4">
            {createTab("Fast and Simple", item1)}
            {createTab("Robust Type System", item2)}
            {createTab("Seamless JS Integration", item3)}
          </div>
          selected
        </div>
      </div>
      <div
        className="bg-fire-40 h-full w-full" style={ReactDOM.Style.make(~maxWidth="18.5rem", ())}
      />
    </section>
  }
}

/* module SubtleButton = { */
/* @react.component */
/* let make = (~children) => */
/* <button */
/* className="transition-colors duration-200 inline-block text-base text-fire rounded border-2 border-fire-10 hover:bg-fire-10 px-5 py-2"> */
/* children */
/* </button> */
/* } */

@react.component
let make = (~components=Markdown.default, ~children) => {
  let overlayState = React.useState(() => false)

  <>
    <Meta />
    <div className="mt-4 xs:mt-16">
      <div className="text-gray-80 text-lg">
        <Navigation overlayState />
        <div className="absolute top-16 w-full">
          <div className="relative flex xs:justify-center overflow-hidden pb-32">
            <main className="mt-10 min-w-320 lg:align-center w-full">
              <Mdx.Provider components>
                <div className="flex justify-center">
                  <div className="w-full flex flex-col">
                    <div className="mt-12 max-w-740 self-center"> <Intro /> </div>
                    <div className="mt-16 w-full self-center"> <PlaygroundHero /> </div>
                    <div className="mt-16"> <MainUSP> {React.string("test")} </MainUSP> </div>
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
