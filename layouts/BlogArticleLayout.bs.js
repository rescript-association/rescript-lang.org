

import * as Icon from "../components/Icon.bs.js";
import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Link from "next/link";
import * as MainLayout from "./MainLayout.bs.js";
import * as Json_decode from "@glennsl/bs-json/src/Json_decode.bs.js";
import * as Caml_js_exceptions from "bs-platform/lib/es6/caml_js_exceptions.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

function fromDate(date) {
  return date.toString();
}

function toDate(dateStr) {
  var dateStr$1 = dateStr;
  return new Date(dateStr$1.replace(/-/g, "/"));
}

var DateStr = {
  fromDate: fromDate,
  toDate: toDate
};

function decode(json) {
  var fm;
  try {
    fm = {
      author: Json_decode.field("author", Json_decode.string, json),
      date: new Date(Json_decode.field("date", Json_decode.string, json)).toString(),
      imgUrl: Json_decode.nullable((function (param) {
              return Json_decode.field("imgUrl", Json_decode.string, param);
            }), json),
      description: Json_decode.nullable((function (param) {
              return Json_decode.field("description", Json_decode.string, param);
            }), json)
    };
  }
  catch (raw_exn){
    var exn = Caml_js_exceptions.internalToOCamlException(raw_exn);
    if (exn[0] === Json_decode.DecodeError) {
      return /* Error */Caml_chrome_debugger.variant("Error", 1, [exn[1]]);
    } else {
      throw exn;
    }
  }
  return /* Ok */Caml_chrome_debugger.variant("Ok", 0, [fm]);
}

var FrontMatter = {
  decode: decode
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
  DateStr ,
  FrontMatter ,
  make ,
  
}
/* Icon Not a pure module */
