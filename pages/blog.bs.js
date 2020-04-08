

import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Button from "../components/Button.bs.js";
import * as BlogApi from "../common/BlogApi.bs.js";
import * as DateStr from "../common/DateStr.bs.js";
import * as $$Promise from "reason-promise/src/js/promise.js";
import * as Markdown from "../components/Markdown.bs.js";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as BlogFrontmatter from "../common/BlogFrontmatter.bs.js";

function Blog$BlogCard(Props) {
  var previewImg = Props.previewImg;
  var $staropt$star = Props.title;
  var author = Props.author;
  Props.tags;
  var date = Props.date;
  var slug = Props.slug;
  var title = $staropt$star !== undefined ? $staropt$star : "Unknown Title";
  var match = author.social;
  var tmp;
  if (match !== null) {
    var href = BlogFrontmatter.Author.socialUrl(match) + ("/" + author.username);
    tmp = React.createElement("a", {
          className: "hover:text-night",
          href: href,
          rel: "noopener noreferrer",
          target: "_blank"
        }, Util.ReactStuff.s(author.username));
  } else {
    tmp = Util.ReactStuff.s(author.username);
  }
  return React.createElement("section", {
              className: "h-full"
            }, React.createElement("div", undefined, React.createElement(Link.default, {
                      href: "/blog/[slug]",
                      as: "/blog/" + slug,
                      children: React.createElement("a", undefined, previewImg !== undefined ? React.createElement("img", {
                                  className: "mb-4",
                                  src: previewImg
                                }) : null)
                    }), React.createElement(Link.default, {
                      href: "/blog/[slug]",
                      as: "/blog/" + slug,
                      children: React.createElement("a", undefined, React.createElement("h2", {
                                className: "inline-block text-night-dark text-2xl"
                              }, Util.ReactStuff.s(title)))
                    })), React.createElement("div", {
                  className: "text-night-light text-sm"
                }, tmp, Util.ReactStuff.s(" · "), Util.ReactStuff.s(Util.$$Date.toDayMonthYear(date))));
}

var BlogCard = {
  make: Blog$BlogCard
};

function Blog$FeatureCard(Props) {
  var previewImg = Props.previewImg;
  var $staropt$star = Props.title;
  var author = Props.author;
  var date = Props.date;
  var $staropt$star$1 = Props.firstParagraph;
  var slug = Props.slug;
  var title = $staropt$star !== undefined ? $staropt$star : "Unknown Title";
  var firstParagraph = $staropt$star$1 !== undefined ? $staropt$star$1 : "";
  var match = author.social;
  var tmp;
  if (match !== null) {
    var href = BlogFrontmatter.Author.socialUrl(match) + ("/" + author.username);
    tmp = React.createElement("a", {
          className: "hover:text-night",
          href: href,
          rel: "noopener noreferrer",
          target: "_blank"
        }, Util.ReactStuff.s(author.username));
  } else {
    tmp = Util.ReactStuff.s(author.username);
  }
  return React.createElement("section", {
              className: "flex h-full"
            }, React.createElement("div", {
                  className: "w-1/2 h-full"
                }, React.createElement(Link.default, {
                      href: "/blog/[slug]",
                      as: "/blog/" + slug,
                      children: React.createElement("a", undefined, previewImg !== undefined ? React.createElement("img", {
                                  className: "h-full w-full object-cover",
                                  src: previewImg
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
                          className: "text-night-light text-sm mt-2 mb-8"
                        }, Util.ReactStuff.s("by "), tmp, Util.ReactStuff.s(" · "), Util.ReactStuff.s(Util.$$Date.toDayMonthYear(date)))), React.createElement(Link.default, {
                      href: "/blog/[slug]",
                      as: "/blog/" + slug,
                      children: React.createElement("a", undefined, React.createElement(Button.make, {
                                children: Util.ReactStuff.s("Read Article")
                              }))
                    })));
}

var FeatureCard = {
  make: Blog$FeatureCard
};

function orderByDate(posts) {
  return posts.slice().sort((function (a, b) {
                var aV = DateStr.toDate(a.frontmatter.date).valueOf();
                var bV = DateStr.toDate(b.frontmatter.date).valueOf();
                if (aV === bV) {
                  return 0;
                } else if (aV > bV) {
                  return -1;
                } else {
                  return 1;
                }
              }));
}

var Post = {
  orderByDate: orderByDate
};

var Malformed = { };

function $$default(props) {
  var malformed = props.malformed;
  var posts = props.posts;
  var errorBox = process.env.ENV === "development" && malformed.length !== 0 ? React.createElement("div", {
          className: "mb-12"
        }, React.createElement(Markdown.Warn.make, {
              children: null
            }, React.createElement("h2", {
                  className: "font-bold text-night-dark text-2xl mb-2"
                }, Util.ReactStuff.s("Some Blog Posts are Malformed!")), React.createElement("p", undefined, Util.ReactStuff.s("Any blog post with invalid data will not be displayed in production.")), React.createElement("div", undefined, React.createElement("p", {
                      className: "font-bold mt-4"
                    }, Util.ReactStuff.s("Errors:")), React.createElement("ul", undefined, Util.ReactStuff.ate(Belt_Array.map(malformed, (function (m) {
                                return React.createElement("li", {
                                            className: "list-disc ml-5"
                                          }, Util.ReactStuff.s("pages/blog/" + (m.id + (".mdx: " + m.message))));
                              }))))))) : null;
  var content;
  if (posts.length === 0) {
    content = React.createElement("div", undefined, Util.ReactStuff.s("Currently no posts available"));
  } else {
    var first = Belt_Array.getExn(posts, 0);
    var rest = posts.slice(1);
    var tmp = {
      title: first.frontmatter.title,
      author: first.frontmatter.author,
      date: DateStr.toDate(first.frontmatter.date),
      slug: first.id
    };
    var tmp$1 = Caml_option.null_to_opt(first.frontmatter.previewImg);
    if (tmp$1 !== undefined) {
      tmp.previewImg = Caml_option.valFromOption(tmp$1);
    }
    var tmp$2 = Caml_option.null_to_opt(first.frontmatter.description);
    if (tmp$2 !== undefined) {
      tmp.firstParagraph = Caml_option.valFromOption(tmp$2);
    }
    content = React.createElement("div", {
          className: "grid grid-cols-1 xs:grid-cols-3 gap-20 row-gap-40 w-full"
        }, React.createElement("div", {
              className: "col-span-3 row-span-3"
            }, React.createElement(Blog$FeatureCard, tmp)), Util.ReactStuff.ate(Belt_Array.mapWithIndex(rest, (function (i, post) {
                    var tmp = {
                      title: post.frontmatter.title,
                      author: post.frontmatter.author,
                      date: DateStr.toDate(post.frontmatter.date),
                      slug: post.id,
                      key: post.id + String(i)
                    };
                    var tmp$1 = Caml_option.null_to_opt(post.frontmatter.previewImg);
                    if (tmp$1 !== undefined) {
                      tmp.previewImg = Caml_option.valFromOption(tmp$1);
                    }
                    return React.createElement(Blog$BlogCard, tmp);
                  }))));
  }
  return React.createElement("div", undefined, errorBox, content);
}

function getStaticProps(_ctx) {
  var match = Belt_Array.reduce(BlogApi.getAllPosts(/* () */0), /* tuple */[
        [],
        []
      ], (function (acc, postData) {
          var malformed = acc[1];
          var posts = acc[0];
          var id = postData.slug;
          var decoded = BlogFrontmatter.decode(postData.frontmatter);
          if (decoded.tag) {
            var m_message = decoded[0];
            var m = {
              id: id,
              message: m_message
            };
            var malformed$1 = Belt_Array.concat(malformed, [m]);
            return /* tuple */[
                    posts,
                    malformed$1
                  ];
          } else {
            var p_frontmatter = decoded[0];
            var p = {
              id: id,
              frontmatter: p_frontmatter
            };
            var posts$1 = Belt_Array.concat(posts, [p]);
            return /* tuple */[
                    posts$1,
                    malformed
                  ];
          }
        }));
  var props_posts = orderByDate(match[0]);
  var props_malformed = match[1];
  var props = {
    posts: props_posts,
    malformed: props_malformed
  };
  return $$Promise.resolved({
              props: props
            });
}

var Link$1 = /* alias */0;

export {
  Link$1 as Link,
  BlogCard ,
  FeatureCard ,
  Post ,
  Malformed ,
  $$default ,
  $$default as default,
  getStaticProps ,
  
}
/* react Not a pure module */
