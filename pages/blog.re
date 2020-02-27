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

module Link = Next.Link;

module Data = {
  type rawModule = Js.Json.t;

  module BlogPost = {
    type frontmatter = {
      author: string,
      date: string,
      imgUrl: option(string),
    };

    type t = {
      frontmatter,
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

        if(json.default == null) {
          return
        }

        if(typeof json.default.frontmatter !== "object") {
          return
        }

        var frontmatter = json.default.frontmatter;
        if(typeof frontmatter.author !== "string") {
          return;
        }

        if(typeof frontmatter.date === "string") {
          var date = new Date(frontmatter.date);

          // Weird isNan emulation
          let time = date.getTime();
          if(time !== time) {
            return
          }
        }

        json.frontmatter = frontmatter;

        return json;
      }
    |}
    ];
  };

  type post = {
    id: string, /* Id, which is also part of the Url */
    filepath: string,
    frontmatter: BlogPost.frontmatter,
    content: BlogPost.content,
  };

  type webpackCtx = {keys: unit => array(string)};

  let getMdxModule: (webpackCtx, string) => rawModule = [%raw
    (ctx, filepath) => "{ return ctx(filepath); }"
  ];

  let blogCtx: webpackCtx = [%raw
    "require.context('../pages/blog', true, /^\.\/.*\.mdx$/)"
  ];

  let readPosts = (ctx: webpackCtx): array(post) =>
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
          | Some({frontmatter, default}) =>
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
                  {
                    id,
                    filepath: correctFilepath(filepath),
                    frontmatter,
                    content,
                  },
                |],
              )
            };
          | None =>
            Js.log("Could not parse blog post " ++ filepath);
            acc;
          };
        },
      );

  let orderByDate = (posts: array(post)): array(post) => {
    posts
    ->Js.Array.copy
    ->Js.Array2.sortInPlaceWith((a, b) => {
        let aV = a.frontmatter.date->Js.Date.fromString->Js.Date.valueOf;
        let bV = b.frontmatter.date->Js.Date.fromString->Js.Date.valueOf;
        if (aV === bV) {
          0;
        } else if (aV > bV) {
          (-1);
        } else {
          1;
        };
      });
  };

  let getAllBlogPosts = () => {
    blogCtx->readPosts->orderByDate;
  };
};

module BlogCard = {
  [@react.component]
  let make =
      (
        ~imgUrl: option(string)=?,
        ~title: string="Unknown Title",
        ~author: string,
        ~tags: array(string)=[||],
        ~date: Js.Date.t,
        ~href: string,
      ) => {
    <section className="h-full">
      <Link href>
        <a>
          <div>
            {switch (imgUrl) {
             | Some(src) => <img className="mb-4" src />
             | None => React.null
             }}
            <h2 className="text-night-dark text-2xl"> title->s </h2>
            <div className="text-night-light text-sm">
              author->s
              {j| · |j}->s
              {date->Util.Date.toDayMonthYear->s}
            </div>
          </div>
        </a>
      </Link>
    </section>;
  };
};

module FeatureCard = {
  [@react.component]
  let make =
      (
        ~imgUrl: option(string)=?,
        ~title: string="Unknown Title",
        ~author: string,
        ~date: Js.Date.t,
        ~firstParagraph: string="",
        ~href: string,
      ) => {
    <section className="flex h-full">
      <div className="w-1/2 h-full">
        <Link href>
          <a>
            {switch (imgUrl) {
             | Some(src) => <img className="h-full w-full object-cover" src />
             | None => <div className="bg-night-light" />
             }}
          </a>
        </Link>
      </div>
      <div className="w-1/2 mt-8 ml-16">
        <h2 className="text-night-dark font-semibold text-6xl"> title->s </h2>
        <div className="mb-4">
          <p className="text-night-dark text-lg"> firstParagraph->s </p>
          <div className="text-night-light text-sm"> author->s </div>
        </div>
        <Link href> <a> <Button> "Read Article"->s </Button> </a> </Link>
      </div>
    </section>;
  };
};

[@react.component]
let default = () => {
  let posts = Data.getAllBlogPosts();

  let posts = Belt.Array.concatMany([|posts, posts, posts, posts|]);

  let content =
    if (Array.length(posts) === 0) {
      <div> "No blog posts available yet"->s </div>;
    } else {
      let first = Belt.Array.getExn(posts, 0);
      let rest = Js.Array2.sliceFrom(posts, 1);

      <div
        className="grid grid-cols-1 xs:grid-cols-3 gap-20 row-gap-40 w-full">
        <div className="col-span-3 row-span-3">
          <FeatureCard
            imgUrl=?{first.frontmatter.imgUrl}
            title=?{first.content.title}
            author={first.frontmatter.author}
            firstParagraph=?{first.content.firstParagraph}
            date={first.frontmatter.date->Js.Date.fromString}
            href={"/blog/" ++ first.id}
          />
        </div>
        {Belt.Array.mapWithIndex(rest, (i, post) => {
           <BlogCard
             key={post.id ++ Belt.Int.toString(i)}
             imgUrl=?{post.frontmatter.imgUrl}
             title=?{post.content.title}
             author={post.frontmatter.author}
             date={post.frontmatter.date->Js.Date.fromString}
             href={"/blog/" ++ post.id}
           />
         })
         ->ate}
      </div>;
    };

  <div> content </div>;
};
