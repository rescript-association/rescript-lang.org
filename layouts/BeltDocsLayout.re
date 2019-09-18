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

  let mutableMapNavs = [|
    {name: "MutableMap", href: "/belt_docs/mutable-map"},
    {name: "MutableMapInt", href: "/belt_docs/mutable-map-int"},
    {name: "MutableMapString", href: "/belt_docs/mutable-map-string"},
  |];

  let mutableCollectionsNavs = [|
    {name: "MutableSet", href: "/belt_docs/mutable-set"},
    {name: "MutableSetInt", href: "/belt_docs/mutable-set-int"},
    {name: "MutableSetString", href: "/belt_docs/mutable-set-string"},
    {name: "MutableQueue", href: "/belt_docs/mutable-queue"},
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
    {name: "Set", items: setNavs},
    {name: "Map", items: mapNavs},
    {name: "Mutable Map", items: mutableMapNavs},
    {name: "Basics", items: basicNavs},
    {name: "Sort Collections", items: sortNavs},
    {name: "Mutable Collections", items: mutableCollectionsNavs},
    {name: "Utility", items: utilityNavs},
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
      <main style=minWidth className="flex justify-between mt-12 mx-4">
        <Sidebar />
        <Mdx.Provider components=Mdx.Components.default>
          <div className="pl-5 w-full"> children </div>
        </Mdx.Provider>
      </main>
    </div>
  </div>;
};
