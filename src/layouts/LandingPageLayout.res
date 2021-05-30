/* module Link = Next.Link */

// Copy Brainstorming Gist:
// https://gist.github.com/chenglou/3624a93d63dbd32c4a3d087f9c9e06bc

module CallToActionButton = {
  @react.component
  let make = (~children) =>
    <button
      className="rounded-lg px-8 py-4 inline-block transition-colors duration-300 body-button text-white hover:bg-fire-70  bg-fire  focus:outline-none">
      children
    </button>
}

module Intro = {
  @react.component
  let make = () => {
    <div className="px-4 md:px-0 flex flex-col items-center">
      <h1 className="hl-title text-center" style={ReactDOM.Style.make(~maxWidth="53rem", ())}>
        {React.string("A simple and fast language for JavaScript developers")}
      </h1>
      <h2
        className="body-lg text-center text-gray-60 my-4"
        style={ReactDOM.Style.make(~maxWidth="42rem", ())}>
        {React.string(
          "ReScript looks like JS, acts like JS, and compiles to the highest quality of clean, readable and performant JS, directly runnable in browsers and Node.",
        )}
      </h2>
      <div className="my-4">
        <CallToActionButton> {React.string("Get started")} </CallToActionButton>
      </div>
    </div>
  }
}

module PlaygroundHero = {
  type example = {
    res: string,
    js: string,
  }

  let examples = [
    {
      res: `module Button = {
  @react.component
  let make = (~count: int) => {
    let times = switch count {
    | 1 => "once"
    | 2 => "twice"
    | n => Belt.Int.toString(n) ++ " times"
    }
    let msg = "Click me " ++ times

    <button> {msg->React.string} </button>
  }
}`,
      js: `var React = require("react");

function Playground$Button(Props) {
  var count = Props.count;
  var times = count !== 1 ? (
      count !== 2 ? String(count) + " times" : "twice"
    ) : "once";
  var msg = "Click me " + times;
  return React.createElement("button", undefined, msg);
}

var Button = {
  make: Playground$Button
};

exports.Button = Button;`,
    },
  ]

  @react.component
  let make = () => {
    let (example, setExample) = React.useState(_ => examples->Js.Array2.unsafe_get(0))

    //TODO: Replace background color with real tailwind color
    <section
      className="relative mt-20 bg-gray-10"
      style={ReactDOM.Style.make(~backgroundColor="#FAFBFC", ())}>
      <div className="relative flex justify-center w-full">
        <div
          className="relative sm:rounded-b-xl pt-6 pb-8 sm:px-8 md:px-16 w-full"
          style={ReactDOM.Style.make(~maxWidth="1400px", ())}>
          // Playground widget
          <div
            className="relative z-2 flex flex-col md:flex-row pb-16 bg-gray-90 mx-auto sm:rounded-lg"
            style={ReactDOM.Style.make(~maxWidth="1400px", ())}>
            <div className="md:w-1/2">
              <div className="text-14 text-gray-40 text-center py-3 bg-gray-100">
                {React.string("Written in ReScript")}
              </div>
              <pre className="text-14 px-8 pt-6 pb-12 whitespace-pre-wrap">
                {HighlightJs.renderHLJS(~darkmode=true, ~code=example.res, ~lang="res", ())}
              </pre>
            </div>
            <div className="md:w-1/2">
              <div className="text-14 text-gray-40 py-3 text-center bg-gray-100 sm:rounded-lg">
                {React.string("Compiles to JavaScript")}
              </div>
              <pre className="text-14 px-8 pt-6 pb-12 whitespace-pre-wrap">
                {HighlightJs.renderHLJS(~darkmode=true, ~code=example.js, ~lang="js", ())}
              </pre>
            </div>
          </div>
          <div>
            <Next.Link href={`/try?code=${LzString.compressToEncodedURIComponent(example.res)}}`}>
              <a className="text-12 underline text-gray-60" target="_blank">
                {React.string("Edit this example in Playground")}
              </a>
            </Next.Link>
          </div>
          <div className="hidden md:block">
            <img
              className="absolute z-0 left-0 top-0 -ml-10 -mt-6"
              src="/static/lp/grid.svg"
              style={ReactDOM.Style.make(~height="24rem", ~width="24rem", ())}
            />
            <img
              className="absolute z-0 left-0 top-0 -ml-10 mt-10" src="/static/lp/illu_left.png"
            />
          </div>
          <div className="hidden md:block">
            <img
              className="absolute z-0 right-0 bottom-0 -mb-10 mt-24 -mr-10"
              src="/static/lp/grid.svg"
              style={ReactDOM.Style.make(~height="24rem", ~width="24rem", ())}
            />
            <img
              className="absolute z-3 right-0 bottom-0 -mr-2 mb-10" src="/static/lp/illu_right.png"
            />
          </div>
        </div>
      </div>
    </section>
  }
}

module QuickInstall = {
  module CopyButton = {
    let copyToClipboard: string => bool = %raw(j`
  function(str) {
    try {
      const el = document.createElement('textarea');
      el.value = str;
      el.setAttribute('readonly', '');
      el.style.position = 'absolute';
      el.style.left = '-9999px';
      document.body.appendChild(el);
      const selected =
        document.getSelection().rangeCount > 0 ? document.getSelection().getRangeAt(0) : false;
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
        if (selected) {
          document.getSelection().removeAllRanges();
          document.getSelection().addRange(selected);
        }
        return true;
      } catch(e) {
        return false;
      }
    }
    `)

    type state =
      | Init
      | Copied
      | Failed

    @react.component
    let make = (~code) => {
      let (state, setState) = React.useState(_ => Init)

      let buttonRef = React.useRef(Js.Nullable.null)

      let onClick = evt => {
        ReactEvent.Mouse.preventDefault(evt)
        if copyToClipboard(code) {
          setState(_ => Copied)
        } else {
          setState(_ => Failed)
        }
      }

      React.useEffect1(() => {
        switch state {
        | Copied =>
          open Webapi
          let buttonEl = Js.Nullable.toOption(buttonRef.current)->Belt.Option.getExn

          // Note on this imperative DOM nonsense:
          // For Tailwind transitions to behave correctly, we need to first paint the DOM element in the tree,
          // and in the next tick, add the opacity-100 class, so the transition animation actually takes place.
          // If we don't do that, the banner will essentially pop up without any animation
          let bannerEl = Document.createElement("div")
          bannerEl->Element.setClassName(
            "foobar opacity-0 absolute top-0 -mt-1 -mr-1 px-2 rounded right-0 bg-turtle text-gray-80-tr transition-all duration-500 ease-in-out ",
          )
          let textNode = Document.createTextNode("Copied!")

          bannerEl->Element.appendChild(textNode)
          buttonEl->Element.appendChild(bannerEl)

          let nextFrameId = requestAnimationFrame(() => {
            bannerEl->Element.classList->ClassList.toggle("opacity-0")
            bannerEl->Element.classList->ClassList.toggle("opacity-100")
          })

          let timeoutId = Js.Global.setTimeout(() => {
            buttonEl->Element.removeChild(bannerEl)
            setState(_ => Init)
          }, 2000)

          Some(
            () => {
              cancelAnimationFrame(nextFrameId)
              Js.Global.clearTimeout(timeoutId)
            },
          )
        | _ => None
        }
      }, [state])

      <button
        ref={ReactDOM.Ref.domRef(buttonRef)}
        disabled={state === Copied}
        className="relative"
        onClick>
        <Icon.Copy className="text-gray-40 w-4 h-4 mt-px hover:cursor-pointer hover:text-gray-80" />
      </button>
    }
  }

  module Instructions = {
    let copyBox = text => {
      //TODO: Replace backgroundColor with tailwind equivalent
      <div
        className="flex justify-between p-4 w-full bg-gray-20 border border-gray-10 rounded"
        style={ReactDOM.Style.make(~maxWidth="22rem", ~backgroundColor="#FAFBFC", ())}>
        <span className="font-mono text-14 text-gray-80"> {React.string(text)} </span>
        <CopyButton code=text />
      </div>
    }
    @react.component
    let make = () => {
      <div className="w-full">
        <h2 className="font-bold text-24"> {React.string("Quick Install")} </h2>
        <div className="text-12 pr-10 text-gray-40 my-2 leading-2">
          {React.string(
            "You can quickly add ReScript to your existing JavaScript codebase via npm / yarn:",
          )}
        </div>
        <div className="w-full space-y-2">
          {copyBox("npm install rescript --save-dev")} {copyBox("npx rescript init .")}
        </div>
      </div>
    }
  }

  @react.component
  let make = () => {
    <section className="my-32 sm:px-4 sm:flex sm:justify-center">
      <div className="max-w-1280 flex flex-col w-full">
        <div className="relative px-12">
          <div style={ReactDOM.Style.make(~maxWidth="29rem", ())}>
            <p
              className="relative z-1 space-y-12 text-gray-80 font-semibold text-24 md:text-32 leading-2">
              <span className="bg-fire-5 rounded-md border-2 border-fire-10 h-10 w-full">
                {React.string(`Everything you wan`)}
              </span>
              {React.string(`t from JavaScript, minus the parts
          you don't need.`)}
            </p>
          </div>
        </div>
        <div className="w-full pl-12 mt-12 flex flex-col lg:flex-row justify-between">
          <p
            style={ReactDOM.Style.make(~maxWidth="29rem", ())}
            className="relative z-1 text-gray-80 font-semibold text-24 md:text-32 leading-2">
            {React.string(`ReScript is easy to pick up for JavaScript developers,
          and helps shipping products with confidence.`)}
          </p>
          <div
            className="mt-16 lg:mt-0 self-end" style={ReactDOM.Style.make(~maxWidth="25rem", ())}>
            <Instructions />
          </div>
        </div>
      </div>
    </section>
  }
}

// Main unique selling points
module MainUSP = {
  module Item = {
    @react.component
    let make = (~caption: string, ~title: React.element, ~paragraph: React.element) => {
      <div className="flex flex-col lg:flex-row lg:justify-between w-full">
        <div style={ReactDOM.Style.make(~maxWidth="30rem", ())}>
          <div className="hl-overline text-gray-20 mb-4"> {React.string(caption)} </div>
          <h3
            className="text-gray-10 mb-4 text-32 font-semibold"
            style={ReactDOM.Style.make(~maxWidth="25rem", ())}>
            title
          </h3>
          <div className="flex"> <div className="text-gray-30 text-16 pr-8"> paragraph </div> </div>
        </div>
        <div
          className="w-full bg-gray-90 rounded-lg flex mt-16 lg:mt-0 items-center justify-center"
          style={ReactDOM.Style.make(
            ~maxWidth="31rem",
            ~borderRadius="8px",
            ~minHeight="10rem",
            ~boxShadow="-11px 3px 30px -5px rgba(244,100,106,0.15)",
            (),
          )}>
          {React.string("video of a fast build")}
        </div>
      </div>
    }
  }

  let item1 =
    <Item
      caption="Fast and simple"
      title={React.string("The fastest build system on the web")}
      paragraph={React.string(`ReScript cares about a consistent and fast feedback loop for any
            codebase size. No need for memory hungry build processes, and no
            corrupted caches. Switch branches as you please without worrying
            about stale caches or wrong type information.`)}
    />

  let item2 =
    <Item
      caption="A robust type system"
      title={<span
        className="text-transparent bg-clip-text bg-gradient-to-r from-berry-dark-50 to-fire-50">
        {React.string("Type Better")}
      </span>}
      paragraph={React.string(` Every ReScript app is fully typed and provides
      correct type information to any given value. We prioritize simpler types
      / discourage complex types for the sake of clarity and easy debugability.
      No \`any\`, no magic types, no surprise \`undefined\`.
      `)}
    />

  let item3 =
    <Item
      caption="Seamless JS Integration"
      title={<>
        <span className="text-orange-dark"> {React.string("The familiar JS ecosystem")} </span>
        {React.string(" at your fingertips")}
      </>}
      paragraph={React.string(`Use any library from javascript, export rescript
      libraries to javascript, generate typescript and flow types, etc. It's
      like you've never left the good parts of javascript at all.`)}
    />

  @react.component
  let make = () => {
    <section
      className="relative flex justify-center w-full bg-gray-90 px-4 sm:px-32 pb-32 overflow-hidden"
      style={ReactDOM.Style.make(~minHeight="37rem", ())}>
      <div className="relative max-w-1280 z-2 pt-24 w-full space-y-32">
        item1 item2 item3
      </div>
      <svg
        className="absolute z-1 right-0 top-0 text-fire-30"
        viewBox="0 0 100 100"
        preserveAspectRatio="none">
        <polygon className="fill-current" points="80,0 100,0 100,100" />
      </svg>
    </section>
  }
}

/* module SubtleButton = { */
/* @react.component */
/* let make = (~children) => */
/* <button */
/* className="transition-colors duration-200 inline-block text-16 text-fire rounded border-2 border-fire-10 hover:bg-fire-10 px-5 py-2"> */
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
        className="text-48 text-gray-42 tracking-tight leading-2 font-semibold text-center max-w-576 mx-auto">
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
      <div className="text-center mt-16 text-14"> {React.string(`and many more…`)} </div>
      <div
        className="mt-10 max-w-320 overflow-hidden opacity-50"
        style={ReactDOM.Style.make(~maxHeight="6rem", ())}>
        <img className="w-full h-full" src="/static/lp/grid.svg" />
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
    <section className="bg-gray-100 w-full pb-40">
      <h2
        className="text-gray-10 my-20 text-48 leading-2 font-semibold max-w-md mx-auto text-center">
        {React.string("Carefully curated resources")}
      </h2>
      <div>
        <div className="uppercase text-14 text-center mb-20">
          {React.string("guides and docs")}
        </div>
        <div className="flex justify-between max-w-1280 mx-auto">
          {cards
          ->Belt.Array.mapWithIndex((i, card) =>
            <Next.Link key={Belt.Int.toString(i)} href={card.href}>
              <a
                className="bg-gray-90 px-5 pb-8 relative rounded-xl"
                style={ReactDOM.Style.make(~maxWidth="296px", ())}>
                <img className="h-12 absolute mt-5" src=card.imgSrc />
                <h5 className="text-gray-10 font-semibold mt-32 h-12"> {card.title} </h5>
                <div className="text-gray-40 mt-8 text-14"> {React.string(card.descr)} </div>
              </a>
            </Next.Link>
          )
          ->React.array}
        </div>
        <div className="uppercase text-14 text-center mb-20 mt-20">
          {React.string("templates")}
        </div>
        <div className="flex justify-between max-w-1280 mx-auto">
          {templates
          ->Belt.Array.mapWithIndex((i, card) =>
            <a
              key={Belt.Int.toString(i)}
              href={card.href}
              target="_blank"
              className="bg-gray-90 px-5 pb-8 relative rounded-xl"
              style={ReactDOM.Style.make(~maxWidth="406px", ())}>
              <img className="h-12 absolute mt-5" src=card.imgSrc />
              <h5 className="text-gray-10 font-semibold mt-32 h-12"> {card.title} </h5>
              <div className="text-gray-40 mt-8 text-14"> {React.string(card.descr)} </div>
            </a>
          )
          ->React.array}
        </div>
      </div>
    </section>
  }
}

module Sponsors = {
  @react.component
  let make = () =>
    <div className="mt-24">
      <h2 className="hl-1 text-center"> {React.string("Sponsors")} </h2>
    </div>
}

@react.component
let make = (~components=Markdown.default, ~children) => {
  let overlayState = React.useState(() => false)

  <>
    <Meta />
    <div className="mt-4 xs:mt-16">
      <div className="text-gray-80 text-18">
        <Navigation overlayState />
        <div className="absolute top-16 w-full">
          <div className="relative overflow-hidden pb-32">
            <main className="mt-10 min-w-320 lg:align-center w-full">
              <Mdx.Provider components>
                <div className="">
                  <div className="w-full">
                    <div className="mt-12 mb-12"> <Intro /> </div>
                    <PlaygroundHero />
                    <QuickInstall />
                    <MainUSP />
                    <TrustedBy />
                    <CuratedResources />
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
