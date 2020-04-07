/*
    This module is responsible for static prerendering each individual
    blog post.

    General concepts:
    - We use webpack's "require" mechanic to reuse the MDX pipeline for rendering
    - Frontmatter is being parsed and attached as an attribute to the resulting component function via plugins/mdx-loader
    - We generate a list of static paths for each blog post via the BlogApi module (using fs)
    - The contents of this file is being reexported by /pages/blog/[slug].js
 */
open Util.ReactStuff;

module Params = {
  type t = {slug: string};
};

type props = {
  slug: string,
  mdxFile: string,
};

module BlogComponent = {
  type t = {default: React.component(Js.t({.}))};

  [@bs.val] external require: string => t = "require";

  [@bs.get] external frontmatter: t => Js.Json.t = "frontmatter";

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

  let fm =
    component->BlogComponent.frontmatter->BlogArticleLayout.FrontMatter.decode;

  let content = React.createElement(component, Js.Obj.empty());

  switch (fm) {
  | Ok({author, date}) =>
    <BlogArticleLayout author date={BlogArticleLayout.DateStr.toDate(date)}>
      content
    </BlogArticleLayout>

  | Error(msg) =>
    <div>
      {{
         "Couldn't parse frontmatter for \"blog/" ++ slug ++ "\": " ++ msg;
       }
       ->s}
      content
    </div>
  };
};

let getStaticProps: Next.GetStaticProps.t(props, Params.t) =
  ctx => {
    open Next.GetStaticProps;
    let {params} = ctx;

    let props = {
      slug: params.slug,
      mdxFile: "../../_blogposts/" ++ params.slug ++ ".mdx",
    };
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
