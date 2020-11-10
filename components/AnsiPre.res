// This file was automatically converted to ReScript from 'AnsiPre.re'
// Check the output and make sure to delete the original file
open Util.ReactStuff
open Ansi

type colorTarget =
  | Fg
  | Bg

let mapColor = (~target: colorTarget, c: Color.t): string =>
  switch (target, c) {
  | (Fg, Black) => "text-black"
  | (Fg, Red) => "text-fire"
  | (Fg, Green) => "text-dark-code-3"
  | (Fg, Yellow) => "text-dark-code-1"
  | (Fg, Blue) => "text-dark-code-2"
  | (Fg, Magenta) => "text-berry"
  | (Fg, Cyan) => "text-dark-code-2"
  | (Fg, White) => "text-snow-dark"
  | (Bg, Black) => "bg-black"
  | (Bg, Red) => "bg-fire"
  | (Bg, Green) => "bg-dark-code-3"
  | (Bg, Yellow) => "bg-dark-code-1"
  | (Bg, Blue) => "bg-dark-code-2"
  | (Bg, Magenta) => "bg-berry"
  | (Bg, Cyan) => "bg-dark-code-2"
  | (Bg, White) => "bg-snow-dark"
  }

let renderSgrString = (~key: string, sgrStr: SgrString.t): React.element => {
  let {SgrString.content: content, params} = sgrStr

  let className = Belt.Array.reduce(params, "", (acc, p) =>
    switch p {
    | Sgr.Bold => acc ++ " bold"
    | Fg(c) => acc ++ (" " ++ mapColor(~target=Fg, c))
    | Bg(c) => acc ++ (" " ++ mapColor(~target=Bg, c))
    | _ => acc
    }
  )

  <span key className> {content->s} </span>
}

@react.component
let make = (~className=?, ~children: string) => {
  let spans = Ansi.parse(children)->SgrString.fromTokens->Belt.Array.mapWithIndex((i, str) => {
    let key = Belt.Int.toString(i)
    renderSgrString(~key, str)
  })

  // Note: pre is essential here, otherwise whitespace and newlines are not respected
  <pre ?className> {spans->ate} </pre>
}
