

import * as Js_mapperRt from "bs-platform/lib/es6/js_mapperRt.js";

var jsMapperConstantArray = [
  /* tuple */[
    15013,
    "zh"
  ],
  /* tuple */[
    19038,
    "en-US"
  ],
  /* tuple */[
    4096816,
    "ru-RU"
  ],
  /* tuple */[
    4146977,
    "sv-SE"
  ]
];

function localeToJs(param) {
  return Js_mapperRt.binarySearch(4, param, jsMapperConstantArray);
}

function localeFromJs(param) {
  return Js_mapperRt.revSearchAssert(4, jsMapperConstantArray, param);
}

var jsMapperConstantArray$1 = [
  /* tuple */[
    -944265860,
    "long"
  ],
  /* tuple */[
    -64519044,
    "short"
  ],
  /* tuple */[
    550578843,
    "narrow"
  ]
];

function tToJs(param) {
  return Js_mapperRt.binarySearch(3, param, jsMapperConstantArray$1);
}

function tFromJs(param) {
  return Js_mapperRt.revSearchAssert(3, jsMapperConstantArray$1, param);
}

function make(value) {
  return Js_mapperRt.binarySearch(3, value, jsMapperConstantArray$1);
}

var Weekday = {
  tToJs: tToJs,
  tFromJs: tFromJs,
  make: make
};

var jsMapperConstantArray$2 = [
  /* tuple */[
    -944265860,
    "long"
  ],
  /* tuple */[
    -64519044,
    "short"
  ],
  /* tuple */[
    550578843,
    "narrow"
  ]
];

function tToJs$1(param) {
  return Js_mapperRt.binarySearch(3, param, jsMapperConstantArray$2);
}

function tFromJs$1(param) {
  return Js_mapperRt.revSearchAssert(3, jsMapperConstantArray$2, param);
}

function make$1(value) {
  return Js_mapperRt.binarySearch(3, value, jsMapperConstantArray$2);
}

var Era = {
  tToJs: tToJs$1,
  tFromJs: tFromJs$1,
  make: make$1
};

var jsMapperConstantArray$3 = [
  /* tuple */[
    233329793,
    "2-digit"
  ],
  /* tuple */[
    734061261,
    "numeric"
  ]
];

function tToJs$2(param) {
  return Js_mapperRt.binarySearch(2, param, jsMapperConstantArray$3);
}

function tFromJs$2(param) {
  return Js_mapperRt.revSearchAssert(2, jsMapperConstantArray$3, param);
}

function make$2(value) {
  return Js_mapperRt.binarySearch(2, value, jsMapperConstantArray$3);
}

var Year = {
  tToJs: tToJs$2,
  tFromJs: tFromJs$2,
  make: make$2
};

var jsMapperConstantArray$4 = [
  /* tuple */[
    233329793,
    "2-digit"
  ],
  /* tuple */[
    734061261,
    "numeric"
  ]
];

function tToJs$3(param) {
  return Js_mapperRt.binarySearch(2, param, jsMapperConstantArray$4);
}

function tFromJs$3(param) {
  return Js_mapperRt.revSearchAssert(2, jsMapperConstantArray$4, param);
}

function make$3(value) {
  return Js_mapperRt.binarySearch(2, value, jsMapperConstantArray$4);
}

var Day = {
  tToJs: tToJs$3,
  tFromJs: tFromJs$3,
  make: make$3
};

var jsMapperConstantArray$5 = [
  /* tuple */[
    -944265860,
    "long"
  ],
  /* tuple */[
    -64519044,
    "short"
  ],
  /* tuple */[
    233329793,
    "2-digit"
  ],
  /* tuple */[
    550578843,
    "narrow"
  ],
  /* tuple */[
    734061261,
    "numeric"
  ]
];

function tToJs$4(param) {
  return Js_mapperRt.binarySearch(5, param, jsMapperConstantArray$5);
}

function tFromJs$4(param) {
  return Js_mapperRt.revSearchAssert(5, jsMapperConstantArray$5, param);
}

function make$4(value) {
  return Js_mapperRt.binarySearch(5, value, jsMapperConstantArray$5);
}

var Month = {
  tToJs: tToJs$4,
  tFromJs: tFromJs$4,
  make: make$4
};

function make$5($staropt$star, options, date) {
  var locale = $staropt$star !== undefined ? $staropt$star : /* US */19038;
  return new (Intl.DateTimeFormat)(localeToJs(locale), options).format(date);
}

var $$Date = {
  Weekday: Weekday,
  Era: Era,
  Year: Year,
  Day: Day,
  Month: Month,
  make: make$5
};

export {
  localeToJs ,
  localeFromJs ,
  $$Date ,
  
}
/* No side effect */
