// Same design as in the official nextjs blog starter template
// https://github.com/zeit/next.js/blob/canary/examples/blog-starter/lib/api.js

module GrayMatter = {
  type output = {
    data: Js.Json.t,
    content: string,
  };

  [@bs.module "gray-matter"] external matter: string => output = "default";
};

let postsDirectory = Node.Path.join2(Node.Process.cwd(), "./_blogposts");

let getPostSlugs = (): array(string) => {
  Node.Fs.readdirSync(postsDirectory);
};

type postData = {
  slug: string,
  content: string,
  frontmatter: Js.Json.t,
};

let getPostBySlug = (~fields: array(string)=[||], slug: string): postData => {
  let realSlug = Js.String2.replaceByRe(slug, [%re "/\.mdx?/"], "");

  let fullPath = Node.Path.join2(postsDirectory, realSlug ++ ".mdx");

  let fileContents = Node.Fs.readFileSync(fullPath, `utf8);
  let {GrayMatter.data, content} = GrayMatter.matter(fileContents);

  {slug: realSlug, content, frontmatter: data};
};

let getAllPosts = () => {
  let slugs =
    getPostSlugs()->Belt.Array.keep(slug => Js.String2.endsWith(slug, ".mdx"));
  Belt.Array.map(slugs, slug => getPostBySlug(slug));
};
