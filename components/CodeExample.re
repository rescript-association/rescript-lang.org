open Util.ReactStuff;

let renderHLJS = (~highlightedLines=[||], ~code: string, ~lang: string, ()) => {
  // If the language couldn't be parsed, we will fall back to text
  let (lang, highlighted) =
    try((lang, HighlightJs.(highlight(~lang, ~value=code)->valueGet))) {
    | Js.Exn.Error(_) => ("text", code)
    };

  // Add line highlighting as well
  let highlighted =
    if (Belt.Array.length(highlightedLines) > 0) {
      Js.String2.split(highlighted, "\n")
      ->Belt.Array.mapWithIndex((i, line) =>
          if (Js.Array2.find(highlightedLines, lnum => lnum === i + 1) !== None) {
            "<span class=\"hljs-line-highlight\">" ++ line ++ "</span>";
          } else {
            line;
          }
        )
      ->Js.Array2.joinWith("\n");
    } else {
      highlighted;
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
let make = (~highlightedLines=[||], ~code: string, ~showLabel=true, ~lang="text") => {
  let children = renderHLJS(~highlightedLines, ~code, ~lang, ());

  let label = if(showLabel) {
    let label = langShortname(lang);
    <div
      className="flex self-end font-sans mb-4 text-sm font-bold text-night-light px-4">
      {Js.String2.toUpperCase(label)->s}
    </div>
  }
  else {
    <div className="mt-4"/>
  };

  <div
    className="flex w-full flex-col rounded-none xs:rounded border-t border-b xs:border border-snow-dark bg-snow-light py-2 text-night-dark">
    label
    <div className="px-4 text-base pb-2 overflow-x-auto -mt-2"> children </div>
  </div>;
};

module Toggle = {
  type tab = {
    highlightedLines: option(array(int)),
    label: option(string),
    lang: option(string),
    code: string,
  };

  [@react.component]
  let make = (~tabs: array(tab)) => {
    let (selected, setSelected) = React.useState(_ => 0);

    switch (tabs) {
    | [|tab|] =>
      make({
        "highlightedLines": tab.highlightedLines,
        "code": tab.code,
        "lang": tab.lang,
        "showLabel": Some(true),
      })
    | multiple =>
      let numberOfItems = Js.Array.length(multiple);
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
                | None => Belt.Int.toString(i)
                }
              };

            let activeClass =
              selected === i ? "font-bold text-gray-100 bg-snow-light" : "hover:cursor-pointer border-gray-20 border-r";

            let onClick = evt => {
              ReactEvent.Mouse.preventDefault(evt);
              setSelected(_ => i);
            };
            let key = label ++ "-" ++ Belt.Int.toString(i);

            let paddingX = switch(numberOfItems) {
              | 1
              | 2 => "sm:px-16"
              | 3 => "lg:px-8"
              | _ => ""
            };
            <span
              key
              className={
                paddingX ++ " px-4 inline-block p-2 bg-gray-10 rounded-sm " ++ activeClass
              }
              onClick>
              label->s
            </span>;
          },
        );

      let children =
        Belt.Array.get(multiple, selected)
        ->Belt.Option.map(tab => {
            let lang = Belt.Option.getWithDefault(tab.lang, "text");
            renderHLJS(
              ~highlightedLines=?tab.highlightedLines,
              ~code=tab.code,
              ~lang,
              (),
            );
          })
        ->Belt.Option.getWithDefault(React.null);

      <div
        className="flex w-full flex-col rounded-none xs:rounded border-t border-b xs:border border-snow-dark bg-snow-light pb-2 text-night-dark">
        <div
          className="flex overflow-auto scrolling-touch font-sans mb-6 mb-4 text-sm bg-gray-10 text-gray-60-tr">
          labels->ate
        </div>
        <div className="px-4 text-base pb-2 overflow-x-auto -mt-2">
          <pre> children </pre>
        </div>
      </div>;
    };
  };
};
