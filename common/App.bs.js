

import * as React from "react";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MainLayout from "../layouts/MainLayout.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as JsDocsLayout from "../layouts/JsDocsLayout.bs.js";
import * as BeltDocsLayout from "../layouts/BeltDocsLayout.bs.js";
import * as ManualDocsLayout from "../layouts/ManualDocsLayout.bs.js";
import * as GenTypeDocsLayout from "../layouts/GenTypeDocsLayout.bs.js";
import * as JavaScriptApiLayout from "../layouts/JavaScriptApiLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";
import * as ReasonReactDocsLayout from "../layouts/ReasonReactDocsLayout.bs.js";
import * as ReasonCompilerDocsLayout from "../layouts/ReasonCompilerDocsLayout.bs.js";

require('../styles/main.css')
;

let hljs = require('highlight.js/lib/highlight');
  let js = require('highlight.js/lib/languages/javascript');
  let ocaml = require('highlight.js/lib/languages/ocaml');
  let reason = require('reason-highlightjs');
  let bash = require('highlight.js/lib/languages/bash');
  let json = require('highlight.js/lib/languages/json');
  let ts = require('highlight.js/lib/languages/typescript');
  let text = require('highlight.js/lib/languages/plaintext');

  hljs.registerLanguage('reason', reason);
  hljs.registerLanguage('javascript', js);
  hljs.registerLanguage('ts', ts);
  hljs.registerLanguage('ocaml', ocaml);
  hljs.registerLanguage('sh', bash);
  hljs.registerLanguage('json', json);
  hljs.registerLanguage('text', text);
;

function isVersion(str) {
  return Belt_Option.isSome(Caml_option.null_to_opt(str.match(/latest|v\d+(\.\d+)?(\.\d+)?/)));
}

function parse(route) {
  var fullpath = Belt_Array.keep(route.split("/"), (function (s) {
          return s !== "";
        }));
  var match = Belt_Array.reduce(fullpath, /* tuple */[
        [],
        /* NoVersion */1,
        []
      ], (function (acc, next) {
          var pagepath = acc[2];
          var version = acc[1];
          var base = acc[0];
          if (version === /* NoVersion */1) {
            if (isVersion(next)) {
              var version$1 = next === "latest" ? /* Latest */0 : /* Version */Caml_chrome_debugger.simpleVariant("Version", [next]);
              return /* tuple */[
                      base,
                      version$1,
                      pagepath
                    ];
            } else {
              var base$1 = Belt_Array.concat(base, [next]);
              return /* tuple */[
                      base$1,
                      version,
                      pagepath
                    ];
            }
          } else {
            var pagepath$1 = Belt_Array.concat(pagepath, [next]);
            return /* tuple */[
                    base,
                    version,
                    pagepath$1
                  ];
          }
        }));
  return {
          fullpath: fullpath,
          base: match[0],
          version: match[1],
          pagepath: match[2]
        };
}

var Url = {
  isVersion: isVersion,
  parse: parse
};

function make(props) {
  var component = props.Component;
  var pageProps = props.pageProps;
  var router = Router.useRouter();
  var content = React.createElement(component, pageProps);
  var url = parse(router.route);
  var match = url.base;
  if (match.length === 2) {
    var match$1 = match[0];
    switch (match$1) {
      case "apis" :
          var match$2 = match[1];
          if (match$2 === "javascript") {
            var match$3 = url.version;
            if (typeof match$3 === "number" && match$3 === 0) {
              var pagepath = url.pagepath;
              var match$4 = pagepath.length;
              var match$5 = Belt_Array.get(pagepath, 0);
              var exit = 0;
              if (match$4 !== 0) {
                if (match$4 !== 1) {
                  exit = 2;
                } else if (match$5 !== undefined) {
                  switch (match$5) {
                    case "belt" :
                        return React.createElement(BeltDocsLayout.Prose.make, {
                                    children: content
                                  });
                    case "js" :
                        return React.createElement(JsDocsLayout.Prose.make, {
                                    children: content
                                  });
                    default:
                      exit = 2;
                  }
                } else {
                  return null;
                }
              } else {
                return React.createElement(JavaScriptApiLayout.Docs.make, {
                            children: content
                          });
              }
              if (exit === 2) {
                if (match$5 !== undefined) {
                  switch (match$5) {
                    case "belt" :
                        return React.createElement(BeltDocsLayout.Docs.make, {
                                    children: content
                                  });
                    case "js" :
                        return React.createElement(JsDocsLayout.Docs.make, {
                                    children: content
                                  });
                    default:
                      return null;
                  }
                } else {
                  return null;
                }
              }
              
            }
            
          }
          break;
      case "docs" :
          var match$6 = match[1];
          switch (match$6) {
            case "gentype" :
                var match$7 = url.version;
                if (typeof match$7 === "number" && match$7 === 0) {
                  return React.createElement(GenTypeDocsLayout.make, {
                              children: content
                            });
                }
                break;
            case "manual" :
                var match$8 = url.version;
                if (typeof match$8 === "number" && match$8 === 0) {
                  return React.createElement(ManualDocsLayout.Prose.make, {
                              children: content
                            });
                }
                break;
            case "reason-compiler" :
                var match$9 = url.version;
                if (typeof match$9 === "number" && match$9 === 0) {
                  return React.createElement(ReasonCompilerDocsLayout.make, {
                              children: content
                            });
                }
                break;
            case "reason-react" :
                var match$10 = url.version;
                if (typeof match$10 === "number" && match$10 === 0) {
                  return React.createElement(ReasonReactDocsLayout.make, {
                              children: content
                            });
                }
                break;
            default:
              
          }
          break;
      default:
        
    }
  }
  return React.createElement(MainLayout.make, {
              children: content
            });
}

export {
  Url ,
  make ,
  
}
/*  Not a pure module */
