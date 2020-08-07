open Util.ReactStuff;

let renderHLJS = (~code: string, ~lang: string) => {
  // If the language couldn't be parsed, we will fall back to text
  let (lang, highlighted) =
    try((lang, HighlightJs.(highlight(~lang, ~value=code)->valueGet))) {
    | Js.Exn.Error(_) => ("text", code)
    };

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
};

let langShortname = (lang: string) => {
  switch (lang) {
  | "ocaml" => "ml"
  | "reasonml"
  | "reason" => "re"
  | "bash" => "sh"
  | "text" => ""
  | rest => rest
  };
};

[@react.component]
let make = (~code: string, ~lang="text") => {
  let children = renderHLJS(~code, ~lang);

  let label = langShortname(lang);

  <div
    className="flex w-full flex-col rounded-none xs:rounded border-t border-b xs:border border-snow-dark bg-snow-light px-5 py-2 text-night-dark">
    <div
      className="flex self-end font-sans mb-4 text-sm font-bold text-night-light">
      {Js.String2.toUpperCase(label)->s}
    </div>
    <div className="px-5 text-base pb-6 overflow-x-auto -mt-2"> children </div>
  </div>;
};

module Toggle = {
  type tab = {
    label: option(string),
    lang: option(string),
    code: string,
  };

  [@react.component]
  let make = (~tabs: array(tab)) => {
    let (selected, setSelected) = React.useState(_ => 0);

    switch (tabs) {
    | [|tab|] => make({"code": tab.code, "lang": tab.lang})
    | multiple =>
      let labels =
        Belt.Array.mapWithIndex(
          multiple,
          (i, tab) => {
            // if there's no label, infer the label from the language
            let label =
              switch (tab.label) {
              | Some(label) => label
              | None =>
                switch (tab.lang) {
                | Some(lang) => langShortname(lang)->Js.String2.toUpperCase
                | None => string_of_int(i)
                }
              };

            let activeClass =
              selected === i ? "text-fire-80" : "hover:cursor-pointer";

            let onClick = evt => {
              ReactEvent.Mouse.preventDefault(evt);
              setSelected(_ => i);
            };
            let key = label ++ "-" ++ string_of_int(i);

            <span
              key
              className={"inline-block p-2 last:border-r-0 border-r "  ++ activeClass}
              onClick>
              label->s
            </span>;
          },
        );

      let children =
        Belt.Array.get(multiple, selected)
        ->Belt.Option.map(tab => {
            let lang = Belt.Option.getWithDefault(tab.lang, "text");
            renderHLJS(~code=tab.code, ~lang);
          })
        ->Belt.Option.getWithDefault(React.null);

      <div
        className="flex w-full flex-col rounded-none xs:rounded border-t border-b xs:border border-snow-dark bg-snow-light px-5 pb-2 text-night-dark">
        <div
          className="border-b border-l border-r flex self-end font-sans mb-6 md:mb-4 text-sm font-bold text-night-light">
          labels->ate
        </div>
        <div className="px-5 text-base pb-6 overflow-x-auto -mt-2">
          <pre> children </pre>
        </div>
      </div>;
    };
  };
};
