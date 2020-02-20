

import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

function getMdxType (element){{
      if(element == null || element.props == null) {
        return 'unknown';
      }
      return element.props.mdxType;
    }};

function classify(param) {
  if ((function (a) { return  a instanceof Array})(param)) {
    return /* Array */Caml_chrome_debugger.variant("Array", 2, [param]);
  } else if (typeof param === "string") {
    return /* String */Caml_chrome_debugger.variant("String", 0, [param]);
  } else if (typeof param === "object") {
    return /* Element */Caml_chrome_debugger.variant("Element", 1, [param]);
  } else {
    return /* Unknown */Caml_chrome_debugger.variant("Unknown", 3, [param]);
  }
}

function getMdxChildren (element){{
      if(element == null || element.props == null || element.props.children == null) {
        return;
      }
      return element.props.children;
    }};

function flatten(_mdxComp) {
  while(true) {
    var mdxComp = _mdxComp;
    var match = classify(getMdxChildren(mdxComp));
    switch (match.tag | 0) {
      case /* String */0 :
          return [match[0]];
      case /* Element */1 :
          _mdxComp = match[0];
          continue ;
      case /* Array */2 :
          return Belt_Array.reduce(match[0], [], (function (acc, next) {
                        return Belt_Array.concat(acc, flatten(next));
                      }));
      case /* Unknown */3 :
          return [];
      
    }
  };
}

function MdxChildren_toReactElement(prim) {
  return prim;
}

var MdxChildren = {
  classify: classify,
  getMdxChildren: getMdxChildren,
  flatten: flatten,
  toReactElement: MdxChildren_toReactElement
};

var Components = { };

var Provider = { };

export {
  getMdxType ,
  MdxChildren ,
  Components ,
  Provider ,
  
}
/* No side effect */
