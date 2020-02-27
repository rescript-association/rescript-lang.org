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

open Util.ReactStuff;

module Data = {
  type rawModule = Js.Json.t;

  module BlogPost = {
    type meta = {
      author: string,
      date: Js.Date.t,
    };

    type t = {
      meta,
      /*default: React.component({. "children": Mdx.MdxChildren.t}),*/
      default: unit => Mdx.MdxChildren.t,
    };

    type content = {
      title: option(string),
      firstParagraph: option(string),
    };

    // That's a really wild function traversing through the MdxChildren
    // element to find the title & First paragraph of the post
    // This might be worth revisiting by using webpack / remark instead
    let extractContent = (mdx: Mdx.MdxChildren.t) => {
      Mdx.MdxChildren.(
        switch (classify(mdx)) {
        | Element(el) =>
          let children = el->getMdxChildren;
          switch (classify(children)) {
          | Array(elements) =>
            let title: ref(option(string)) = ref(None);
            let firstParagraph: ref(option(string)) = ref(None);
            let i = ref(0);
            let to_ = Array.length(elements);

            while (i^ < to_ && (title^ === None || firstParagraph^ === None)) {
              let el = Belt.Array.getExn(elements, i^);

              switch (Mdx.getMdxType(el)) {
              | "h1" => title := flatten(el)->Js.Array2.joinWith(" ")->Some
              | "p" =>
                firstParagraph := flatten(el)->Js.Array2.joinWith(" ")->Some
              | _ => ()
              };

              i := i^ + 1;
            };
            Some({title: title^, firstParagraph: firstParagraph^});
          | _ => None
          };
        | _ => None
        }
      );
    };

    // We are using raw JS to validate for now
    // gives at least some small guarantees that the values are there
    let validate: Js.Json.t => option(t) = [%raw
      {|
      function(json) {
        if(typeof json !== "object") {
          return
        }
        if(typeof json.meta !== "object") {
          return
        }
        if(json.default == null) {
          return
        }

        var meta = json.meta;
        if(typeof meta.author !== "string") {
          return;
        }

        if(typeof meta.date === "string") {
          var date = new Date(meta.date);

          // Weird isNan emulation
          let time = date.getTime();
          if(time !== time) {
            return
          }

          meta.date = date;
        }

        return json;
      }
    |}
    ];
  };

  type parsedMdxModule = {
    id: string, /* Id, which is also part of the Url */
    filepath: string,
    meta: BlogPost.meta,
    content: BlogPost.content,
  };

  type webpackCtx = {keys: unit => array(string)};

  let getMdxModule: (webpackCtx, string) => rawModule = [%raw
    (ctx, filepath) => "{ return ctx(filepath); }"
  ];

  let blogCtx: webpackCtx = [%raw
    "require.context('../pages/blog', true, /^\.\/.*\.mdx$/)"
  ];

  let toMdxModules = (ctx: webpackCtx): array(parsedMdxModule) =>
    ctx.keys()
    ->Belt.Array.reduce(
        [||],
        (acc, filepath) => {
          let id =
            switch (Js.String.match([%re "/\\.\\/(.*)\\.mdx/"], filepath)) {
            | Some([|_, id|]) => id
            | _ => filepath
            };

          let correctFilepath = path =>
            Js.String.replaceByRe([%re "/^\\.\\//"], "./pages/blog/", path);

          let m = ctx->getMdxModule(filepath);
          switch (BlogPost.validate(m)) {
          | Some({meta, default}) =>
            let element = default();

            let content = BlogPost.extractContent(element);

            switch (content) {
            | None => acc
            | Some({title: None}) =>
              Js.log("h1 title is missing in " ++ filepath);
              acc;
            | Some(content) =>
              Js.Array2.concat(
                acc,
                [|
                  {id, filepath: correctFilepath(filepath), meta, content},
                |],
              );
            };
          | None =>
            Js.log("Could not parse blog post " ++ filepath);
            acc;
          };
        },
      );

  let getAllBlogPosts = () => {
    blogCtx->toMdxModules;
  };
};

[@react.component]
let default = () => {
  open Markdown;
  let posts = Data.getAllBlogPosts();

  let content =
    if (Array.length(posts) === 0) {
      <div> "No blog posts available yet"->s </div>;
    } else {
      <div className="grid grid-cols-3 w-full">
        {Belt.Array.map(posts, post => {<div key={post.id}> post.id->s </div>})
         ->ate}
      </div>;
    };

  <div> <H1> "Blog"->s </H1> content </div>;
};
