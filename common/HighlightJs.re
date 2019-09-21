[@bs.deriving abstract]
type highlightResult = {value: string};

[@bs.module "highlight.js/lib/highlight"]
external highlight: (~name: string, ~value: string) => highlightResult =
  "highlight";
