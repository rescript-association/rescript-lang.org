/*
 TODO: The way the blog works right now is very rough.
 We don't do any webpack magic to extract content, title preview or frontmatter, and
 don't do any pagination... for now it's not really needed I guess, it would
 still be good to rethink the ways the blog works in a later point of time.

 Docusaurus does a lot of webpack / remark magic in that regard. For my taste,
 it does too much, but here's a link to draw some inspiration from:

 https://github.com/facebook/docusaurus/tree/master/packages/docusaurus-plugin-content-blog/src

 Features like RSS feed etc might be nice, but I guess it's not a core feature
 we need right away.
 */

open Util.ReactStuff

module Link = Next.Link

let rescriptDefaultImg = "https://res.cloudinary.com/dmm9n7v9f/image/upload/v1598616442/reason%20association/rescript-lang.org/art-3-rescript-launch_ovoibg.jpg"
let planetPreviewImg = "https://res.cloudinary.com/dmm9n7v9f/image/upload/v1587479463/Reason%20Association/reasonml.org/reasonml_art2_1280_vhzxnz.png"

// For encoding reasons, see https://shripadk.github.io/react/docs/jsx-gotchas.html
let middleDotSpacer = " " ++ (Js.String.fromCharCode(183) ++ " ")

module Badge = {
  type color =
    | Turtle
    | Orange

  @react.component
  let make = (~badge: BlogFrontmatter.Badge.t) => {
    let bgColor = switch badge {
    | Preview | Roadmap | Release => "bg-turtle"
    | Testing => "bg-code-1"
    }

    let text = badge->BlogFrontmatter.Badge.toString

    <div
      className={bgColor ++ " flex items-center h-6 font-medium tracking-tight text-onyx-80 text-14 px-2 rounded-sm"}>
      <div> <img className="h-3 block mr-1" src="/static/star.svg" /> </div> <div> {text->s} </div>
    </div>
  }
}
module CategorySelector = {
  type selection =
    | All
    | Archived
    | Category(BlogFrontmatter.Category.t)

  let renderTab = (~text: string, ~isActive: bool, ~onClick) => {
    let active = "bg-snow-dark text-onyx rounded py-1"
    <div
      key=text
      onClick
      className={(
        isActive ? active : "hover:cursor-pointer hover:text-onyx"
      ) ++ "  px-4 inline-block"}>
      {text->s}
    </div>
  }

  @react.component
  let make = (
    ~categories: array<BlogFrontmatter.Category.t>,
    ~selected: selection,
    ~onSelected: selection => unit,
  ) => {
    let tabs = [All, Archived]->Js.Array2.concat(Belt.Array.map(categories, cat => Category(cat)))

    <div className="text-16 w-full flex items-center justify-between text-onyx-50">
      {Belt.Array.map(tabs, tab => {
        let onClick = evt => {
          evt->ReactEvent.Mouse.preventDefault
          onSelected(tab)
        }

        // Deep comparison here!
        let isActive = selected == tab

        let text = switch tab {
        | All => "All"
        | Archived => "Archived"
        | Category(cat) => BlogFrontmatter.Category.toString(cat)
        }

        renderTab(~isActive, ~text, ~onClick)
      })->ate}
    </div>
  }
}

module BlogCard = {
  @react.component
  let make = (
    ~previewImg: option<string>=?,
    ~title: string="Unknown Title",
    ~author as _: BlogFrontmatter.Author.t,
    ~category: option<string>=?,
    ~badge: option<BlogFrontmatter.Badge.t>=?,
    ~date: Js.Date.t,
    ~slug: string,
  ) =>
    <section className="h-full">
      <div className="relative">
        {switch badge {
        | None => React.null
        | Some(badge) => <div className="absolute z-10 bottom-0 mb-4 -ml-2"> <Badge badge /> </div>
        }}
        <Link href="/blog/[slug]" _as={"/blog/" ++ slug}>
          <a className="relative block mb-4 pt-9/16">
            {
              let className = "absolute top-0 h-full w-full object-cover"
              switch previewImg {
              | Some(src) => <img className src />
              | None => <img className src=planetPreviewImg />
              }
            }
          </a>
        </Link>
      </div>
      <div className="px-2">
        <Link href="/blog/[slug]" _as={"/blog/" ++ slug}>
          <a> <h2 className=Text.H3.default> {title->s} </h2> </a>
        </Link>
        <div className="text-night-light text-sm">
          {switch category {
          | Some(category) => <> {category->s} {j` · `->s} </>
          | None => React.null
          }}
          {date->Util.Date.toDayMonthYear->s}
        </div>
      </div>
    </section>
}

module FeatureCard = {
  @react.component
  let make = (
    ~previewImg: option<string>=?,
    ~title: string="Unknown Title",
    ~author: BlogFrontmatter.Author.t,
    ~badge: option<BlogFrontmatter.Badge.t>=?,
    ~date: Js.Date.t,
    ~category: option<string>=?,
    ~firstParagraph: string="",
    ~slug: string,
  ) => {
    let displayName = BlogFrontmatter.Author.getDisplayName(author)

    let authorImg = switch author.imgUrl->Js.Null.toOption {
    | Some(src) => <img className="h-full w-full rounded-full" src />
    | None => <NameInitialsAvatar displayName />
    }

    <section
      className="flex sm:px-4 md:px-8 lg:px-0 flex-col justify-end lg:flex-row sm:items-center h-full">
      <div
        className="w-full h-full sm:self-start md:self-auto"
        style={Style.make(
          /* ~maxWidth="38.125rem", */
          ~maxHeight="25.4375rem",
          (),
        )}>
        <Link href="/blog/[slug]" _as={"/blog/" ++ slug}>
          <a className="relative block pt-2/3">
            {switch badge {
            | Some(badge) =>
              <div className="absolute z-10 top-0 mt-10 ml-4 lg:-ml-4"> <Badge badge /> </div>
            | None => React.null
            }}
            {
              let className = "absolute top-0 h-full w-full object-cover"
              switch previewImg {
              | Some(src) => <img className src />
              | None => <img className src=planetPreviewImg />
              }
            }
          </a>
        </Link>
      </div>
      <div
        className="relative px-4 lg:self-auto sm:pt-12 md:px-20 sm:self-start md:-mt-20 mt-4 bg-white lg:w-full lg:pt-0 lg:mt-0 lg:px-0 lg:ml-12">
        <div className="max-w-400 ">
          <h2 className=Text.H2.default> {title->s} </h2>
          <div className="mb-6">
            <div className="flex items-center font-medium text-onyx-50 text-sm my-2">
              <div className="inline-block w-4 h-4 mr-2"> authorImg </div>
              <div>
                {switch author.twitter->Js.Null.toOption {
                | Some(handle) =>
                  <a
                    className="hover:text-onyx-80"
                    href={"https://twitter.com/" ++ handle}
                    rel="noopener noreferrer"
                    target="_blank">
                    {displayName->s}
                  </a>
                | None => displayName->s
                }}
                {switch category {
                | Some(category) => <> {middleDotSpacer->s} {category->s} {middleDotSpacer->s} </>
                | None => middleDotSpacer->s
                }}
                {date->Util.Date.toDayMonthYear->s}
              </div>
            </div>
            <p className="text-night-dark text-16"> {firstParagraph->s} </p>
          </div>
        </div>
        <Link href="/blog/[slug]" _as={"/blog/" ++ slug}>
          <a> <Button> {"Read Article"->s} </Button> </a>
        </Link>
      </div>
    </section>
  }
}

type params = {slug: string}

module Post = {
  type t = {
    id: string,
    frontmatter: BlogFrontmatter.t,
  }

  let orderByDate = (posts: array<t>): array<t> =>
    posts->Js.Array.copy->Js.Array2.sortInPlaceWith((a, b) => {
      let aV = a.frontmatter.date->DateStr.toDate->Js.Date.valueOf
      let bV = b.frontmatter.date->DateStr.toDate->Js.Date.valueOf
      if aV === bV {
        0
      } else if aV > bV {
        -1
      } else {
        1
      }
    })
}

module Malformed = {
  type t = {
    id: string,
    message: string,
  }
}

type props = {
  posts: array<Post.t>,
  archived: array<Post.t>,
  malformed: array<Malformed.t>,
  availableCategories: array<BlogFrontmatter.Category.t>,
}

let default = (props: props): React.element => {
  let {availableCategories, posts, malformed, archived} = props

  let (currentSelection, setSelection) = React.useState(() => CategorySelector.All)

  let errorBox = if ProcessEnv.env === ProcessEnv.development && Belt.Array.length(malformed) > 0 {
    <div className="mb-12">
      <Markdown.Warn>
        <h2 className="font-bold text-night-dark text-2xl mb-2">
          {"Some Blog Posts are Malformed!"->s}
        </h2>
        <p> {"Any blog post with invalid data will not be displayed in production."->s} </p>
        <div>
          <p className="font-bold mt-4"> {"Errors:"->s} </p>
          <ul>
            {Belt.Array.mapWithIndex(malformed, (i, m) =>
              <li key={i->Belt.Int.toString} className="list-disc ml-5">
                {("pages/blog/" ++ (m.id ++ (".mdx: " ++ m.message)))->s}
              </li>
            )->ate}
          </ul>
        </div>
      </Markdown.Warn>
    </div>
  } else {
    React.null
  }

  let content = if Belt.Array.length(posts) === 0 {
    /* <div> "Currently no posts available"->s </div>; */
    <div
      className="mt-8">
      <Markdown.H1> {"Blog not yet available"->s} </Markdown.H1>
      <Markdown.Warn> {"This blog is currently in the works."->s} </Markdown.Warn>
    </div>
  } else {
    let filtered = switch currentSelection {
    | All => posts
    | Archived => archived
    | Category(selected) => Belt.Array.keep(posts, ({frontmatter}) =>
        switch Js.Null.toOption(frontmatter.category) {
        | Some(category) => category === selected
        | None => false
        }
      )
    }

    let result = switch Belt.Array.length(filtered) {
    | 0 => <div> {"No posts for this category available..."->s} </div>
    | _ =>
      let first = Belt.Array.getExn(filtered, 0)
      let rest = Js.Array2.sliceFrom(filtered, 1)

      let category =
        first.frontmatter.category
        ->Js.Null.toOption
        ->Belt.Option.map(category => category->BlogFrontmatter.Category.toString)

      let featureBox =
        <div className="w-full mb-24 lg:px-8 xl:px-0">
          <FeatureCard
            previewImg=?{first.frontmatter.previewImg->Js.Null.toOption}
            title=first.frontmatter.title
            badge=?{first.frontmatter.badge->Js.Null.toOption}
            author=first.frontmatter.author
            firstParagraph=?{first.frontmatter.description->Js.Null.toOption}
            date={first.frontmatter.date->DateStr.toDate}
            ?category
            slug=first.id
          />
        </div>

      let postsBox = switch rest {
      | [] => React.null
      | rest =>
        <div
          className="px-4 md:px-8 xl:px-0 grid grid-cols-1 xs:grid-cols-2 md:grid-cols-3 gap-20 row-gap-12 md:row-gap-24 w-full">
          {Belt.Array.mapWithIndex(rest, (i, post) => {
            let badge = post.frontmatter.badge->Js.Null.toOption
            let category =
              first.frontmatter.category
              ->Js.Null.toOption
              ->Belt.Option.map(category => category->BlogFrontmatter.Category.toString)

            <BlogCard
              key={post.id ++ Belt.Int.toString(i)}
              previewImg=?{post.frontmatter.previewImg->Js.Null.toOption}
              title=post.frontmatter.title
              author=post.frontmatter.author
              ?badge
              ?category
              date={post.frontmatter.date->DateStr.toDate}
              slug=post.id
            />
          })->ate}
        </div>
      }

      <> featureBox postsBox </>
    }

    <>
      <div className="hidden sm:flex justify-center ">
        <div className="my-16 w-full" style={Style.make(~maxWidth="12rem", ())}>
          <CategorySelector
            categories=availableCategories
            onSelected={selection => setSelection(_ => selection)}
            selected=currentSelection
          />
        </div>
      </div>
      result
    </>
  }

  let overlayState = React.useState(() => false)

  <>
    <Meta
      title="Blog | ReScript Documentation"
      description="News, Announcements, Release Notes and more"
    />
    <div className="mb-32 mt-16 pt-2">
      <div className="text-night text-lg">
        <Navigation overlayState />
        <div className="flex justify-center overflow-hidden">
          <main className="min-w-320 lg:align-center w-full lg:px-0 max-w-1280 ">
            <Mdx.Provider components=Markdown.default>
              <div className="flex justify-center">
                <div className="w-full" style={Style.make(~maxWidth="66.625rem", ())}>
                  errorBox content
                </div>
              </div>
            </Mdx.Provider>
          </main>
        </div>
      </div>
    </div>
  </>
}

let getStaticProps: Next.GetStaticProps.t<props, params> = _ctx => {
  let authors = BlogFrontmatter.Author.getAllAuthors()
  let (posts, malformed, archived, availableCategories) =
    BlogApi.getAllPosts()->Belt.Array.reduce(([], [], [], []), (acc, postData) => {
      let (posts, malformed, archived, availableCategories) = acc
      let id = postData.slug

      let decoded = BlogFrontmatter.decode(~authors, postData.frontmatter)

      switch decoded {
      | Error(message) =>
        let m = {Malformed.id: id, message: message}
        let malformed = Belt.Array.concat(malformed, [m])
        (posts, malformed, archived, availableCategories)
      | Ok(frontmatter) =>
        if postData.archived {
          Js.Array2.push(archived, {Post.id: id, frontmatter: frontmatter})->ignore
        } else {
          Js.Array2.push(posts, {Post.id: id, frontmatter: frontmatter})->ignore
        }

        let category = Js.Null.toOption(frontmatter.category)

        let hasCategory = Js.Array2.some(availableCategories, c =>
          switch category {
          | Some(category) => c === category
          | None => false
          }
        )

        // TODO: For now we ignore categories alltogether (only show All | Archived)
        let newAvailableCat = if true || postData.archived {
          availableCategories
        } else {
          switch // We will only add categories that are not yet
          // accumulated from previous post frontmatters
          category {
          | Some(category) =>
            if hasCategory {
              availableCategories
            } else {
              Belt.Array.concat(availableCategories, [category])
            }
          | None => availableCategories
          }
        }

        (posts, malformed, archived, newAvailableCat)
      }
    })

  let props = {
    posts: posts,
    malformed: malformed,
    archived: archived,
    availableCategories: availableCategories,
  }

  Promise.resolved({"props": props})
}
