type postData = {
  path: string,
  archived: bool,
  frontmatter: BlogFrontmatter.t,
}

let getAllPosts: unit => array<postData>
let blogPathToSlug: string => string

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
