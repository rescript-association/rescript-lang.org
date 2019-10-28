open Util.ReactStuff;
module Link = Next.Link;

let link = "no-underline text-inherit hover:text-white text-white-80";
let activeLink = "no-underline text-inherit font-bold text-white";

let linkOrActiveLink = (~target, ~route) =>
  target === route ? activeLink : link;

[@react.component]
let make = (~route="/", ~theme=`Reason) => {
  let theme = ColorTheme.toCN(theme);
  <nav
    id="header"
    className={
      "fixed z-10 top-0 p-2 w-full h-16 bg-t-primary shadow flex items-center text-ghost-white text-sm "
      ++ theme
    }>
    <Link href="/">
      <a className="flex items-center pl-10 w-1/5">
        <span className="text-xl ml-2 font-black text-white">
          "Reason"->s
        </span>
      </a>
    </Link>
    <div className="flex mx-4 text-ghost-white justify-between ml-auto">
      <Link href="/api">
        <a className={linkOrActiveLink(~target="/api", ~route)}> "API"->s </a>
      </Link>
    </div>
    <div
      className="ml-6 flex w-1/6 px-3 h-10 max-w-sm rounded-lg text-white bg-light-grey-20 content-center items-center">
      <img
        src="/static/ic_search_small.svg"
        className="mr-3"
        ariaHidden=true
      />
      <input
        type_="text"
        className="bg-transparent placeholder-ghost-white block focus:outline-none w-full ml-2"
        placeholder="Search not ready yet..."
      />
    </div>
    <a
      href="https://github.com/reason-association/reasonml.org"
      rel="noopener noreferrer"
      target="_blank"
      className={link ++ " align-middle mx-6"}>
      "Github"->s
    </a>
  </nav>;
};

/*
     Used specifically for Api docs browsing.
     Difference here is the prominent Searchbar in the center
     and a version info shown on the side
 */
module ApiDocs = {
  [@react.component]
  let make = (~route: string, ~theme=`Reason, ~versionInfo=?) => {
    let theme = ColorTheme.toCN(theme);

    <nav
      id="header"
      className={
        "fixed z-10 top-0 p-2 w-full h-16 bg-t-primary shadow flex items-center text-ghost-white text-sm "
        ++ theme
      }>
      <Link href="/">
        <a className="flex items-center pl-10 w-1/5">
          <span className="text-xl ml-2 font-black text-white">
            "Reason"->s
          </span>
        </a>
      </Link>
      <div
        className="ml-6 flex w-3/5 px-3 h-10 max-w-sm rounded-lg text-white bg-light-grey-20 content-center items-center w-2/3">
        <img
          src="/static/ic_search_small.svg"
          className="mr-3"
          ariaHidden=true
        />
        <input
          type_="text"
          className="bg-transparent placeholder-ghost-white block focus:outline-none w-full ml-2"
          placeholder="Search not ready yet..."
        />
      </div>
      <div className="flex mx-4 text-ghost-white justify-between ml-auto">
        <Link href="/api">
          <a className={linkOrActiveLink(~target="/api", ~route)}>
            "API"->s
          </a>
        </Link>
        <a
          href="https://github.com/reason-association/reasonml.org"
          rel="noopener noreferrer"
          target="_blank"
          className={link ++ " align-middle ml-6"}>
          "Github"->s
        </a>
        {switch (versionInfo) {
         | Some(version) =>
           <a
             href="https://github.com/BuckleScript/bucklescript/releases"
             rel="noopener noreferrer"
             target="_blank"
             className="bg-light-grey-20 leading-normal ml-6 px-1 rounded text-light-grey text-xs">
             version->s
           </a>
         | None => React.null
         }}
      </div>
    </nav>;
  };
};
