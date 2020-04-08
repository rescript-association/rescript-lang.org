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
open Util.ReactStuff;

module Params = {
  type t = {slug: string};
};

type props = {slug: string};

module BlogComponent = {
  type t = {default: React.component(Js.t({.}))};

  [@bs.val] external require: string => t = "require";

  let frontmatter: React.component(Js.t({.})) => Js.Json.t = [%raw
    {|
      function(component) {
        if(typeof component.frontmatter === "object") {
          return component.frontmatter;
        }
        return {};
      }
    |}
  ];
};

let cwd = Node.Process.cwd();

let default = (props: props) => {
  let {slug} = props;

  let module_ =
    BlogComponent.require("../_blogposts/" ++ props.slug ++ ".mdx");

  let component = module_.default;

  let fm = component->BlogComponent.frontmatter->BlogFrontmatter.decode;

  let children = React.createElement(component, Js.Obj.empty());

  let content =
    switch (fm) {
    | Ok({date, author, title, description}) =>
      let date = DateStr.toDate(date);
      <>
        <div className="text-night-light text-lg mb-6">
          {Util.Date.toDayMonthYear(date)->s}
        </div>
        <h1 className="text-48 text-night-dark"> title->s </h1>
        {description
         ->Js.Null.toOption
         ->Belt.Option.mapWithDefault(React.null, desc => {
             <div className="my-8">
               <Markdown.Intro> desc->s </Markdown.Intro>
             </div>
           })}
        <div className="flex mb-20 items-center">
          <div className="w-12 h-12 bg-berry block rounded-full mr-3">
            <img
              className="h-full w-full rounded-full"
              src="https://pbs.twimg.com/profile_images/1185576475837304839/hvCe6M2r_200x200.jpg"
            />
          </div>
          <div className="text-18 text-night-dark">
            {switch (author.social->Js.Null.toOption) {
             | Some(social) =>
               let href =
                 BlogFrontmatter.Author.socialUrl(social)
                 ++ "/"
                 ++ author.username;
               <a
                 href
                 className="hover:text-night"
                 rel="noopener noreferrer"
                 target="_blank">
                 {{
                    "@" ++ author.username;
                  }
                  ->s}
               </a>;
             | None => author.username->s
             }}
            <div className="text-night-light"> "Reason Association"->s </div>
          </div>
        </div>
        children
        <div
          className="border-t border-snow-darker mt-8 pt-24 flex flex-col items-center">
          <div className="text-4xl text-night-dark font-medium">
            "Want to read more?"->s
          </div>
          <Next.Link href="/blog">
            <a className="text-fire hover:text-fire-80">
              "Back to Overview"->s
              <Icon.ArrowRight className="ml-2 inline-block" />
            </a>
          </Next.Link>
        </div>
      </>;

    | Error(msg) =>
      <div>
        <Markdown.Warn>
          <h2 className="font-bold text-night-dark text-2xl mb-2">
            {{
               "Could not parse file '_blogposts/" ++ slug ++ ".mdx'";
             }
             ->s}
          </h2>
          <p>
            "The content of this blog post will be displayed as soon as all
            required frontmatter data has been added."
            ->s
          </p>
          <p className="font-bold mt-4"> "Errors:"->s </p>
          msg->s
        </Markdown.Warn>
      </div>
    };
  <MainLayout> content </MainLayout>;
};

let getStaticProps: Next.GetStaticProps.t(props, Params.t) =
  ctx => {
    open Next.GetStaticProps;
    let {params} = ctx;

    let props = {slug: params.slug};
    let ret = {"props": props};
    Promise.resolved(ret);
  };

let getStaticPaths: Next.GetStaticPaths.t(Params.t) =
  () => {
    open Next.GetStaticPaths;

    let paths =
      BlogApi.getAllPosts()
      ->Belt.Array.map(postData => {{
                                      params: {
                                        Params.slug: postData.slug,
                                      },
                                    }});

    let ret = {paths, fallback: false};

    Promise.resolved(ret);
  };
