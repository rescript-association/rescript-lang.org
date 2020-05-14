open Util.ReactStuff;

[@react.component]
let make = (~code: string, ~lang="text") => {
  // If the language couldn't be parsed, we will fall back to text
  let (lang, highlighted) =
    try((lang, HighlightJs.(highlight(~lang, ~value=code)->valueGet))) {
    | Js.Exn.Error(_) => ("text", code)
    };

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

  let langShortname =
    switch (lang) {
    | "ocaml" => "ml"
    | "reasonml"
    | "reason" => "re"
    | "bash" => "sh"
    | "text" => ""
    | rest => rest
    };

  <div
    className="flex w-full flex-col rounded-none xs:rounded border-t border-b xs:border border-snow-dark bg-snow-light px-5 py-2 text-night-dark">
    <div
      className="flex self-end font-sans mb-4 text-sm font-bold text-night-light">
      {Js.String2.toUpperCase(langShortname)->s}
    </div>
    <div className="px-5 text-base pb-6 overflow-x-auto -mt-2"> children </div>
  </div>;
};
