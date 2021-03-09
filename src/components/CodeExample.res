let langShortname = (lang: string) =>
  switch lang {
  | "ocaml" => "ml"
  | "reasonml"
  | "reason" => "re"
  | "bash" => "sh"
  | "text" => ""
  | rest => rest
  }

@react.component
let make = (~highlightedLines=[], ~code: string, ~showLabel=true, ~lang="text") => {
  let children = HighlightJs.renderHLJS(~highlightedLines, ~code, ~lang, ())

  let label = if showLabel {
    let label = langShortname(lang)
    <div className="flex self-end font-sans mb-4 text-12 font-bold text-gray-60 px-4">
      {//RES or JS Label
      Js.String2.toUpperCase(label)->React.string}
    </div>
  } else {
    <div className="mt-4" />
  }

  <div //normal code-text without tabs
    className="flex w-full flex-col rounded-none xs:rounded border-t border-b xs:border border-gray-10 bg-gray-5 py-2 text-gray-90">
    label <div className="px-4 text-14 pb-2 overflow-x-auto -mt-2"> children </div>
  </div>
}

module Toggle = {
  type tab = {
    highlightedLines: option<array<int>>,
    label: option<string>,
    lang: option<string>,
    code: string,
  }

  @react.component
  let make = (~tabs: array<tab>) => {
    let (selected, setSelected) = React.useState(_ => 0)

    switch tabs {
    | [tab] =>
      make({
        "highlightedLines": tab.highlightedLines,
        "code": tab.code,
        "lang": tab.lang,
        "showLabel": Some(true),
      })
    | multiple =>
      let numberOfItems = Js.Array.length(multiple)
      let tabElements = Belt.Array.mapWithIndex(multiple, (i, tab) => {
        // if there's no label, infer the label from the language
        let label = switch tab.label {
        | Some(label) => label
        | None =>
          switch tab.lang {
          | Some(lang) => langShortname(lang)->Js.String2.toUpperCase
          | None => Belt.Int.toString(i)
          }
        }

        let activeClass = if selected === i {
          "font-semibold text-gray-90 bg-gray-5 border border-b-0 border-gray-10"
        } else {
          "border-gray-10 border-b bg-gray-10 hover:cursor-pointer"
        }

        let onClick = evt => {
          ReactEvent.Mouse.preventDefault(evt)
          setSelected(_ => i)
        }
        let key = label ++ ("-" ++ Belt.Int.toString(i))

        let paddingX = switch numberOfItems {
        | 1
        | 2 => "sm:px-16"
        | 3 => "lg:px-8"
        | _ => ""
        }
        <span
          key
          className={paddingX ++
          (" flex-none px-4 inline-block p-2 rounded-tl rounded-tr " ++
          activeClass)}
          onClick>
          {React.string(label)}
        </span>
      })

      let children =
        Belt.Array.get(multiple, selected)
        ->Belt.Option.map(tab => {
          let lang = Belt.Option.getWithDefault(tab.lang, "text")
          HighlightJs.renderHLJS(~highlightedLines=?tab.highlightedLines, ~code=tab.code, ~lang, ())
        })
        ->Belt.Option.getWithDefault(React.null)

      <div className="flex w-full flex-col rounded-none text-gray-80">
        <div
          className="flex w-full overflow-auto scrolling-touch font-sans bg-transparent text-sm text-gray-60-tr">
          <div className="flex"> {React.array(tabElements)} </div>
          <div className="flex-1 border-b border-gray-10"> {React.string(j`\\u00A0`)} </div>
        </div>
        <div
          className="px-4 text-14 pb-4 pt-4 overflow-x-auto bg-gray-5 border-gray-10 xs:rounded-b border border-t-0">
          <pre> children </pre>
        </div>
      </div>
    }
  }
}
