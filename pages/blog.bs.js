

import * as Mdx from "../common/Mdx.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Button from "../components/Button.bs.js";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";

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
      });

var BlogPost = {
  extractContent: extractContent,
  validate: validate
};

function getMdxModule (ctx,filepath){{ return ctx(filepath); }};

var blogCtx = (require.context('../pages/blog', true, /^\.\/.*\.mdx$/));

function readPosts(ctx) {
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
                                    frontmatter: match$2.frontmatter,
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

function orderByDate(posts) {
  return posts.slice().sort((function (a, b) {
                var aV = new Date(a.frontmatter.date).valueOf();
                var bV = new Date(b.frontmatter.date).valueOf();
                if (aV === bV) {
                  return 0;
                } else if (aV > bV) {
                  return -1;
                } else {
                  return 1;
                }
              }));
}

function getAllBlogPosts(param) {
  return orderByDate(readPosts(blogCtx));
}

var Data = {
  BlogPost: BlogPost,
  getMdxModule: getMdxModule,
  blogCtx: blogCtx,
  readPosts: readPosts,
  orderByDate: orderByDate,
  getAllBlogPosts: getAllBlogPosts
};

function Blog$BlogCard(Props) {
  var imgUrl = Props.imgUrl;
  var $staropt$star = Props.title;
  var author = Props.author;
  Props.tags;
  var date = Props.date;
  var href = Props.href;
  var title = $staropt$star !== undefined ? $staropt$star : "Unknown Title";
  return React.createElement("section", {
              className: "h-full"
            }, React.createElement(Link.default, {
                  href: href,
                  children: React.createElement("a", undefined, React.createElement("div", undefined, imgUrl !== undefined ? React.createElement("img", {
                                  className: "mb-4",
                                  src: imgUrl
                                }) : null, React.createElement("h2", {
                                className: "text-night-dark text-2xl"
                              }, Util.ReactStuff.s(title)), React.createElement("div", {
                                className: "text-night-light text-sm"
                              }, Util.ReactStuff.s(author), Util.ReactStuff.s(" · "), Util.ReactStuff.s(Util.$$Date.toDayMonthYear(date)))))
                }));
}

var BlogCard = {
  make: Blog$BlogCard
};

function Blog$FeatureCard(Props) {
  var imgUrl = Props.imgUrl;
  var $staropt$star = Props.title;
  var author = Props.author;
  Props.date;
  var $staropt$star$1 = Props.firstParagraph;
  var href = Props.href;
  var title = $staropt$star !== undefined ? $staropt$star : "Unknown Title";
  var firstParagraph = $staropt$star$1 !== undefined ? $staropt$star$1 : "";
  return React.createElement("section", {
              className: "flex h-full"
            }, React.createElement("div", {
                  className: "w-1/2 h-full"
                }, React.createElement(Link.default, {
                      href: href,
                      children: React.createElement("a", undefined, imgUrl !== undefined ? React.createElement("img", {
                                  className: "h-full w-full object-cover",
                                  src: imgUrl
                                }) : React.createElement("div", {
                                  className: "bg-night-light"
                                }))
                    })), React.createElement("div", {
                  className: "w-1/2 mt-8 ml-16"
                }, React.createElement("h2", {
                      className: "text-night-dark font-semibold text-6xl"
                    }, Util.ReactStuff.s(title)), React.createElement("div", {
                      className: "mb-4"
                    }, React.createElement("p", {
                          className: "text-night-dark text-lg"
                        }, Util.ReactStuff.s(firstParagraph)), React.createElement("div", {
                          className: "text-night-light text-sm"
                        }, Util.ReactStuff.s(author))), React.createElement(Link.default, {
                      href: href,
                      children: React.createElement("a", undefined, React.createElement(Button.make, {
                                children: Util.ReactStuff.s("Read Article")
                              }))
                    })));
}

var FeatureCard = {
  make: Blog$FeatureCard
};

function Blog$default(Props) {
  var posts = orderByDate(readPosts(blogCtx));
  var posts$1 = Belt_Array.concatMany([
        posts,
        posts,
        posts,
        posts
      ]);
  var content;
  if (posts$1.length === 0) {
    content = React.createElement("div", undefined, Util.ReactStuff.s("No blog posts available yet"));
  } else {
    var first = Belt_Array.getExn(posts$1, 0);
    var rest = posts$1.slice(1);
    var tmp = {
      author: first.frontmatter.author,
      date: new Date(first.frontmatter.date),
      href: "/blog/" + first.id
    };
    if (first.frontmatter.imgUrl !== undefined) {
      tmp.imgUrl = Caml_option.valFromOption(first.frontmatter.imgUrl);
    }
    if (first.content.title !== undefined) {
      tmp.title = Caml_option.valFromOption(first.content.title);
    }
    if (first.content.firstParagraph !== undefined) {
      tmp.firstParagraph = Caml_option.valFromOption(first.content.firstParagraph);
    }
    content = React.createElement("div", {
          className: "grid grid-cols-1 xs:grid-cols-3 gap-20 row-gap-40 w-full"
        }, React.createElement("div", {
              className: "col-span-3 row-span-3"
            }, React.createElement(Blog$FeatureCard, tmp)), Util.ReactStuff.ate(Belt_Array.mapWithIndex(rest, (function (i, post) {
                    var tmp = {
                      author: post.frontmatter.author,
                      date: new Date(post.frontmatter.date),
                      href: "/blog/" + post.id,
                      key: post.id + String(i)
                    };
                    if (post.frontmatter.imgUrl !== undefined) {
                      tmp.imgUrl = Caml_option.valFromOption(post.frontmatter.imgUrl);
                    }
                    if (post.content.title !== undefined) {
                      tmp.title = Caml_option.valFromOption(post.content.title);
                    }
                    return React.createElement(Blog$BlogCard, tmp);
                  }))));
  }
  return React.createElement("div", undefined, content);
}

var Link$1 = /* alias */0;

var $$default = Blog$default;

export {
  Link$1 as Link,
  Data ,
  BlogCard ,
  FeatureCard ,
  $$default ,
  $$default as default,
  
}
/* blogCtx Not a pure module */
