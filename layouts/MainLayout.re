%raw
"require('../styles/main.css')";

module Link = Next.Link;

[@react.component]
let make = (~children, ~components=Mdx.Components.default) => {
  let router = Next.Router.useRouter();
  let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
  let (isOpen, setIsOpen) = React.useState(() => false);

  <>
    <Meta />
    <div className="mb-32 mt-16">
      <div className="w-full text-night font-base">
        <Navigation
          isOverlayOpen=isOpen
          toggle={() => setIsOpen(prev => !prev)}
          route={router##route}
        />
        <div className="flex justify-center">
          <main
            style=minWidth
            className="mt-32 lg:align-center w-full px-4 max-w-xl " /*++ (isOpen ? " hidden" : "")*/>
            <Mdx.Provider components>
              <div className="w-full max-w-lg"> children </div>
            </Mdx.Provider>
          </main>
        </div>
      </div>
    </div>
  </>;
};
