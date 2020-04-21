module Link = Next.Link;

[@react.component]
let make = (~children, ~components=Markdown.default) => {
  let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
  let overlayState = React.useState(() => false);

  <>
    <Meta />
    <div className="mb-32 mt-16">
      <div className="text-night text-lg">
        <Navigation overlayState/>
        <div className="flex justify-center overflow-hidden">
          <main
            style=minWidth
            className="mt-32 lg:align-center w-full px-8 lg:px-0 max-w-1280 " /*++ (isOpen ? " hidden" : "")*/>
            <Mdx.Provider components>
              children
            </Mdx.Provider>
          </main>
        </div>
      </div>
    </div>
  </>;
};
