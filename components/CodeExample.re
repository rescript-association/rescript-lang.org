open Util.ReactStuff;

type lang = [ | `Reason | `OCaml];

[@react.component]
let make = (~children, ~lang=`Reason) => {
  let langStr =
    switch (lang) {
    | `Reason => "RE"
    | `OCaml => "ML"
    };
  <div className="flex flex-col rounded-lg bg-main-black py-3 px-3 mt-10 overflow-x-auto">
    <div
      className="font-montserrat text-sm mb-3 font-bold text-primary-dark-10">
      langStr->s
    </div>
    <div className="pl-3 text-base pb-4">
    children
    </div>
  </div>;
};
