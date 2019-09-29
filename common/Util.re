module ReactStuff = {
  let s = ReasonReact.string;
  let ate = ReasonReact.array;

  module Unsafe = {
    external elementAsString: React.element => string = "%identity";
  };
};

module IntCmp =
  Belt.Id.MakeComparable({
    type t = int;
    let cmp = Pervasives.compare;
  });

let a = Belt.Set.Dict.empty;
let b = Belt.Set.Dict.fromArray([|1, 2, 3|], ~cmp=IntCmp.cmp);
