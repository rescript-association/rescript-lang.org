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
    hierarchy with `https://reasonml.org/blog/[some-slug]`, without carrying
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
  };

  [@bs.module "gray-matter"] external matter: string => output = "default";
};

let postsDirectory = Node.Path.join2(Node.Process.cwd(), "./_blogposts");

let subdirs = [|"compiler", "community", "docs", "syntax", "ecosystem"|];

type fileGroup = {
  subdir: option(string),
  mdxFiles: array(string),
};

let getGroupedFiles = (): array(fileGroup) => {
  let dirs =
    Belt.Array.map(subdirs, d => Some(d))->Js.Array.concat([|None|], _);

  Belt.Array.reduce(
    dirs,
    [||],
    (acc, subdir) => {
      let fullpath =
        Belt.Option.mapWithDefault(subdir, postsDirectory, sub => {
          Node.Path.join2(postsDirectory, sub)
        });

      if (Node.Fs.existsSync(fullpath)) {
        let mdxFiles =
          Node.(
            Fs.readdirSync(fullpath)
            ->Belt.Array.keep(slug => Js.String2.endsWith(slug, ".mdx"))
          );

        if (Belt.Array.length(mdxFiles) > 0) {
          Js.Array.concat(acc, [|{subdir, mdxFiles}|]);
        } else {
          acc;
        };
      } else {
        acc;
      };
    },
  );
};

type postData = {
  slug: string,
  content: string,
  fullslug: string,
  frontmatter: Js.Json.t,
};

let getPostBySlug = (~subdir: option(string)=?, filepath: string): postData => {
  let slug = Js.String2.replaceByRe(filepath, [%re "/\.mdx?/"], "");

  let fullslug =
    switch (subdir) {
    | Some(subdir) => subdir ++ "/" ++ slug
    | None => slug
    };

  let fullPath = Node.Path.join2(postsDirectory, fullslug ++ ".mdx");

  let fileContents = Node.Fs.readFileSync(fullPath, `utf8);
  let {GrayMatter.data, content} = GrayMatter.matter(fileContents);

  {slug, fullslug, content, frontmatter: data};
};

let getFullSlug = (slug: string) => {
  // This function might be terribly inefficient
  // and could be optimized

  let filepathEqualSlug = (filepath, slug) => {
    slug === Js.String2.replaceByRe(filepath, [%re "/\.mdx?/"], "");
  };

  getGroupedFiles()
  ->Js.Array2.find(({mdxFiles}) => {
      Js.Array2.some(mdxFiles, filepath => {
        filepathEqualSlug(filepath, slug)
      })
    })
  ->Belt.Option.flatMap(({subdir, mdxFiles}) => {
      Js.Array2.find(mdxFiles, filepath => {
        filepathEqualSlug(filepath, slug)
      })
      ->Belt.Option.map(filepath => {
          let slug = Js.String2.replaceByRe(filepath, [%re "/\.mdx?/"], "");
          let fullslug =
            switch (subdir) {
            | Some(subdir) => subdir ++ "/" ++ slug
            | None => slug
            };
          fullslug;
        })
    });
};

let getAllPosts = () => {
  let results = getGroupedFiles();

  Belt.Array.reduce(results, [||], (acc, {subdir, mdxFiles}) => {
    Belt.Array.concat(
      acc,
      Belt.Array.map(mdxFiles, filepath => getPostBySlug(~subdir?, filepath)),
    )
  });
};
