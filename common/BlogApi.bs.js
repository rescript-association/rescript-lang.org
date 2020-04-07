

import * as Fs from "fs";
import * as Path from "path";
import * as Process from "process";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as GrayMatter from "gray-matter";

var GrayMatter$1 = { };

var postsDirectory = Path.join(Process.cwd(), "./_blogposts");

function getPostSlugs(param) {
  return Fs.readdirSync(postsDirectory);
}

function getPostBySlug($staropt$star, slug) {
  var realSlug = slug.replace(/\.mdx?/, "");
  var fullPath = Path.join(postsDirectory, realSlug + ".mdx");
  var fileContents = Fs.readFileSync(fullPath, "utf8");
  var match = GrayMatter.default(fileContents);
  return {
          slug: realSlug,
          content: match.content,
          frontmatter: match.data
        };
}

function getAllPosts(param) {
  var slugs = Belt_Array.keep(Fs.readdirSync(postsDirectory), (function (slug) {
          return slug.endsWith(".mdx");
        }));
  return Belt_Array.map(slugs, (function (slug) {
                return getPostBySlug(undefined, slug);
              }));
}

export {
  GrayMatter$1 as GrayMatter,
  postsDirectory ,
  getPostSlugs ,
  getPostBySlug ,
  getAllPosts ,
  
}
/* postsDirectory Not a pure module */
