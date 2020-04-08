

import * as Icon from "../components/Icon.bs.js";
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

var Params = { };

var frontmatter = (function(component) {
        if(typeof component.frontmatter === "object") {
          return component.frontmatter;
        }
        return {};
      });

var BlogComponent = {
  frontmatter: frontmatter
};

var cwd = Process.cwd();

function $$default(props) {
  var module_ = require("../_blogposts/" + (props.slug + ".mdx"));
  var component = module_.default;
  var fm = BlogFrontmatter.decode(frontmatter(component));
  var children = React.createElement(component, { });
  var content;
  if (fm.tag) {
    content = React.createElement("div", undefined, React.createElement(Markdown.Warn.make, {
              children: null
            }, React.createElement("h2", {
                  className: "font-bold text-night-dark text-2xl mb-2"
                }, Util.ReactStuff.s("Could not parse file '_blogposts/" + (props.slug + ".mdx'"))), React.createElement("p", undefined, Util.ReactStuff.s("The content of this blog post will be displayed as soon as all\n            required frontmatter data has been added.")), React.createElement("p", {
                  className: "font-bold mt-4"
                }, Util.ReactStuff.s("Errors:")), Util.ReactStuff.s(fm[0])));
  } else {
    var match = fm[0];
    var author = match.author;
    var date = DateStr.toDate(match.date);
    var match$1 = author.social;
    var tmp;
    if (match$1 !== null) {
      var href = BlogFrontmatter.Author.socialUrl(match$1) + ("/" + author.username);
      tmp = React.createElement("a", {
            className: "hover:text-night",
            href: href,
            rel: "noopener noreferrer",
            target: "_blank"
          }, Util.ReactStuff.s("@" + author.username));
    } else {
      tmp = Util.ReactStuff.s(author.username);
    }
    content = React.createElement(React.Fragment, undefined, React.createElement("div", {
              className: "text-night-light text-lg mb-6"
            }, Util.ReactStuff.s(Util.$$Date.toDayMonthYear(date))), React.createElement("h1", {
              className: "text-48 text-night-dark"
            }, Util.ReactStuff.s(match.title)), Belt_Option.mapWithDefault(Caml_option.null_to_opt(match.description), null, (function (desc) {
                return React.createElement("div", {
                            className: "my-8"
                          }, React.createElement(Markdown.Intro.make, {
                                children: Util.ReactStuff.s(desc)
                              }));
              })), React.createElement("div", {
              className: "flex mb-20 items-center"
            }, React.createElement("div", {
                  className: "w-12 h-12 bg-berry block rounded-full mr-3"
                }, React.createElement("img", {
                      className: "h-full w-full rounded-full",
                      src: "https://pbs.twimg.com/profile_images/1185576475837304839/hvCe6M2r_200x200.jpg"
                    })), React.createElement("div", {
                  className: "text-18 text-night-dark"
                }, tmp, React.createElement("div", {
                      className: "text-night-light"
                    }, Util.ReactStuff.s("Reason Association")))), children, React.createElement("div", {
              className: "border-t border-snow-darker mt-8 pt-24 flex flex-col items-center"
            }, React.createElement("div", {
                  className: "text-4xl text-night-dark font-medium"
                }, Util.ReactStuff.s("Want to read more?")), React.createElement(Link.default, {
                  href: "/blog",
                  children: React.createElement("a", {
                        className: "text-fire hover:text-fire-80"
                      }, Util.ReactStuff.s("Back to Overview"), React.createElement(Icon.ArrowRight.make, {
                            className: "ml-2 inline-block"
                          }))
                })));
  }
  return React.createElement(MainLayout.make, {
              children: content
            });
}

function getStaticProps(ctx) {
  var props = {
    slug: ctx.params.slug
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
  cwd ,
  $$default ,
  $$default as default,
  getStaticProps ,
  getStaticPaths ,
  
}
/* cwd Not a pure module */
