open Util.ReactStuff;
module Head = Next.Head;

let ogImgDefault = "https://res.cloudinary.com/dmm9n7v9f/image/upload/v1588077512/Reason%20Association/reasonml.org/reasonml-org-social-default_re6vor.jpg";

/*
    canonical: Set a canonical URL pointing to the original content.
 */
[@react.component]
let make =
    (
      ~siteName="Reason Documentation",
      ~keywords: array(string)=[||],
      ~description="The Reason language and ecosystem docs",
      ~canonical=?,
      ~title=?,
      ~ogLocale="en_US",
      ~ogSiteName=?,
      ~ogDescription=description,
      ~ogTitle=?,
      ~ogImage=ogImgDefault,
    ) => {
  let (title, fullTitle) =
    switch (title) {
    | None
    | Some("") => (siteName, siteName)
    | Some(title) => (title, title ++ " | " ++ siteName)
    };

  let ogSiteName =
    switch (ogSiteName) {
    | Some(ogSiteName) => ogSiteName
    | None => siteName
    };

  let ogTitle =
    switch (ogTitle) {
    | Some(ogTitle) => ogTitle
    | None => fullTitle
    };

  <Head>
    <title> fullTitle->s </title>
    <meta charSet="ISO-8859-1" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, minimal-ui"
    />
    <meta name="description" content=description />
    <meta name="keywords" content={Js.Array2.joinWith(keywords, ",")} />
    {switch (canonical) {
     | Some(href) => <link href rel="canonical" />
     | None => React.null
     }}
    <link rel="icon" sizes="16x16 32x32 64x64" href="/static/favicon.ico" />
    /* OG link preview meta data */
    <meta property="og:site_name" content=ogSiteName />
    <meta property="og:locale" content=ogLocale />
    <meta property="og:title" content=ogTitle />
    <meta property="og:description" content=ogDescription />
    <meta property="og:image" content=ogImage />
    /* Twitter Meta */
    <meta name="twitter:title" content=title />
    <meta name="twitter:description" content=description />
    <meta name="twitter:site" content="@reasonml" />
    <meta name="twitter:creator" content="@ReasonAssoc" />
    <meta property="og:image:type" content="image/jpeg" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta property="twitter:image" content=ogImage />
  </Head>;
};
