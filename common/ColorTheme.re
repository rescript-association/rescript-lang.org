// Equivalent to styles/_theme.css

[@bs.deriving jsConverter]
type t = [
  | [@bs.as "theme-reason"] `Reason
  | [@bs.as "theme-js"] `JS
];

let toCN = value => tToJs(value);
