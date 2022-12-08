// Same design as in the official nextjs blog starter template
// https://github.com/zeit/next.js/blob/canary/examples/blog-starter/lib/api.js

/*
    BlogApi gives access to the data within the _blogposts directory.

    The _blogposts content is treated as a flat directory. There is a
    set of whitelisted directories (for each category) to help declutter
    huge file masses.

    Every filename within _blogposts must be unique, even when nested in
    different directories. The filename will be sluggified, that means that e.g.
    for the filepath "_blogposts/compiler/2021-03-12-my-post.mdx", slug = "my-post"

    The reason for the flat hierarchy is that we want to keep a flat URL
    hierarchy with `https://rescript-lang.org/blog/[some-slug]`, without carrying
    over the full subdirectory hierarchy. This allows us to restructure
    internally more easily without breaking permalinks.

    This module offers functionality to query all slug information, and even
    gives access to fully parsed blog posts with frontmatter data etc.

    See `pages/blog.re` for more context on why we need this API.
 */

module GrayMatter = {
  type output = {
    data: Js.Json.t,
    content: string,
  }

  @module("gray-matter") external matter: string => output = "default"
}

type post = {
  path: string,
  archived: bool,
  frontmatter: BlogFrontmatter.t,
}

let blogPathToSlug = path => {
  path->Js.String2.replaceByRe(%re(`/^(archive\/)?\d\d\d\d-\d\d-\d\d-(.+)\.mdx$/`), "$2")
}

@module("path") external extname: string => string = "extname"

let getAllPosts = () => {
  let postsDirectory = Node.Path.join2(Node.Process.cwd(), "_blogposts")
  let archivedPostsDirectory = Node.Path.join2(postsDirectory, "archive")

  let mdxFiles = dir => {
    Node.Fs.readdirSync(dir)->Js.Array2.filter(path => extname(path) === ".mdx")
  }

  let nonArchivedPosts = mdxFiles(postsDirectory)->Js.Array2.map(path => {
    let {GrayMatter.data: data} =
      Node.Path.join2(postsDirectory, path)->Node.Fs.readFileSync(#utf8)->GrayMatter.matter
    switch BlogFrontmatter.decode(data) {
    | Error(msg) => Js.Exn.raiseError(msg)
    | Ok(d) => {
        path,
        frontmatter: d,
        archived: false,
      }
    }
  })

  let archivedPosts = mdxFiles(archivedPostsDirectory)->Js.Array2.map(path => {
    let {GrayMatter.data: data} =
      Node.Path.join2(archivedPostsDirectory, path)->Node.Fs.readFileSync(#utf8)->GrayMatter.matter
    switch BlogFrontmatter.decode(data) {
    | Error(msg) => Js.Exn.raiseError(msg)
    | Ok(d) => {
        path: Node.Path.join2("archive", path),
        frontmatter: d,
        archived: true,
      }
    }
  })

  Js.Array2.concat(nonArchivedPosts, archivedPosts)->Js.Array2.sortInPlaceWith((a, b) => {
    String.compare(Node.Path.basename(b.path), Node.Path.basename(a.path))
  })
}

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
    let items =
      getAllPosts()
      ->Js.Array2.map(post => {
        let fm = post.frontmatter
        let description = Js.Null.toOption(fm.description)->Belt.Option.getWithDefault("")
        {
          title: fm.title,
          href: baseUrl ++ "/blog/" ++ blogPathToSlug(post.path),
          description,
          pubDate: DateStr.toDate(fm.date),
        }
      })
      ->Js.Array2.slice(~start=0, ~end_=max)
    items
  }

  let toXmlString = (~siteTitle="ReScript Blog", ~siteDescription="", items: array<item>) => {
    let latestPubDateElement =
      Belt.Array.get(items, 0)
      ->Belt.Option.map(item => {
        let latestPubDateStr = item.pubDate->dateToUTCString
        j`<lastBuildDate>$latestPubDateStr</lastBuildDate>`
      })
      ->Belt.Option.getWithDefault("")

    let itemsStr =
      items
      ->Js.Array2.map(({title, pubDate, description, href}) => {
        let descriptionElement = switch description {
        | "" => ""
        | desc => j`<description>
            <![CDATA[$desc]]>
          </description>`
        }

        // TODO: convert pubdate to string
        let dateStr = pubDate->dateToUTCString
        j`
        <item>
          <title> <![CDATA[$title]]></title>
          <link> $href </link>
          <guid> $href </guid>
          $descriptionElement
          <pubDate>$dateStr</pubDate>
        </item>`
      })
      ->Js.Array2.joinWith("\n")

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
