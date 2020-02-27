

import * as Icon from "../components/Icon.bs.js";
import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Js_json from "bs-platform/lib/es6/js_json.js";
import * as Link from "next/link";
import * as MainLayout from "./MainLayout.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

function validate(json) {
  var match = Js_json.classify(json);
  if (typeof match === "number" || match.tag !== /* JSONObject */2) {
    return /* Error */Caml_chrome_debugger.variant("Error", 1, ["Given json is not an object"]);
  } else {
    var obj = match[0];
    var authorJson = Belt_Option.mapWithDefault(Js_dict.get(obj, "author"), undefined, (function (json) {
            return Js_json.classify(json);
          }));
    var dateJson = Belt_Option.mapWithDefault(Js_dict.get(obj, "date"), undefined, (function (json) {
            return Js_json.classify(json);
          }));
    if (authorJson !== undefined) {
      var match$1 = authorJson;
      if (typeof match$1 !== "number" && !match$1.tag) {
        if (dateJson !== undefined) {
          var match$2 = dateJson;
          if (typeof match$2 === "number" || match$2.tag) {
            return /* Error */Caml_chrome_debugger.variant("Error", 1, ["json.date not a string"]);
          } else {
            return /* Ok */Caml_chrome_debugger.variant("Ok", 0, [{
                        author: match$1[0],
                        date: new Date(match$2[0])
                      }]);
          }
        } else {
          return /* Error */Caml_chrome_debugger.variant("Error", 1, ["json.date not a string"]);
        }
      }
      
    }
    if (dateJson !== undefined && !(typeof dateJson === "number" || dateJson.tag)) {
      return /* Error */Caml_chrome_debugger.variant("Error", 1, ["json.author not a string"]);
    } else {
      return /* Error */Caml_chrome_debugger.variant("Error", 1, ["json.author / json.date not a string"]);
    }
  }
}

var FrontMatter = {
  validate: validate
};

function BlogArticleLayout(Props) {
  Props.author;
  var date = Props.date;
  var children = Props.children;
  return React.createElement(MainLayout.make, {
              children: null
            }, React.createElement("div", {
                  className: "text-night-light text-lg mb-4"
                }, Util.ReactStuff.s(Util.$$Date.toDayMonthYear(date))), children, React.createElement("div", {
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

var Link$1 = /* alias */0;

var make = BlogArticleLayout;

export {
  Link$1 as Link,
  FrontMatter ,
  make ,
  
}
/* Icon Not a pure module */
