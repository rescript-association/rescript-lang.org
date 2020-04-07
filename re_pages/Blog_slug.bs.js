

import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as BlogApi from "../common/BlogApi.bs.js";
import * as $$Promise from "reason-promise/src/js/promise.js";
import * as Process from "process";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as BlogArticleLayout from "../layouts/BlogArticleLayout.bs.js";

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
  console.log("module", module_);
  var component = module_.default;
  var fm = BlogArticleLayout.FrontMatter.decode(frontmatter(component));
  var content = React.createElement(component, { });
  if (fm.tag) {
    return React.createElement("div", undefined, Util.ReactStuff.s("Couldn't parse frontmatter for \"blog/" + (props.slug + ("\": " + fm[0]))), content);
  } else {
    var match = fm[0];
    return React.createElement(BlogArticleLayout.make, {
                author: match.author,
                date: BlogArticleLayout.DateStr.toDate(match.date),
                children: content
              });
  }
}

function getStaticProps(ctx) {
  var params = ctx.params;
  console.log("params:", params);
  console.log("cwd", Process.cwd());
  var props_slug = params.slug;
  var props_mdxFile = "../../_blogposts/" + (params.slug + ".mdx");
  var props = {
    slug: props_slug,
    mdxFile: props_mdxFile
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
