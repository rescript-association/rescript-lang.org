open Util.ReactStuff;
module Link = Next.Link;

module Card = {
  [@react.component]
  let make = (~title: string, ~hrefs: array((string, string))) => {
    let style = ReactDOMRe.Style.make(~maxWidth="21rem", ());
    <div
      style
      className="border border-snow-dark bg-snow-light px-5 py-8 rounded-lg">
      <h2 className="font-bold text-21 mb-4"> title->s </h2>
      <ul>
        {Belt.Array.map(hrefs, ((text, href)) => {
           <li key="text" className="text-16 mb-1 last:mb-0">
             <Link href> <Markdown.A href> text->s </Markdown.A> </Link>
           </li>
         })
         ->ate}
      </ul>
    </div>;
  };
};

[@react.component]
let default = () => {
  let router = Next.Router.useRouter();
  let url = router.route->Url.parse;

  let version =
    switch (url.version) {
    | Url.Latest => "v8"
    | NoVersion => "?"
    | Version(other) => other
    };

  let languageManual = [|
    ("Overview", "/docs/manual/latest/introduction"),
    ("Language Features", "/docs/manual/latest/overview"),
    ("JS Interop", "/docs/manual/latest/embed-raw-javascript"),
    ("Build System", "/docs/manual/latest/build-overview"),
  |];

  let ecosystem = [|
    ("GenType", "/docs/gentype/latest/introduction"),
    ("ReasonReact", "/docs/reason-react/latest/introduction"),
    ("Reanalyze", "https://github.com/reason-association/reanalyze"),
  |];

  <>
    <Meta title="Overview | ReScript Documentation" />
    <div>
      // <div
      //   className="inline-block rounded px-2 bg-fire mb-4 tracking-tight overflow-x-auto text-14 text-white">
      //   {("Revision: " ++ version)->s}
      // </div>
      <div className="mb-6">
      </div>
      <Markdown.H1> "Docs"->s </Markdown.H1>
    </div>
    <div className="grid grid-cols-1 xs:grid-cols-2 gap-8">
      <Card title="Language Manual" hrefs=languageManual />
      <Card title="Ecosystem" hrefs=ecosystem />
    </div>
  </>;
};
