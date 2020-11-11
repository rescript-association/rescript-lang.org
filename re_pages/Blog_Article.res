/*
      This module is responsible for statically prerendering each individual blog post.
 General concepts:
      -----------------------
      - We use webpack's "require" mechanic to reuse the MDX pipeline for rendering
      - Frontmatter is being parsed and attached as an attribute to the resulting component function via plugins/mdx-loader
      - We generate a list of static paths for each blog post via the BlogApi module (using fs)
      - The contents of this file is being reexported by /pages/blog/[slug].js


      A Note on Performance:
      -----------------------
      Luckily, since pages are prerendered, we don't need to worry about
      increased bundle sizes due to the `require` with path interpolation. It
      might cause longer builds though, so we might need to refactor as soon as
      builds are taking too long.  I think we will be fine for now.
  Link to NextJS discussion: https://github.com/zeit/next.js/discussions/11728#discussioncomment-3501
 */
open Util.ReactStuff

let middleDotSpacer = " " ++ (Js.String.fromCharCode(183) ++ " ")

module Params = {
  type t = {slug: string}
}

type props = {fullslug: string}

module BlogComponent = {
  type t = {default: React.component<{.}>}

  @bs.val external require: string => t = "require"

  let frontmatter: React.component<{.}> => Js.Json.t = %raw(
    `
      function(component) {
        if(typeof component.frontmatter === "object") { return component.frontmatter; }
        return {};
      }
    `
  )
}

module Line = {
  @react.component
  let make = () => <div className="block border-t border-snow-darker" />
}

module AuthorBox = {
  @react.component
  let make = (~author: BlogFrontmatter.Author.t) => {
    let displayName = BlogFrontmatter.Author.getDisplayName(author)

    let authorImg = switch author.imgUrl->Js.Null.toOption {
    | Some(src) => <img className="h-full w-full rounded-full" src />
    | None => <NameInitialsAvatar displayName />
    }

    <div className="flex items-center">
      <div className="w-12 h-12 bg-berry-40 block rounded-full mr-3"> authorImg </div>
      <div className="text-14 font-medium text-night-dark">
        {switch author.twitter->Js.Null.toOption {
        | Some(handle) =>
          <a
            href={"https://twitter.com/" ++ handle}
            className="hover:text-night"
            rel="noopener noreferrer"
            target="_blank">
            {displayName->s}
          </a>
        | None => displayName->s
        }}
        <div className="text-night-light"> {author.role->s} </div>
      </div>
    </div>
  }
}

module BlogHeader = {
  @react.component
  let make = (
    ~date: DateStr.t,
    ~author: BlogFrontmatter.Author.t,
    ~co_authors: array<BlogFrontmatter.Author.t>,
    ~title: string,
    ~category: option<string>=?,
    ~description: option<string>,
    ~articleImg: option<string>,
  ) => {
    let date = DateStr.toDate(date)

    let authors = Belt.Array.concat([author], co_authors)

    <div className="flex flex-col items-center">
      <div className="w-full max-w-705">
        <div className="text-night-light text-lg mb-5">
          {switch category {
          | Some(category) => <> {category->s} {middleDotSpacer->s} </>
          | None => React.null
          }}
          {Util.Date.toDayMonthYear(date)->s}
        </div>
        <h1 className=Text.H1.default> {title->s} </h1>
        {description->Belt.Option.mapWithDefault(React.null, desc =>
          switch desc {
          | "" => <div className="mb-8" />
          | desc =>
            <div className="my-8 text-onyx"> <Markdown.Intro> {desc->s} </Markdown.Intro> </div>
          }
        )}
        <div className="flex flex-col md:flex-row mb-12">
          {Belt.Array.map(authors, author =>
            <div
              key=author.username
              style={Style.make(~minWidth="8.1875rem", ())}
              className="mt-4 md:mt-0 md:ml-8 first:ml-0">
              <AuthorBox author />
            </div>
          )->ate}
        </div>
      </div>
      {switch articleImg {
      | Some(articleImg) =>
        <div className="-mx-8 sm:mx-0 sm:w-full bg-night-10 md:mt-24">
          <img
            className="h-full w-full object-cover"
            src=articleImg
            style={Style.make(~maxHeight="33.625rem", ())}
          />
        </div>
      | None => <div className="max-w-705 w-full"> <Line /> </div>
      }}
    </div>
  }
}

let cwd = Node.Process.cwd()

let default = (props: props) => {
  let {fullslug} = props

  let module_ = BlogComponent.require("../_blogposts/" ++ (fullslug ++ ".mdx"))

  let archived = Js.String2.startsWith(fullslug, "archive/")

  let component = module_.default

  let authors = BlogFrontmatter.Author.getAllAuthors()

  let fm = component->BlogComponent.frontmatter->BlogFrontmatter.decode(~authors)

  let children = React.createElement(component, Js.Obj.empty())

  let archivedNote = archived
    ? {
        open Markdown
        <div className="mb-10">
          <Warn>
            <P>
              <span className="font-bold"> {"Important: "->s} </span>
              {"This is an archived blog post, kept for historic reasons. Please note that this information might be terribly outdated."->s}
            </P>
          </Warn>
        </div>
      }
    : React.null

  let content = switch fm {
  | Ok({
      date,
      author,
      co_authors,
      title,
      description,
      canonical,
      articleImg,
      previewImg,
      category,
    }) =>
    let category =
      Js.Null.toOption(category)->Belt.Option.map(category =>
        category->BlogFrontmatter.Category.toString
      )
    <div className="w-full">
      <Meta
        title={title ++ " | ReScript Blog"}
        description=?{description->Js.Null.toOption}
        canonical=?{canonical->Js.Null.toOption}
        ogImage={previewImg->Js.Null.toOption->Belt.Option.getWithDefault(Blog.planetPreviewImg)}
      />
      <div className="mb-10 md:mb-20">
        <BlogHeader
          date
          author
          co_authors
          title
          ?category
          description={description->Js.Null.toOption}
          articleImg={articleImg->Js.Null.toOption}
        />
      </div>
      <div className="flex justify-center">
        <div className="max-w-705 w-full">
          archivedNote
          children
          {switch canonical->Js.Null.toOption {
          | Some(canonical) =>
            <div className="mt-12 text-14">
              {"This article was originally released on "->s}
              <a href=canonical target="_blank" rel="noopener noreferrer"> {canonical->s} </a>
            </div>
          | None => React.null
          }}
          <div className="mt-12">
            <Line />
            <div className="pt-20 flex flex-col items-center">
              <div className="text-3xl sm:text-4xl text-center text-night-dark font-medium">
                {"Want to read more?"->s}
              </div>
              <Next.Link href="/blog">
                <a className="text-fire hover:text-fire-80">
                  {"Back to Overview"->s} <Icon.ArrowRight className="ml-2 inline-block" />
                </a>
              </Next.Link>
            </div>
          </div>
        </div>
      </div>
    </div>

  | Error(msg) =>
    <div>
      <Markdown.Warn>
        <h2 className="font-bold text-night-dark text-2xl mb-2">
          {("Could not parse file '_blogposts/" ++ (fullslug ++ ".mdx'"))->s}
        </h2>
        <p>
          {"The content of this blog post will be displayed as soon as all
            required frontmatter data has been added."->s}
        </p>
        <p className="font-bold mt-4"> {"Errors:"->s} </p>
        {msg->s}
      </Markdown.Warn>
    </div>
  }
  <MainLayout> content </MainLayout>
}

let getStaticProps: Next.GetStaticProps.t<props, Params.t> = ctx => {
  open Next.GetStaticProps
  let {params} = ctx

  let fullslug = BlogApi.getFullSlug(params.slug)->Belt.Option.getWithDefault(params.slug)

  let props = {fullslug: fullslug}
  let ret = {"props": props}
  Js.Promise.resolve(ret);
}

let getStaticPaths: Next.GetStaticPaths.t<Params.t> = () => {
  open Next.GetStaticPaths

  let paths = BlogApi.getAllPosts()->Belt.Array.map(postData => {
    params: {
      Params.slug: postData.slug,
    },
  })
  let ret = {paths: paths, fallback: false}
  Promise.resolved(ret)
}
