open Util.ReactStuff;
module Link = Next.Link;

[@react.component]
let make = (~children, ~components=Markdown.default) => {
  let overlayState = React.useState(() => false);
  let router = Next.Router.useRouter();
  let url = router.route->Url.parse;

  let version =
    switch (url.version) {
    | Url.Latest => "v8"
    | NoVersion => "?"
    | Version(other) => other
    };

  <>
    <div className="mb-32 mt-4 xs:mt-16">
      <div className="text-night text-lg">
      <Meta title="Overview | ReScript Documentation"/>
        <Navigation overlayState />
        <div className="flex justify-center overflow-hidden">
          <main
            className="mt-32 min-w-320 lg:align-center w-full px-4 md:px-8 lg:px-0 max-w-1280 " /*++ (isOpen ? " hidden" : "")*/>
            <div
              className="inline-block rounded px-2 bg-fire mb-4 tracking-tight overflow-x-auto text-14 text-white">
              {("Revision: " ++ version)->s}
            </div>
            <Mdx.Provider components> children </Mdx.Provider>
          </main>
        </div>
      </div>
    </div>
  </>;
};
