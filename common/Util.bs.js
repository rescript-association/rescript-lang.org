

import * as Belt_Id from "bs-platform/lib/es6/belt_Id.js";
import * as Caml_obj from "bs-platform/lib/es6/caml_obj.js";
import * as Belt_SetDict from "bs-platform/lib/es6/belt_SetDict.js";

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
  Unsafe: Unsafe
};

var cmp = Caml_obj.caml_compare;

var IntCmp = Belt_Id.MakeComparable({
      cmp: cmp
    });

var b = Belt_SetDict.fromArray(/* array */[
      1,
      2,
      3
    ], IntCmp.cmp);

var a = Belt_SetDict.empty;

export {
  ReactStuff ,
  IntCmp ,
  a ,
  b ,
  
}
/* IntCmp Not a pure module */
