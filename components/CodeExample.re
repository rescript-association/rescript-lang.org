open Util.ReactStuff;

[@react.component]
let make = (~code: string, ~lang) => {
  let highlighted = HighlightJs.(highlight(~lang, ~value=code)->valueGet);

  let children =
    ReactDOMRe.createElementVariadic(
      "code",
      ~props=
        ReactDOMRe.objToDOMProps({
          "className": "wrap hljs lang-" ++ lang,
          "dangerouslySetInnerHTML": {
            "__html": highlighted,
          },
        }),
      [||],
    );

  <div
    className="flex flex-col -mx-8 xs:mx-0 rounded-none xs:rounded-lg bg-night-dark py-3 px-3 mt-10 text-snow-dark">
    <div
      className="font-montserrat text-sm mb-3 font-bold text-fire">
      {Js.String2.toUpperCase(lang)->s}
    </div>
    <div className="pl-5 text-base pb-4 overflow-x-auto"> children </div>
  </div>;
};
