%raw
"require('../styles/main.css')";

open Util.ReactStuff;
open Text;
module Link = Next.Link;

/*
    We use some custom markdown styling for the Belt docs to make
    it easier on the eyes
 */
module BeltMd = {
  external elementAsString: React.element => string = "%identity";
  module Anchor = {
    [@react.component]
    let make = (~id: string) => {
      let style =
        ReactDOMRe.Style.make(~position="absolute", ~top="-7rem", ());
      <span style={ReactDOMRe.Style.make(~position="relative", ())}>
        <a style id />
      </span>;
    };
  };

  module H2 = {
    [@react.component]
    let make = (~children) => {
      <>
        // Here we know that children is always a string (## headline)
        <Anchor id={children->elementAsString} />
        <h2
          className="text-xl leading-3 font-montserrat font-medium text-main-black">
          children
        </h2>
      </>;
    };
  };

  let components =
    Mdx.Components.t(
      ~p=Md.P.make,
      ~li=Md.Li.make,
      ~h1=H1.make,
      ~h2=H2.make,
      ~h3=H3.make,
      ~h4=H4.make,
      ~h5=H5.make,
      ~ul=Md.Ul.make,
      ~ol=Md.Ol.make,
      ~a=Md.A.make,
      ~pre=Md.Pre.make,
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

module Sidebar = {
  // Navigation point information
  type moduleNav = {
    name: string,
    href: string,
  };

  type category = {
    name: string,
    items: array(moduleNav),
  };

  let overviewNavs = [|{name: "Introduction", href: "/belt_docs"}|];

  let setNavs = [|
    {name: "HashSet", href: "/belt_docs/hash-set"},
    {name: "HashSetInt", href: "/belt_docs/hash-set-int"},
    {name: "HashSetString", href: "/belt_docs/hash-set-string"},
    {name: "Set", href: "/belt_docs/set"},
    {name: "SetDict", href: "/belt_docs/set-dict"},
    {name: "SetInt", href: "/belt_docs/set-int"},
    {name: "SetString", href: "/belt_docs/set-string"},
  |];

  let mapNavs = [|
    {name: "HashMap", href: "/belt_docs/hash-map"},
    {name: "HashMapInt", href: "/belt_docs/hash-map-int"},
    {name: "HashMapString", href: "/belt_docs/hash-map-string"},
    {name: "Map", href: "/belt_docs/map"},
    {name: "MapDict", href: "/belt_docs/map-dict"},
    {name: "MapInt", href: "/belt_docs/map-int"},
    {name: "MapString", href: "/belt_docs/map-string"},
  |];

  let mutableCollectionsNavs = [|
    {name: "MutableMap", href: "/belt_docs/mutable-map"},
    {name: "MutableMapInt", href: "/belt_docs/mutable-map-int"},
    {name: "MutableMapString", href: "/belt_docs/mutable-map-string"},
    {name: "MutableQueue", href: "/belt_docs/mutable-queue"},
    {name: "MutableSet", href: "/belt_docs/mutable-set"},
    {name: "MutableSetInt", href: "/belt_docs/mutable-set-int"},
    {name: "MutableSetString", href: "/belt_docs/mutable-set-string"},
    {name: "MutableStack", href: "/belt_docs/mutable-stack"},
  |];

  let basicNavs = [|
    {name: "List", href: "/belt_docs/list"},
    {name: "Array", href: "/belt_docs/array"},
    {name: "Float", href: "/belt_docs/float"},
    {name: "Int", href: "/belt_docs/int"},
    {name: "Range", href: "/belt_docs/range"},
    {name: "Id", href: "/belt_docs/id"},
    {name: "Option", href: "/belt_docs/option"},
    {name: "Result", href: "/belt_docs/result"},
  |];

  let sortNavs = [|
    {name: "SortArray", href: "/belt_docs/sort-array"},
    {name: "SortArrayInt", href: "/belt_docs/sort-array-int"},
    {name: "SortArrayString", href: "/belt_docs/sort-array-string"},
  |];

  let utilityNavs = [|{name: "Debug", href: "/belt_docs/debug"}|];

  let categories = [|
    {name: "Overview", items: overviewNavs},
    {name: "Basics", items: basicNavs},
    {name: "Set", items: setNavs},
    {name: "Map", items: mapNavs},
    {name: "Mutable Collections", items: mutableCollectionsNavs},
    {name: "Sort Collections", items: sortNavs},
    {name: "Utilities", items: utilityNavs},
  |];

  let categoryToElement = (category: category): React.element => {
    <div key={category.name}>
      <Overline> category.name->s </Overline>
      <ul className="mr-4">
        {category.items
         ->Belt.Array.map(m =>
             <li key={m.name} className="font-bold lg:font-normal">
               <Link href={m.href}> <a> m.name->s </a> </Link>
             </li>
           )
         ->ate}
      </ul>
    </div>;
  };

  [@react.component]
  let make = () => {
    <div> {categories->Belt.Array.map(categoryToElement)->ate} </div>;
  };
};

[@react.component]
let make = (~children) => {
  let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
  <div className="mb-32">
    <div className="max-w-4xl w-full lg:w-3/4 text-gray-900 font-base">
      <Navigation />
      <main style=minWidth className="flex mt-12 mx-4">
        <Sidebar />
        <Mdx.Provider components=BeltMd.components>
          <div className="pl-8 w-3/4"> children </div>
        </Mdx.Provider>
      </main>
    </div>
  </div>;
};
