

import * as Js_mapperRt from "bs-platform/lib/es6/js_mapperRt.js";

var jsMapperConstantArray = /* array */[
  /* tuple */[
    16617,
    "theme-js"
  ],
  /* tuple */[
    825328612,
    "theme-reason"
  ]
];

function tToJs(param) {
  return Js_mapperRt.binarySearch(2, param, jsMapperConstantArray);
}

function tFromJs(param) {
  return Js_mapperRt.revSearch(2, jsMapperConstantArray, param);
}

var toCN = tToJs;

export {
  tToJs ,
  tFromJs ,
  toCN ,
  
}
/* No side effect */
