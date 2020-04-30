

import * as Fs from "fs";
import * as Path from "path";
import * as Process from "process";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as GrayMatter from "gray-matter";

var GrayMatter$1 = { };

var postsDirectory = Path.join(Process.cwd(), "./_blogposts");

var subdirs = [
  "compiler",
  "community",
  "docs",
  "syntax",
  "ecosystem"
];

function getGroupedFiles(param) {
  var __x = Belt_Array.map(subdirs, (function (d) {
          return d;
        }));
  var dirs = __x.concat([undefined]);
  return Belt_Array.reduce(dirs, [], (function (acc, subdir) {
                var fullpath = Belt_Option.mapWithDefault(subdir, postsDirectory, (function (sub) {
                        return Path.join(postsDirectory, sub);
                      }));
                if (Fs.existsSync(fullpath)) {
                  var mdxFiles = Belt_Array.keep(Fs.readdirSync(fullpath), (function (slug) {
                          return slug.endsWith(".mdx");
                        }));
                  if (mdxFiles.length !== 0) {
                    return [{
                                subdir: subdir,
                                mdxFiles: mdxFiles
                              }].concat(acc);
                  } else {
                    return acc;
                  }
                } else {
                  return acc;
                }
              }));
}

function getPostBySlug(subdir, filepath) {
  var slug = filepath.replace(/\.mdx?/, "");
  var fullslug = subdir !== undefined ? subdir + ("/" + slug) : slug;
  var fullPath = Path.join(postsDirectory, fullslug + ".mdx");
  var fileContents = Fs.readFileSync(fullPath, "utf8");
  var match = GrayMatter.default(fileContents);
  return {
          slug: slug,
          content: match.content,
          fullslug: fullslug,
          frontmatter: match.data
        };
}

function getFullSlug(slug) {
  var filepathEqualSlug = function (filepath, slug) {
    return slug === filepath.replace(/\.mdx?/, "");
  };
  return Belt_Option.flatMap(Caml_option.undefined_to_opt(getGroupedFiles(/* () */0).find((function (param) {
                        return param.mdxFiles.some((function (filepath) {
                                      return filepathEqualSlug(filepath, slug);
                                    }));
                      }))), (function (param) {
                var subdir = param.subdir;
                return Belt_Option.map(Caml_option.undefined_to_opt(param.mdxFiles.find((function (filepath) {
                                      return filepathEqualSlug(filepath, slug);
                                    }))), (function (filepath) {
                              var slug = filepath.replace(/\.mdx?/, "");
                              if (subdir !== undefined) {
                                return subdir + ("/" + slug);
                              } else {
                                return slug;
                              }
                            }));
              }));
}

function getAllPosts(param) {
  var results = getGroupedFiles(/* () */0);
  return Belt_Array.reduce(results, [], (function (acc, param) {
                var subdir = param.subdir;
                return Belt_Array.concat(acc, Belt_Array.map(param.mdxFiles, (function (filepath) {
                                  return getPostBySlug(subdir, filepath);
                                })));
              }));
}

export {
  GrayMatter$1 as GrayMatter,
  postsDirectory ,
  subdirs ,
  getGroupedFiles ,
  getPostBySlug ,
  getFullSlug ,
  getAllPosts ,
  
}
/* postsDirectory Not a pure module */
