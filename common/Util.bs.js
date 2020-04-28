

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as IntlDateTimeFormat from "../bindings/IntlDateTimeFormat.bs.js";

function s(prim) {
  return prim;
}

function ate(prim) {
  return prim;
}

var Unsafe = { };

var ReactStuff = {
  s: s,
  ate: ate,
  Unsafe: Unsafe,
  Style: /* alias */0
};

function camelCase (str){{
     return str.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase(); });
    }};

function capitalize (str){{
      return str && str.charAt(0).toUpperCase() + str.substring(1);
    }};

var $$String = {
  camelCase: camelCase,
  capitalize: capitalize
};

var isAbsolute = (function(str) {
      var r = new RegExp('^(?:[a-z]+:)?//', 'i');
      if (r.test(str))
      {
        return true
      }
      return false;
    });

var Url = {
  isAbsolute: isAbsolute
};

function toDayMonthYear(date) {
  return IntlDateTimeFormat.$$Date.make(/* US */19038, {
              year: Curry._1(IntlDateTimeFormat.$$Date.Year.make, /* numeric */734061261),
              day: Curry._1(IntlDateTimeFormat.$$Date.Day.make, /* numeric */734061261),
              month: Curry._1(IntlDateTimeFormat.$$Date.Month.make, /* short */-64519044)
            }, date);
}

var $$Date = {
  toDayMonthYear: toDayMonthYear
};

export {
  ReactStuff ,
  $$String ,
  Url ,
  $$Date ,
  
}
/* No side effect */
