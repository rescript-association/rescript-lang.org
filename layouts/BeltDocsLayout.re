%raw
"require('../styles/main.css')";

open Util.ReactStuff;
open Text;
module Link = Next.Link;

module Navigation = {
  let link = "no-underline text-inherit hover:text-white";
  [@react.component]
  let make = () =>
    <nav className="p-2 flex items-center text-sm bg-bs-purple text-white-80">
      <Link href="/belt_docs">
        <a className="flex items-center w-2/3">
          <img
            className="h-12"
            src="https://res.cloudinary.com/dmm9n7v9f/image/upload/v1568788825/Reason%20Association/reasonml.org/bucklescript_bqxwee.svg"
          />
          <span className="text-2xl ml-2 font-montserrat text-white-80 hover:text-white">"Belt"->s</span>
        </a>
      </Link>
      <div className="flex w-1/3 justify-end">
        <Link href="/">
          <a className={link ++ " mx-2"}>
            "ReasonML"->s
          </a>
        </Link>
        <a
          href="https://github.com/reason-association/reasonml.org"
          rel="noopener noreferrer"
          target="_blank"
          className=link>
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
