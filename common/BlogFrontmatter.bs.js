

import * as DateStr from "./DateStr.bs.js";
import * as Json_decode from "@glennsl/bs-json/src/Json_decode.bs.js";
import * as Caml_js_exceptions from "bs-platform/lib/es6/caml_js_exceptions.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

function socialUrl(social) {
  if (social) {
    return "https://github.com";
  } else {
    return "https://twitter.com";
  }
}

function parse(str) {
  var match = str.split("/");
  var len = match.length;
  if (len >= 3) {
    return /* Error */Caml_chrome_debugger.variant("Error", 1, ["unknown username format: " + str]);
  } else {
    switch (len) {
      case 0 :
          return /* Error */Caml_chrome_debugger.variant("Error", 1, ["unknown username format: " + str]);
      case 1 :
          var username = match[0];
          if (username.length === 0) {
            return /* Error */Caml_chrome_debugger.variant("Error", 1, ["username should not be empty"]);
          } else {
            return /* Ok */Caml_chrome_debugger.variant("Ok", 0, [{
                        username: username,
                        social: null
                      }]);
          }
      case 2 :
          var socialUrl = match[0];
          switch (socialUrl) {
            case "github.com" :
                var username$1 = match[1];
                return /* Ok */Caml_chrome_debugger.variant("Ok", 0, [{
                            username: username$1,
                            social: /* Github */1
                          }]);
            case "twitter.com" :
                var username$2 = match[1];
                return /* Ok */Caml_chrome_debugger.variant("Ok", 0, [{
                            username: username$2,
                            social: /* Twitter */0
                          }]);
            default:
              return /* Error */Caml_chrome_debugger.variant("Error", 1, ["Unknown url: " + socialUrl]);
          }
      
    }
  }
}

var Author = {
  socialUrl: socialUrl,
  parse: parse
};

function decodeAuthor(str) {
  var match = parse(str);
  if (match.tag) {
    throw [
          Json_decode.DecodeError,
          match[0]
        ];
  } else {
    return match[0];
  }
}

function decode(json) {
  var fm;
  try {
    fm = {
      author: decodeAuthor(Json_decode.field("author", Json_decode.string, json)),
      date: DateStr.fromDate(new Date(Json_decode.field("date", Json_decode.string, json))),
      previewImg: Json_decode.nullable((function (param) {
              return Json_decode.field("previewImg", Json_decode.string, param);
            }), json),
      title: Json_decode.field("title", Json_decode.string, json),
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

export {
  Author ,
  decodeAuthor ,
  decode ,
  
}
/* No side effect */
