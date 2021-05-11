type postData = {
  // slug: string,
  content: string,
  fullslug: string,
  archived: bool,
  frontmatter: Js.Json.t,
}

let getAllPosts: unit => array<postData>
// let getFullSlug: string => option<string>
let getSlugFromPath: string => string

module RssFeed: {
  type item = {
    title: string,
    href: string,
    description: string,
    pubDate: Js.Date.t,
  }
  let getLatest: (~max: int=?, ~baseUrl: string=?, unit) => array<item>
  let toXmlString: (~siteTitle: string=?, ~siteDescription: string=?, array<item>) => string
}
