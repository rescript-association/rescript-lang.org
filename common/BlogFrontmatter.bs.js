

import * as DateStr from "./DateStr.bs.js";
import * as Js_null from "bs-platform/lib/es6/js_null.js";
import * as Json_decode from "@glennsl/bs-json/src/Json_decode.bs.js";
import * as Caml_js_exceptions from "bs-platform/lib/es6/caml_js_exceptions.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

var rawAuthors = (require('../index_data/blog_authors.json'));

function getDisplayName(author) {
  var match = author.fullname;
  if (match !== null) {
    return match;
  } else {
    return "@" + author.username;
  }
}

function decode(json) {
  return {
          username: Json_decode.field("username", Json_decode.string, json),
          fullname: Js_null.fromOption(Json_decode.optional((function (param) {
                      return Json_decode.field("fullname", Json_decode.string, param);
                    }), json)),
          role: Json_decode.field("role", Json_decode.string, json),
          imgUrl: Js_null.fromOption(Json_decode.optional((function (param) {
                      return Json_decode.field("img_url", Json_decode.string, param);
                    }), json)),
          twitter: Js_null.fromOption(Json_decode.optional((function (param) {
                      return Json_decode.field("twitter", Json_decode.string, param);
                    }), json))
        };
}

function getAllAuthors(param) {
  return Json_decode.array(decode, rawAuthors);
}

var Author = {
  rawAuthors: rawAuthors,
  getDisplayName: getDisplayName,
  decode: decode,
  getAllAuthors: getAllAuthors
};

function toString(c) {
  switch (c) {
    case /* Compiler */0 :
        return "Compiler";
    case /* Syntax */1 :
        return "Syntax";
    case /* Ecosystem */2 :
        return "Ecosystem";
    case /* Docs */3 :
        return "Docs";
    case /* Community */4 :
        return "Community";
    
  }
}

var Category = {
  toString: toString
};

function toString$1(c) {
  switch (c) {
    case /* Release */0 :
        return "Release";
    case /* Testing */1 :
        return "Testing";
    case /* Preview */2 :
        return "Preview";
    case /* Roadmap */3 :
        return "Roadmap";
    
  }
}

var Badge = {
  toString: toString$1
};

function decodeCategory(str) {
  var str$1 = str.toLowerCase();
  switch (str$1) {
    case "community" :
        return /* Community */4;
    case "compiler" :
        return /* Compiler */0;
    case "docs" :
        return /* Docs */3;
    case "ecosystem" :
        return /* Ecosystem */2;
    case "syntax" :
        return /* Syntax */1;
    default:
      throw [
            Json_decode.DecodeError,
            "Unknown category \"" + (String(str$1) + "\"")
          ];
  }
}

function decodeBadge(str) {
  var str$1 = str.toLowerCase();
  switch (str$1) {
    case "preview" :
        return /* Preview */2;
    case "release" :
        return /* Release */0;
    case "roadmap" :
        return /* Roadmap */3;
    case "testing" :
        return /* Testing */1;
    default:
      throw [
            Json_decode.DecodeError,
            "Unknown category \"" + (String(str$1) + "\"")
          ];
  }
}

function decodeAuthor(authors, username) {
  var match = authors.find((function (a) {
          return a.username === username;
        }));
  if (match !== undefined) {
    return match;
  } else {
    throw [
          Json_decode.DecodeError,
          "Couldn\'t find author called \"" + (String(username) + "\"")
        ];
  }
}

function decode$1(authors, json) {
  var fm;
  try {
    var arg = Json_decode.field("author", Json_decode.string, json);
    fm = {
      author: (function (param) {
            return decodeAuthor(param, arg);
          })(authors),
      date: DateStr.fromDate(new Date(Json_decode.field("date", Json_decode.string, json))),
      previewImg: Json_decode.nullable((function (param) {
              return Json_decode.field("previewImg", Json_decode.string, param);
            }), json),
      articleImg: Js_null.fromOption(Json_decode.optional((function (param) {
                  return Json_decode.field("articleImg", Json_decode.string, param);
                }), json)),
      title: Json_decode.field("title", Json_decode.string, json),
      category: decodeCategory(Json_decode.field("category", Json_decode.string, json)),
      badge: Js_null.fromOption(Json_decode.optional((function (j) {
                  return decodeBadge(Json_decode.field("badge", Json_decode.string, j));
                }), json)),
      description: Json_decode.nullable((function (param) {
              return Json_decode.field("description", Json_decode.string, param);
            }), json),
      canonical: Js_null.fromOption(Json_decode.optional((function (param) {
                  return Json_decode.field("canonical", Json_decode.string, param);
                }), json))
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

export {
  Author ,
  Category ,
  Badge ,
  decodeCategory ,
  decodeBadge ,
  decodeAuthor ,
  decode$1 as decode,
  
}
/* rawAuthors Not a pure module */
