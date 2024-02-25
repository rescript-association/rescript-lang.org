type options = {language: string}

@deriving(abstract)
type highlightResult = {value: string}

@module("highlight.js/lib/core") @scope("default")
external highlight: (~code: string, ~options: options) => highlightResult = "highlight"

let renderHLJS = (~highlightedLines=[], ~darkmode=false, ~code: string, ~lang: string, ()) => {
  // If the language couldn't be parsed, we will fall back to text
  let options = {language: lang}
  let (lang, highlighted) = try (lang, highlight(~code, ~options)->valueGet) catch {
  | Js.Exn.Error(_) => ("text", code)
  }

  // Add line highlighting as well
  let highlighted = if Belt.Array.length(highlightedLines) > 0 {
    Js.String2.split(highlighted, "\n")
    ->Belt.Array.mapWithIndex((i, line) =>
      if Js.Array2.find(highlightedLines, lnum => lnum === i + 1) !== None {
        let content = line === "" ? "&nbsp;" : line
        "<span class=\"inline-block\">" ++ (content ++ "</span>")
      } else {
        "<span class=\"inline-block text-inherit opacity-50\">" ++ (line ++ "</span>")
      }
    )
    ->Js.Array2.joinWith("\n")
  } else {
    highlighted
  }

  let dark = darkmode ? "dark" : ""

  <code
    className={"hljs lang-" ++ (lang ++ (" " ++ dark))}
    dangerouslySetInnerHTML={"__html": highlighted}
  />
}
