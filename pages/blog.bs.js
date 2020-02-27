

import * as Mdx from "../common/Mdx.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Markdown from "../components/Markdown.bs.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";

function extractContent(mdx) {
  var match = Mdx.MdxChildren.classify(mdx);
  if (match.tag === /* Element */1) {
    var children = Mdx.MdxChildren.getMdxChildren(match[0]);
    var match$1 = Mdx.MdxChildren.classify(children);
    if (match$1.tag === /* Array */2) {
      var elements = match$1[0];
      var title = undefined;
      var firstParagraph = undefined;
      var i = 0;
      var to_ = elements.length;
      while(i < to_ && (title === undefined || firstParagraph === undefined)) {
        var el = Belt_Array.getExn(elements, i);
        var match$2 = Mdx.getMdxType(el);
        switch (match$2) {
          case "h1" :
              title = Mdx.MdxChildren.flatten(el).join(" ");
              break;
          case "p" :
              firstParagraph = Mdx.MdxChildren.flatten(el).join(" ");
              break;
          default:
            
        }
        i = i + 1 | 0;
      };
      return {
              title: title,
              firstParagraph: firstParagraph
            };
    } else {
      return ;
    }
  }
  
}

var validate = (function(json) {
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
      });

var BlogPost = {
  extractContent: extractContent,
  validate: validate
};

function getMdxModule (ctx,filepath){{ return ctx(filepath); }};

var blogCtx = (require.context('../pages/blog', true, /^\.\/.*\.mdx$/));

function toMdxModules(ctx) {
  return Belt_Array.reduce(Curry._1(ctx.keys, /* () */0), [], (function (acc, filepath) {
                var match = filepath.match(/\.\/(.*)\.mdx/);
                var id = match !== null && match.length === 2 ? match[1] : filepath;
                var correctFilepath = function (path) {
                  return path.replace(/^\.\//, "./pages/blog/");
                };
                var m = getMdxModule(ctx, filepath);
                var match$1 = validate(m);
                if (match$1 !== undefined) {
                  var match$2 = match$1;
                  var element = Curry._1(match$2.default, /* () */0);
                  var content = extractContent(element);
                  if (content !== undefined) {
                    var content$1 = content;
                    if (content$1.title !== undefined) {
                      return acc.concat([{
                                    id: id,
                                    filepath: correctFilepath(filepath),
                                    meta: match$2.meta,
                                    content: content$1
                                  }]);
                    } else {
                      console.log("h1 title is missing in " + filepath);
                      return acc;
                    }
                  } else {
                    return acc;
                  }
                } else {
                  console.log("Could not parse blog post " + filepath);
                  return acc;
                }
              }));
}

function getAllBlogPosts(param) {
  return toMdxModules(blogCtx);
}

var Data = {
  BlogPost: BlogPost,
  getMdxModule: getMdxModule,
  blogCtx: blogCtx,
  toMdxModules: toMdxModules,
  getAllBlogPosts: getAllBlogPosts
};

function Blog$default(Props) {
  var posts = toMdxModules(blogCtx);
  var content = posts.length === 0 ? React.createElement("div", undefined, Util.ReactStuff.s("No blog posts available yet")) : React.createElement("div", {
          className: "grid grid-cols-3 w-full"
        }, Util.ReactStuff.ate(Belt_Array.map(posts, (function (post) {
                    return React.createElement("div", {
                                key: post.id
                              }, Util.ReactStuff.s(post.id));
                  }))));
  return React.createElement("div", undefined, React.createElement(Markdown.H1.make, {
                  children: Util.ReactStuff.s("Blog")
                }), content);
}

var $$default = Blog$default;

export {
  Data ,
  $$default ,
  $$default as default,
  
}
/* blogCtx Not a pure module */
