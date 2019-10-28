%raw
"require('../styles/main.css')";

module Link = Next.Link;

[@react.component]
let make = (~children) => {
  let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
  <div className="mb-32">
    <div className="max-w-4xl w-full lg:w-3/4 text-gray-900 font-base">
      <Navigation />
      <main style=minWidth className="mt-24 mx-4 max-w-lg">
        <Mdx.Provider components=Mdx.Components.default>
          children
        </Mdx.Provider>
      </main>
    </div>
  </div>;
};
