%raw
"require('../styles/main.css')";

open Util.ReactStuff;
module Link = Next.Link;

module Navigation = {
  [@react.component]
  let make = () =>
    <nav className="p-2 flex items-center text-sm">
      <Link href="/">
        <a className="flex items-center w-2/3">
          <img
            className="h-16"
            src="https://res.cloudinary.com/dmm9n7v9f/image/upload/v1561718393/Reason%20Association/logo/ReasonAssocMain_red_ax30rd.svg"
          />
        </a>
      </Link>
      <div className="flex w-1/3 justify-end">
        <Link href="/belt_docs">
          <a className={Text.Link.inline ++ " mx-2"}>
            "Belt Documentation"->s
          </a>
        </Link>
        <a
          href="https://github.com/reason-association/reasonml.org"
          rel="noopener noreferrer"
          target="_blank"
          className=Text.Link.inline>
          "Github"->s
        </a>
      </div>
    </nav>;
};

[@react.component]
let make = (~children) => {
  let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
  <div className="mb-32">
    <div className="max-w-4xl w-full lg:w-3/4 text-gray-900 font-base">
      <Navigation />
      <main style=minWidth className="mt-12 mx-4 max-w-lg">
        <Mdx.Provider components=Mdx.Components.default>
          children
        </Mdx.Provider>
      </main>
    </div>
  </div>;
};
