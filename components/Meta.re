open Util.ReactStuff;
module Head = Next.Head;

/*
    canonical: Set a canonical URL pointing to the original content.
 */
[@react.component]
let make = (~canonical=?, ~title=?) => {
  <Head>
    {switch (title) {
     | Some(title) => <title> title->s </title>
     | None => React.null
     }}
    <meta charSet="ISO-8859-1" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, minimal-ui"
    />
    {switch (canonical) {
     | Some(href) => <link href rel="canonical" />
     | None => React.null
     }}
  </Head>;
};
