// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Markdown from "./Markdown.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as WarningFlagDescription from "../common/WarningFlagDescription.mjs";

function WarningTable(Props) {
  return React.createElement(Markdown.Table.make, {
              children: null
            }, React.createElement(Markdown.Thead.make, {
                  children: React.createElement("tr", undefined, React.createElement(Markdown.Th.make, {
                            children: "#"
                          }), React.createElement(Markdown.Th.make, {
                            children: "Description"
                          }))
                }), React.createElement("tbody", undefined, Belt_Array.map(WarningFlagDescription.lookupAll(undefined), (function (param) {
                        var number = param[0];
                        return React.createElement("tr", {
                                    key: number
                                  }, React.createElement(Markdown.Td.make, {
                                        children: number
                                      }), React.createElement(Markdown.Td.make, {
                                        children: param[1]
                                      }));
                      }))));
}

var make = WarningTable;

export {
  make ,
  
}
/* react Not a pure module */
