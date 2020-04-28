

import * as Icon from "../components/Icon.bs.js";
import * as Meta from "../components/Meta.bs.js";
import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as BlogApi from "../common/BlogApi.bs.js";
import * as DateStr from "../common/DateStr.bs.js";
import * as $$Promise from "reason-promise/src/js/promise.js";
import * as Process from "process";
import * as Markdown from "../components/Markdown.bs.js";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MainLayout from "../layouts/MainLayout.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as BlogFrontmatter from "../common/BlogFrontmatter.bs.js";
import * as NameInitialsAvatar from "../components/NameInitialsAvatar.bs.js";

var Params = { };

var frontmatter = (function(component) {
        if(typeof component.frontmatter === "object") { return component.frontmatter; }
        return {};
      });

var BlogComponent = {
  frontmatter: frontmatter
};

function Blog_Article$Line(Props) {
  return React.createElement("div", {
              className: "block border-t border-snow-darker"
            });
}

var Line = {
  make: Blog_Article$Line
};

function Blog_Article$BlogHeader(Props) {
  var date = Props.date;
  var author = Props.author;
  var title = Props.title;
  var category = Props.category;
  var description = Props.description;
  var articleImg = Props.articleImg;
  var date$1 = DateStr.toDate(date);
  var displayName = BlogFrontmatter.Author.getDisplayName(author);
  var match = author.imgUrl;
  var authorImg = match !== null ? React.createElement("img", {
          className: "h-full w-full rounded-full",
          src: match
        }) : React.createElement(NameInitialsAvatar.make, {
          displayName: displayName
        });
  var match$1 = author.twitter;
  return React.createElement("div", {
              className: "flex flex-col items-center"
            }, React.createElement("div", {
                  className: "w-full max-w-705"
                }, React.createElement("div", {
                      className: "text-night-light text-lg mb-5"
                    }, Util.ReactStuff.s(category), Util.ReactStuff.s(" · "), Util.ReactStuff.s(Util.$$Date.toDayMonthYear(date$1))), React.createElement("h1", {
                      className: "text-onyx font-semibold text-42 leading-2"
                    }, Util.ReactStuff.s(title)), Belt_Option.mapWithDefault(description, null, (function (desc) {
                        if (desc === "") {
                          return React.createElement("div", {
                                      className: "mb-8"
                                    });
                        } else {
                          return React.createElement("div", {
                                      className: "my-8 text-onyx"
                                    }, React.createElement(Markdown.Intro.make, {
                                          children: Util.ReactStuff.s(desc)
                                        }));
                        }
                      })), React.createElement("div", {
                      className: "flex mb-12 items-center"
                    }, React.createElement("div", {
                          className: "w-12 h-12 bg-berry-40 block rounded-full mr-3"
                        }, authorImg), React.createElement("div", {
                          className: "text-14 font-medium text-night-dark"
                        }, match$1 !== null ? React.createElement("a", {
                                className: "hover:text-night",
                                href: "https://twitter.com/" + match$1,
                                rel: "noopener noreferrer",
                                target: "_blank"
                              }, Util.ReactStuff.s(displayName)) : Util.ReactStuff.s(displayName), React.createElement("div", {
                              className: "text-night-light"
                            }, Util.ReactStuff.s(author.role))))), articleImg !== undefined ? React.createElement("div", {
                    className: "-mx-8 sm:mx-0 sm:w-full bg-night-10 md:mt-24"
                  }, React.createElement("img", {
                        className: "h-full w-full object-cover",
                        style: {
                          maxHeight: "33.625rem"
                        },
                        src: articleImg
                      })) : React.createElement("div", {
                    className: "max-w-705 w-full"
                  }, React.createElement(Blog_Article$Line, { })));
}

var BlogHeader = {
  make: Blog_Article$BlogHeader
};

var cwd = Process.cwd();

function $$default(props) {
  var fullslug = props.fullslug;
  var module_ = require("../_blogposts/" + (fullslug + ".mdx"));
  var component = module_.default;
  var authors = BlogFrontmatter.Author.getAllAuthors(/* () */0);
  var arg = frontmatter(component);
  var fm = (function (param) {
        return BlogFrontmatter.decode(param, arg);
      })(authors);
  var children = React.createElement(component, { });
  var content;
  if (fm.tag) {
    content = React.createElement("div", undefined, React.createElement(Markdown.Warn.make, {
              children: null
            }, React.createElement("h2", {
                  className: "font-bold text-night-dark text-2xl mb-2"
                }, Util.ReactStuff.s("Could not parse file '_blogposts/" + (fullslug + ".mdx'"))), React.createElement("p", undefined, Util.ReactStuff.s("The content of this blog post will be displayed as soon as all\n            required frontmatter data has been added.")), React.createElement("p", {
                  className: "font-bold mt-4"
                }, Util.ReactStuff.s("Errors:")), Util.ReactStuff.s(fm[0])));
  } else {
    var match = fm[0];
    var description = match.description;
    var title = match.title;
    var tmp = {
      title: title + " | Reason Blog"
    };
    var tmp$1 = description === null ? undefined : Caml_option.some(description);
    if (tmp$1 !== undefined) {
      tmp.description = Caml_option.valFromOption(tmp$1);
    }
    var tmp$2 = Caml_option.null_to_opt(match.canonical);
    if (tmp$2 !== undefined) {
      tmp.canonical = Caml_option.valFromOption(tmp$2);
    }
    var tmp$3 = Caml_option.null_to_opt(match.previewImg);
    if (tmp$3 !== undefined) {
      tmp.ogImage = Caml_option.valFromOption(tmp$3);
    }
    content = React.createElement("div", {
          className: "w-full"
        }, React.createElement(Meta.make, tmp), React.createElement("div", {
              className: "mb-10 md:mb-20"
            }, React.createElement(Blog_Article$BlogHeader, {
                  date: match.date,
                  author: match.author,
                  title: title,
                  category: BlogFrontmatter.Category.toString(match.category),
                  description: description === null ? undefined : Caml_option.some(description),
                  articleImg: Caml_option.null_to_opt(match.articleImg)
                })), React.createElement("div", {
              className: "flex justify-center"
            }, React.createElement("div", {
                  className: "max-w-705 w-full"
                }, children, React.createElement("div", {
                      className: "mt-12"
                    }, React.createElement(Blog_Article$Line, { }), React.createElement("div", {
                          className: "pt-20 flex flex-col items-center"
                        }, React.createElement("div", {
                              className: "text-3xl sm:text-4xl text-center text-night-dark font-medium"
                            }, Util.ReactStuff.s("Want to read more?")), React.createElement(Link.default, {
                              href: "/blog",
                              children: React.createElement("a", {
                                    className: "text-fire hover:text-fire-80"
                                  }, Util.ReactStuff.s("Back to Overview"), React.createElement(Icon.ArrowRight.make, {
                                        className: "ml-2 inline-block"
                                      }))
                            }))))));
  }
  return React.createElement(MainLayout.make, {
              children: content
            });
}

function getStaticProps(ctx) {
  var params = ctx.params;
  var fullslug = Belt_Option.getWithDefault(BlogApi.getFullSlug(params.slug), params.slug);
  var props = {
    fullslug: fullslug
  };
  return $$Promise.resolved({
              props: props
            });
}

function getStaticPaths(param) {
  var paths = Belt_Array.map(BlogApi.getAllPosts(/* () */0), (function (postData) {
          return {
                  params: {
                    slug: postData.slug
                  }
                };
        }));
  return $$Promise.resolved({
              paths: paths,
              fallback: false
            });
}

export {
  Params ,
  BlogComponent ,
  Line ,
  BlogHeader ,
  cwd ,
  $$default ,
  $$default as default,
  getStaticProps ,
  getStaticPaths ,
  
}
/* cwd Not a pure module */
