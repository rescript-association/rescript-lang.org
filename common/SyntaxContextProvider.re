// This file is used to toggle default syntax tabs
// in tabbed components etc.

let context = React.createContext("res");

[@bs.obj]
external makeProps:
  (~value: string, ~children: React.element, ~key: string=?, unit) =>
  {
    .
    "value": string,
    "children": React.element,
  };

let make = React.Context.provider(context);
