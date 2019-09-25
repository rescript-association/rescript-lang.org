module ReactStuff = {
  let s = ReasonReact.string;
  let ate = ReasonReact.array;

  module Unsafe = {
    external elementAsString: React.element => string = "%identity";
  };
};
