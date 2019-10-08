open Util.ReactStuff;

[@react.component]
let make = (~code, ~lang) => {
  let highlighted = HighlightJs.(highlight(~lang, ~value=code)->valueGet);

  ReactDOMRe.createElementVariadic(
    "code",
    ~props=
      ReactDOMRe.objToDOMProps({
        "className": "font-bold hljs lang-" ++ lang,
        "dangerouslySetInnerHTML": {
          "__html": highlighted,
        },
      }),
    [||],
  );
};
