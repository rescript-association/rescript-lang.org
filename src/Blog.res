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

module Link = Next.Link

let defaultPreviewImg = "/static/Art-3-rescript-launch.jpg"

// For encoding reasons, see https://shripadk.github.io/react/docs/jsx-gotchas.html
let middleDotSpacer = " " ++ (Js.String.fromCharCode(183) ++ " ")

module Badge = {
  @react.component
  let make = (~badge: BlogFrontmatter.Badge.t) => {
    let bgColor = switch badge {
    | Preview | Roadmap | Release => "bg-turtle"
    | Testing => "bg-orange"
    }

    let text = badge->BlogFrontmatter.Badge.toString

    <div
      className={bgColor ++ " flex items-center h-6 font-medium tracking-tight text-gray-80-tr text-14 px-2 rounded-sm"}>
      <div>
        <img className="h-3 block mr-1" src="/static/star.svg" />
      </div>
      <div> {React.string(text)} </div>
    </div>
  }
}
module CategorySelector = {
  type selection =
    | All
    | Archived

  let renderTab = (~text: string, ~isActive: bool, ~onClick) => {
    let active = "bg-gray-20 text-gray-80 rounded py-1"
    <div
      key=text
      onClick
      className={(
        isActive ? active : "hover:cursor-pointer bg-white hover:text-gray-80"
      ) ++ "  px-4 inline-block"}>
      {React.string(text)}
    </div>
  }

  @react.component
  let make = (~selected: selection, ~onSelected: selection => unit) => {
    let tabs = [All, Archived]

    <div className="text-16 w-full flex items-center justify-between text-gray-60">
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
        }

        renderTab(~isActive, ~text, ~onClick)
      })->React.array}
    </div>
  }
}

module BlogCard = {
  @react.component
  let make = (
    ~previewImg: option<string>=?,
    ~title: string="Unknown Title",
    ~author as _: BlogFrontmatter.author,
    ~category: option<string>=?,
    ~badge: option<BlogFrontmatter.Badge.t>=?,
    ~date: Js.Date.t,
    ~slug: string,
  ) =>
    <section className="h-full">
      <div className="relative">
        {switch badge {
        | None => React.null
        | Some(badge) =>
          <div className="absolute z-10 bottom-0 mb-4 -ml-2">
            <Badge badge />
          </div>
        }}
        <Link href="/blog/[slug]" _as={"/blog/" ++ slug}>
          <a className="relative hl-title block mb-4 pt-9/16">
            {
              let className = "absolute top-0 h-full w-full object-cover"
              switch previewImg {
              | Some(src) => <img className src />
              | None => <img className src=defaultPreviewImg />
              }
            }
          </a>
        </Link>
      </div>
      <div className="px-2">
        <Link href="/blog/[slug]" _as={"/blog/" ++ slug}>
          <a>
            <h2 className="hl-4"> {React.string(title)} </h2>
          </a>
        </Link>
        <div className="captions text-gray-40 pt-1">
          {switch category {
          | Some(category) =>
            <>
              {React.string(category)}
              {React.string(j` · `)}
            </>
          | None => React.null
          }}
          {React.string(date->Util.Date.toDayMonthYear)}
        </div>
      </div>
    </section>
}

module FeatureCard = {
  @react.component
  let make = (
    ~previewImg: option<string>=?,
    ~title: string="Unknown Title",
    ~author: BlogFrontmatter.author,
    ~badge: option<BlogFrontmatter.Badge.t>=?,
    ~date: Js.Date.t,
    ~category: option<string>=?,
    ~firstParagraph: string="",
    ~slug: string,
  ) => {
    let authorImg = <img className="h-full w-full rounded-full" src=author.imgUrl />

    <section
      className="flex sm:px-4 md:px-8 lg:px-0 flex-col justify-end lg:flex-row sm:items-center h-full">
      <div
        className="w-full h-full sm:self-start md:self-auto"
        style={ReactDOMStyle.make(
          /* ~maxWidth="38.125rem", */
          ~maxHeight="25.4375rem",
          (),
        )}>
        <Link href="/blog/[slug]" _as={"/blog/" ++ slug}>
          <a className="relative block pt-2/3">
            {switch badge {
            | Some(badge) =>
              <div className="absolute z-10 top-0 mt-10 ml-4 lg:-ml-4">
                <Badge badge />
              </div>
            | None => React.null
            }}
            {
              let className = "absolute top-0 h-full w-full object-cover"
              switch previewImg {
              | Some(src) => <img className src />
              | None => <img className src=defaultPreviewImg />
              }
            }
          </a>
        </Link>
      </div>
      <div
        className="relative px-4 lg:self-auto sm:pt-12 md:px-20 sm:self-start md:-mt-20 mt-4 bg-white lg:w-full lg:pt-0 lg:mt-0 lg:px-0 lg:ml-12">
        <div className="max-w-400 ">
          <h2 className="hl-1"> {React.string(title)} </h2>
          <div className="mb-6">
            <div className="flex items-center body-sm text-gray-40 mt-2 mb-5">
              <div className="inline-block w-4 h-4 mr-2"> authorImg </div>
              <div>
                <a
                  className="hover:text-gray-60"
                  href={"https://twitter.com/" ++ author.twitter}
                  rel="noopener noreferrer">
                  {React.string(author.fullname)}
                </a>
                {switch category {
                | Some(category) =>
                  <>
                    {React.string(middleDotSpacer)}
                    {React.string(category)}
                    {React.string(middleDotSpacer)}
                  </>
                | None => React.string(middleDotSpacer)
                }}
                {date->Util.Date.toDayMonthYear->React.string}
              </div>
            </div>
            <p className="body-md text-gray-70"> {React.string(firstParagraph)} </p>
          </div>
        </div>
        <Link href="/blog/[slug]" _as={"/blog/" ++ slug}>
          <a>
            <Button> {React.string("Read Article")} </Button>
          </a>
        </Link>
      </div>
    </section>
  }
}

type params = {slug: string}

type props = {
  posts: array<BlogApi.post>,
  archived: array<BlogApi.post>,
}

let default = (props: props): React.element => {
  let {posts, archived} = props

  let (currentSelection, setSelection) = React.useState(() => CategorySelector.All)

  let content = if Belt.Array.length(posts) === 0 {
    /* <div> {React.string("Currently no posts available")} </div>; */
    <div className="mt-8">
      <Markdown.H1> {React.string("Blog not yet available")} </Markdown.H1>
      <Markdown.Warn> {React.string("This blog is currently in the works.")} </Markdown.Warn>
    </div>
  } else {
    let filtered = switch currentSelection {
    | All => posts
    | Archived => archived
    }

    let result = switch Belt.Array.length(filtered) {
    | 0 => <div> {React.string("No posts for this category available...")} </div>
    | _ =>
      let first = Belt.Array.getExn(filtered, 0)
      let rest = Js.Array2.sliceFrom(filtered, 1)

      let featureBox =
        <div className="w-full mb-24 lg:px-8 xl:px-0">
          <FeatureCard
            previewImg=?{first.frontmatter.previewImg->Js.Null.toOption}
            title=first.frontmatter.title
            badge=?{first.frontmatter.badge->Js.Null.toOption}
            author=first.frontmatter.author
            firstParagraph=?{first.frontmatter.description->Js.Null.toOption}
            date={first.frontmatter.date->DateStr.toDate}
            slug={BlogApi.blogPathToSlug(first.path)}
          />
        </div>

      let postsBox = switch rest {
      | [] => React.null
      | rest =>
        <div
          className="px-4 md:px-8 xl:px-0 grid grid-cols-1 xs:grid-cols-2 md:grid-cols-3 gap-20 gap-y-12 md:gap-y-24 w-full">
          {Js.Array2.map(rest, post => {
            let badge = post.frontmatter.badge->Js.Null.toOption

            <BlogCard
              key={post.path}
              previewImg=?{post.frontmatter.previewImg->Js.Null.toOption}
              title=post.frontmatter.title
              author=post.frontmatter.author
              ?badge
              date={post.frontmatter.date->DateStr.toDate}
              slug={BlogApi.blogPathToSlug(post.path)}
            />
          })->React.array}
        </div>
      }

      <>
        featureBox
        postsBox
      </>
    }

    <>
      <div className="hidden sm:flex justify-center ">
        <div className="my-16 w-full" style={ReactDOMStyle.make(~maxWidth="12rem", ())}>
          <CategorySelector
            onSelected={selection => setSelection(_ => selection)} selected=currentSelection
          />
        </div>
      </div>
      result
    </>
  }

  let overlayState = React.useState(() => false)
  let title = "Blog | ReScript Documentation"

  <>
    <Meta
      siteName="ReScript Blog" title description="News, Announcements, Release Notes and more"
    />
    <div className="mt-16 pt-2">
      <div className="text-gray-80 text-18">
        <Navigation overlayState />
        <div className="flex justify-center overflow-hidden">
          <main className="min-w-320 lg:align-center w-full lg:px-0 max-w-1280 pb-48">
            <Mdx.Provider components=Markdown.default>
              <div className="flex justify-center">
                <div className="w-full" style={ReactDOMStyle.make(~maxWidth="66.625rem", ())}>
                  content
                </div>
              </div>
            </Mdx.Provider>
          </main>
        </div>
        <Footer />
      </div>
    </div>
  </>
}

let getStaticProps: Next.GetStaticProps.t<props, params> = async _ctx => {
  let (archived, nonArchived) = BlogApi.getAllPosts()->Belt.Array.partition(data => data.archived)

  let props = {
    posts: nonArchived,
    archived,
  }

  {"props": props}
}
