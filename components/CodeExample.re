open Util.ReactStuff;

[@react.component]
let make = (~code: string, ~lang) => {
  let highlighted = HighlightJs.(highlight(~lang, ~value=code)->valueGet);

  let children =
    ReactDOMRe.createElementVariadic(
      "code",
      ~props=
        ReactDOMRe.objToDOMProps({
          "className": "hljs lang-" ++ lang,
          "dangerouslySetInnerHTML": {
            "__html": highlighted,
          },
        }),
      [||],
    );

  <div
    className="flex flex-col rounded-lg bg-main-black py-3 px-3 mt-10 overflow-x-auto text-lighter-grey">
    <div
      className="font-montserrat text-sm mb-3 font-bold text-primary-dark-10">
      {Js.String2.toUpperCase(lang)->s}
    </div>
    <div className="pl-5 text-base pb-4"> children </div>
  </div>;
};
