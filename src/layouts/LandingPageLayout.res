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
      <div className="my-10">
        <CallToActionButton> {React.string("Get started")} </CallToActionButton>
      </div>
    </div>
  }
}

module PlaygroundHero = {
  @react.component
  let make = () => {
    <section className="relative mt-20 bg-gray-10">
      // Playground widget
      <div className="relative flex justify-center w-full">
        <div
          className="relative rounded-b-xl pb-8 px-16 w-full"
          style={ReactDOM.Style.make(~maxWidth="1160px", ())}>
          <div
            className="relative -mt-24 bg-gray-90 mx-auto rounded-xl p-10 flex justify-center items-center text-center z-10"
            style={ReactDOM.Style.make(~zIndex="2", ~height="30rem", ~maxWidth="1124px", ())}>
            <h1 className="text-gray-10 text-28 leading-1 font-semibold max-w-740">
              {React.string(
                "ReScript elevates the most advanced products in the world to a new level of power and beauty.",
              )}
            </h1>
          </div>
          <div
            className="gradientShadow absolute bottom-0 left-0 right-0 top-0 -mt-6 w-full"
            style={ReactDOM.Style.make(~zIndex="1", ())}>
            {React.string("")}
          </div>
          <img
            className="absolute opacity-25 z-0 left-0 top-0 -mr-4"
            src="/static/Rectangle_499.svg"
            style={ReactDOM.Style.make(~height="300px", ~width="300px", ())}
          />
          <img
            className="absolute z-0 right-0 top-0 mt-24 -mr-2"
            src="/static/Rectangle_499.svg"
            style={ReactDOM.Style.make(~height="300px", ~width="300px", ~opacity="0.3", ())}
          />
        </div>
      </div>
      <div>
        <h2 className="my-32 text-center max-w-576 mx-auto font-semibold text-28">
          <span className="text-fire-40"> {React.string("We strongly believe")} </span>
          {React.string(` that every aspect of the language should be fast, correct and shouldn’t rely on caches. Every ReScript program is fully typed and provides correct type information to any given value in your app.`)}
        </h2>
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

  let items = [item1, item2, item3]
  let tabs = ["Fast and Simple", "Robust Type System", "Seamless JS Integration"]

  @react.component
  let make = () => {
    let (selectedIndex, setSelectedIndex) = React.useState(_ => 0)

    <section className="flex items-stretch w-full" style={ReactDOM.Style.make(~height="37rem", ())}>
      <div className="pl-32 bg-gray-90 pb-32 w-full text-white-80">
        <div className="flex justify-between mt-6 pr-20 w-full">
          {tabs
          ->Js.Array2.mapi((tabTitle, i) => {
            let className = if i === selectedIndex {
              "text-fire-50 text-xl border-b-2 border-fire-50"
            } else {
              "text-xl text-gray-80"
            }
            <button className onClick={_evt => setSelectedIndex(_ => i)}>
              {React.string(tabTitle)}
            </button>
          })
          ->React.array}
        </div>
        <div className="mt-20"> {items->Js.Array2.unsafe_get(selectedIndex)} </div>
      </div>
      <div
        className="bg-fire-40 w-full flex flex-col"
        style={ReactDOM.Style.make(~maxWidth="18.5rem", ())}>
        <div className="flex-grow" />
      </div>
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

module TrustedBy = {
  // TODO: is this data structure too fancy?
  type company =
    | Logo({name: string, path: string, /* TODO: get rid of style */ style: ReactDOM.Style.t})
    | Name(string)

  let companies = [
    Logo({
      name: "Facebook Messenger",
      path: "/static/messenger-logo-64@2x.png",
      style: ReactDOM.Style.make(~height="64px", ()),
    }),
    Name("Facebook"),
    Name("Rohea"),
    Name("Beop"),
    Name("Travel World"),
    Logo({
      name: "Pupilfirst",
      path: "/static/pupilfirst-logo.png",
      style: ReactDOM.Style.make(~height="42px", ()),
    }),
    Name("NomadicLabs"),
  ]

  @react.component
  let make = () => {
    <section className="mt-20">
      <h3
        className="text-42 text-gray-42 tracking-tight leading-2 font-semibold text-center max-w-576 mx-auto">
        {React.string("Trusted by developers around the world")}
      </h3>
      <div className="flex justify-between items-center max-w-xl mx-auto mt-16">
        {companies
        ->Js.Array2.map(company => {
          let (companyKey, renderedCompany) = switch company {
          | Name(name) => (name, React.string(name))
          | Logo({name, path, style}) => (name, <img className="max-w-sm" style src=path />)
          }
          <div key=companyKey> renderedCompany </div>
        })
        ->React.array}
      </div>
      <div className="text-center mt-16 text-sm"> {React.string(`and many more…`)} </div>
      <div
        className="mt-10 max-w-xs overflow-hidden opacity-50"
        style={ReactDOM.Style.make(~maxHeight="6rem", ())}>
        <img className="w-full h-full" src="/static/Rectangle_499.svg" />
      </div>
    </section>
  }
}

module CuratedResources = {
  // TODO: is this overkill, should we just inline this as jsx?
  type card = {
    imgSrc: string,
    title: React.element,
    descr: string,
    href: string,
  }

  let cards = [
    {
      imgSrc: "/static/ic_manual@2x.png",
      title: React.string("Language Manual"),
      descr: "Look up the basics: reference for all language features",
      href: "/docs/manual/latest/introduction",
    },
    {
      imgSrc: "/static/ic_rescript_react@2x.png",
      title: React.string("ReScript + React"),
      descr: "First Class bindings for ReactJS. Developed for small and big ass scale projects.",
      href: "/docs/react/latest/introduction",
    },
    {
      imgSrc: "/static/ic_manual@2x.png",
      title: React.string("Add ReScript to an existing project"),
      descr: "This guide will help you to transfer your project without hassle.",
      href: "/docs/manual/latest/installation#integrate-into-an-existing-js-project",
    },
    {
      imgSrc: "/static/ic_gentype@2x.png",
      title: React.string("TypeScript Integration"),
      descr: "Integrate TypeScript and Flow seamlessly and with ease.",
      href: "/docs/gentype/latest/introduction",
    },
  ]

  let templates = [
    {
      imgSrc: "/static/nextjs_starter_logo.svg",
      title: <>
        <div> {React.string("ReScript & ")} </div>
        <div className="text-gray-40"> {React.string("NextJS")} </div>
      </>,
      descr: "Get started with our our NextJS starter template.",
      href: "https://github.com/ryyppy/rescript-nextjs-template",
    },
    {
      imgSrc: "/static/vitejs_starter_logo.svg",
      title: <>
        <div> {React.string("ReScript & ")} </div>
        <div style={ReactDOM.Style.make(~color="#6571FB", ())}> {React.string("ViteJS")} </div>
      </>,
      descr: "Get started with ViteJS and ReScript.",
      href: "/",
    },
    {
      imgSrc: "/static/nodejs_starter_logo.svg",
      title: <>
        <div> {React.string("ReScript & ")} </div>
        <div className="text-gray-40" style={ReactDOM.Style.make(~color="#699D65", ())}>
          {React.string("NodeJS")}
        </div>
      </>,
      descr: "Get started with ReScript targeting the Node platform.",
      href: "/",
    },
  ]

  @react.component
  let make = () => {
    <section className="bg-gray-90 w-full pb-40">
      <h2
        className="text-gray-10 my-20 text-32 leading-2 font-semibold max-w-md mx-auto text-center">
        {React.string("Carefully curated resources to start or advance your ReScript projects")}
      </h2>
      <div>
        <div className="uppercase text-sm text-center mb-20">
          {React.string("guides and docs")}
        </div>
        <div className="flex justify-between max-w-2xl mx-auto">
          {cards
          ->Js.Array2.map(card =>
            <Next.Link href={card.href}>
              <a
                className="bg-gray-95 px-5 pb-8 relative rounded-xl"
                style={ReactDOM.Style.make(~maxWidth="250px", ())}>
                <img className="h-12 absolute mt-5" src=card.imgSrc />
                <h5 className="text-gray-10 font-semibold mt-32 h-12"> {card.title} </h5>
                <div className="text-gray-40 mt-8 text-sm"> {React.string(card.descr)} </div>
              </a>
            </Next.Link>
          )
          ->React.array}
        </div>
        <div className="uppercase text-sm text-center mb-20 mt-20">
          {React.string("templates")}
        </div>
        <div className="flex justify-between max-w-2xl mx-auto">
          {templates
          ->Js.Array2.map(card =>
            <a
              href={card.href}
              target="_blank"
              className="bg-gray-95 px-5 pb-8 relative rounded-xl"
              style={ReactDOM.Style.make(~maxWidth="250px", ())}>
              <img className="h-12 absolute mt-5" src=card.imgSrc />
              <h5 className="text-gray-10 font-semibold mt-32 h-12"> {card.title} </h5>
              <div className="text-gray-40 mt-8 text-sm"> {React.string(card.descr)} </div>
            </a>
          )
          ->React.array}
        </div>
      </div>
    </section>
  }
}

module QuickInstall = {
  @react.component
  let make = () =>
    <div className="mt-24">
      <h2 className="font-semibold text-42 text-gray-95 text-center">
        {React.string("Quick Install")}
      </h2>
    </div>
}

module Sponsors = {
  @react.component
  let make = () =>
    <div className="mt-24">
      <h2 className="font-semibold text-42 text-gray-95 text-center">
        {React.string("Sponsors")}
      </h2>
    </div>
}

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
                    <div className="mt-12 mb-12 max-w-740 self-center"> <Intro /> </div>
                    <PlaygroundHero />
                    <MainUSP />
                    <TrustedBy />
                    <CuratedResources />
                    <QuickInstall />
                    <Sponsors />
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
