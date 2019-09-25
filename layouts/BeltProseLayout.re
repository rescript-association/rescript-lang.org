%raw
"require('../styles/main.css')";

%raw
{|
let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);
|};

open Util.ReactStuff;
open Text;
module Link = Next.Link;

/*
This layout is used for structured prose text with proper H2 headings.
We cannot really use the same layout as with the Api docs, since these
have different semantic styling and do things such as hiding the text
of H2 nodes.
*/

module Md = {
  module Anchor = {
    [@react.component]
    let make = (~id: string) => {
      let style =
        ReactDOMRe.Style.make(~position="absolute", ~top="-7rem", ());
      <span style={ReactDOMRe.Style.make(~position="relative", ())}>
        <a
          className="mr-2 text-main-lighten-65 hover:cursor-pointer"
          href={"#" ++ id}>
          {j|#|j}->s
        </a>
        <a style id />
      </span>;
    };
  };

  module H2 = {
    [@react.component]
    let make = (~children) => {
      <>
        // Here we know that children is always a string (## headline)
        <h2
          className="mt-12 text-xl leading-3 font-montserrat font-medium text-main-black">
          <Anchor id={children->Unsafe.elementAsString} />
          children
        </h2>
      </>;
    };
  };

  module Pre = {
    [@react.component]
    let make = (~children) => {
      <pre className="mt-2 mb-4 block"> children </pre>;
    };
  };

  module P = {
    [@react.component]
    let make = (~children) => {
      <p className="text-base mt-3 leading-4 text-main-lighten-15">
        children
      </p>;
    };
  };

  let components =
    Mdx.Components.t(
      ~p=P.make,
      ~li=Md.Li.make,
      ~h1=H1.make,
      ~h2=H2.make,
      ~h3=H3.make,
      ~h4=H4.make,
      ~h5=H5.make,
      ~ul=Md.Ul.make,
      ~ol=Md.Ol.make,
      ~a=Md.A.make,
      ~pre=Pre.make,
      ~inlineCode=Md.InlineCode.make,
      ~code=Md.Code.make,
      (),
    );
};

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
          <span
            className="text-2xl ml-2 font-montserrat text-white-80 hover:text-white">
            "Belt"->s
          </span>
        </a>
      </Link>
      <div className="flex w-1/3 justify-end">
        <Link href="/">
          <a className={link ++ " mx-2"}> "ReasonML"->s </a>
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

module Sidebar = BeltDocsLayout.Sidebar;

[@react.component]
let make = (~children) => {
  <BeltDocsLayout components=Md.components> children </BeltDocsLayout>;
};
