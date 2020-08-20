open Util.ReactStuff;

[@react.component]
let make = (~syntax: string, ~setSyntax: (string => string) => unit) => {
  let buttons = [|"res", "re"|];

  let children =
    Belt.Array.reduce(
      buttons,
      [||],
      (acc, lang) => {
        let active =
          syntax === lang
            ? "bg-fire-80 text-white rounded py-1"
            : "hover:cursor-pointer hover:text-onyx";

        let onClick = evt => {
          ReactEvent.Mouse.preventDefault(evt);
          setSyntax(_ => lang);
        };

        let label =
          if (lang === "re") {
            "RE (deprecated)"
          } else {
            Js.String2.toUpperCase(lang);
          };

        let element =
          <button key=lang className={"inline-block px-4 w-1/2 " ++ active} onClick>
            label->s
          </button>;

        Js.Array2.push(acc, element)->ignore;
        acc;
      },
    );

  <div className="flex text-12 border rounded text-onyx-50" style={ReactDOMRe.Style.make(~maxWidth="16rem", ())}>
    children->ate
  </div>;
};
