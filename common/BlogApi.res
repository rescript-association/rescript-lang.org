// Same design as in the official nextjs blog starter template
// https://github.com/zeit/next.js/blob/canary/examples/blog-starter/lib/api.js

/*
    BlogApi gives access to the data within the _blogposts directory.

    The _blogposts content is treated as a flat directory. There is a
    set of whitelisted directories (for each category) to help declutter
    huge file masses.

    Every filename within _blogposts must be unique, even when nested in
    different directories. The filename will be sluggified, that means that e.g.
    for the filepath "_blogposts/compiler/my-post.mdx":
    - slug = "my-post"
    - fullslug = "compiler/my-post"

    The reason for the flat hierarchy is that we want to keep a flat URL
    hierarchy with `https://rescript-lang.org/blog/[some-slug]`, without carrying
    over the full subdirectory hierarchy. This allows us to restructure
    internally more easily without breaking permalinks.

    This module offers functionality to query all slug information, and even
    gives access to fully parsed blog posts with frontmatter data etc.

    See `pages/blog.re` for more context on why we need this API.
 */

// Manual mapping between slugs and actual file
// { [slug: string] : [filepath: string] }
// The filepath is relative within _blogposts
let index: Js.Dict.t<string> = %raw("require('../index_data/blog_posts.json')")

module GrayMatter = {
  type output = {
    data: Js.Json.t,
    content: string,
  }

  @bs.module("gray-matter") external matter: string => output = "default"
}

let postsDirectory = Node.Path.join2(Node.Process.cwd(), "./_blogposts")

type postData = {
  slug: string,
  content: string,
  fullslug: string,
  archived: bool,
  frontmatter: Js.Json.t,
}

let getFullSlug = (slug: string) =>
  Belt.Option.map(index->Js.Dict.get(slug), relPath =>
    Js.String2.replaceByRe(relPath, %re("/\\.mdx?/"), "")
  )

let getPostBySlug = (slug: string) => {
  let relPath = index->Js.Dict.unsafeGet(slug)

  let fullslug = Js.String2.replaceByRe(relPath, %re("/\\.mdx?/"), "")

  let fullPath = Node.Path.join2(postsDirectory, fullslug ++ ".mdx")

  // TODO: We need to handle handle archived files differently later on

  if Node.Fs.existsSync(fullPath) {
    let fileContents = Node.Fs.readFileSync(fullPath, #utf8)
    let {GrayMatter.data: data, content} = GrayMatter.matter(fileContents)

    // We currently derive the archived state from the directory hierarchy
    let archived = Js.String2.includes(fullPath, "/archive/")

    Some({slug: slug, fullslug: fullslug, content: content, frontmatter: data, archived: archived})
  } else {
    None
  }
}

let getAllPosts = () => Js.Dict.keys(index)->Belt.Array.reduce([], (acc, slug) => {
    switch getPostBySlug(slug) {
    | Some(post) => Js.Array2.push(acc, post)->ignore
    | None => ()
    }
    acc
  })

module RssFeed = {
  // Module inspired by
  // https://gist.github.com/fredrikbergqvist/36704828353ebf5379a5c08c7583fe2d

  // Example reference example for RSS 2.0:
  // http://static.userland.com/gems/backend/rssTwoExample2.xml

  // TODO:
  // In case the pubDate formatting doesn't work with toUTCString,
  // we can port something like this:
  // https://github.com/tjconcept/js-rfc822-date

  type item = {
    title: string,
    href: string,
    description: string,
    pubDate: Js.Date.t,
  }

  // TODO: This is yet again a dirty approach to prevent UTC to substract too many
  //       hours of my local timezone so it does end up on another day, so we set the hours
  //       to 15 o clock. We need to reconsider the way we parse blog article dates,
  //       since the dates should always be parsed from a single timezone perspective
  let dateToUTCString = date => {
    date->Js.Date.setHours(15.0)->ignore
    date->Js.Date.toUTCString
  }

  // Retrieves the most recent [max] blog post feed items
  let getLatest = (~max=10, ~baseUrl="https://rescript-lang.org", ()): array<item> => {
    let authors = BlogFrontmatter.Author.getAllAuthors()
    let items = getAllPosts()->Belt.Array.reduce([], (acc, next) =>
      switch BlogFrontmatter.decode(~authors, next.frontmatter) {
      | Ok(fm) =>
        let description = Js.Null.toOption(fm.description)->Belt.Option.getWithDefault("")
        let item = {
          title: fm.title,
          href: baseUrl ++ ("/blog/" ++ next.slug),
          description: description,
          pubDate: DateStr.toDate(fm.date),
        }

        Belt.Array.concat(acc, [item])
      | Error(_) => acc
      }
    )->Js.Array2.sortInPlaceWith((item1, item2) => {
      let v1 = item1.pubDate->Js.Date.valueOf
      let v2 = item2.pubDate->Js.Date.valueOf
      if v1 === v2 {
        0
      } else if v1 > v2 {
        -1
      } else {
        1
      }
    })->Js.Array2.slice(~start=0, ~end_=max)
    items
  }

  let toXmlString = (~siteTitle="ReScript Blog", ~siteDescription="", items: array<item>) => {
    let latestPubDateElement = Belt.Array.get(items, 0)->Belt.Option.map(item => {
      let latestPubDateStr = item.pubDate->dateToUTCString
      j`<lastBuildDate>$latestPubDateStr</lastBuildDate>`
    })->Belt.Option.getWithDefault("")

    let itemsStr = Belt.Array.reduce(items, "", (acc, item) => {
      let {title, pubDate, description, href} = item

      let descriptionElement = switch description {
      | "" => ""
      | desc => j`<description>
        <![CDATA[$desc]]>
        </description>
          `
      }

      // TODO: convert pubdate to string
      let dateStr = pubDate->dateToUTCString
      j`${acc}
      <item>
        <title> <![CDATA[$title]]></title>
        <link> $href </link>
        <guid> $href </guid>
        $descriptionElement

        <pubDate>$dateStr</pubDate>

    </item>`
    })

    let ret = j`<?xml version="1.0" encoding="utf-8" ?>
  <rss version="2.0">
    <channel>
        <title>$siteTitle</title>
        <link>https://rescript-lang.org</link>
        <description>$siteDescription</description>
        <language>en</language>
        $latestPubDateElement
        $itemsStr

    </channel>
  </rss>` //rescript-lang.org</link>

    ret
  }
}
