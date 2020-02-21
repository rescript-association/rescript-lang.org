

import * as React from "react";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MainLayout from "../layouts/MainLayout.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ManualDocsLayout from "../layouts/ManualDocsLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

require('../styles/main.css')
;

let hljs = require('highlight.js/lib/highlight');
  let js = require('highlight.js/lib/languages/javascript');
  let ocaml = require('highlight.js/lib/languages/ocaml');
  let reason = require('reason-highlightjs');
  let bash = require('highlight.js/lib/languages/bash');
  let json = require('highlight.js/lib/languages/json');
  let text = require('highlight.js/lib/languages/plaintext');

  hljs.registerLanguage('reason', reason);
  hljs.registerLanguage('javascript', js);
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
  var element = React.createElement(component, pageProps);
  var url = parse(router.route);
  var match = url.base;
  if (match.length === 2) {
    var match$1 = match[0];
    if (match$1 === "docs") {
      var match$2 = match[1];
      if (match$2 === "manual") {
        var match$3 = url.version;
        if (typeof match$3 === "number" && match$3 === 0) {
          return React.createElement(ManualDocsLayout.Prose.make, {
                      children: element
                    });
        }
        
      }
      
    }
    
  }
  return React.createElement(MainLayout.make, {
              children: element
            });
}

export {
  Url ,
  make ,
  
}
/*  Not a pure module */
