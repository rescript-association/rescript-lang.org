open Util.ReactStuff;
open Ansi;

type colorTarget =
  | Fg
  | Bg;

let mapColor = (~target: colorTarget, c: Color.t): string => {
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
  };
};

let renderSgrString = (~key: string, sgrStr: SgrString.t): React.element => {
  let {SgrString.content, params} = sgrStr;

  let className =
    Belt.Array.reduce(params, "", (acc, p) => {
      switch (p) {
      | Sgr.Bold => acc ++ " bold"
      | Fg(c) => acc ++ " " ++ mapColor(~target=Fg, c)
      | Bg(c) => acc ++ " " ++ mapColor(~target=Bg, c)
      | _ => acc
      }
    });

  <span key className> content->s </span>;
};

let renderLine = (~key: string, tokens: array(Lexer.token)): React.element => {
  <pre key className="bg-fire-15 rounded p-4 mb-4 ">

      {SgrString.fromTokens(tokens)
       ->Belt.Array.mapWithIndex((i, str) => {
           let key = key ++ " " ++ Belt.Int.toString(i);
           renderSgrString(~key, str);
         })
       ->ate}
    </pre>;
    // Note: pre is essential here, otherwise whitespace and newlines are not respected
};

/*
   Renders an array of ANSI encoded strings
   and applying the right styling for our design system
 */
[@react.component]
let make = (~className=?, ~children: array(string)) => {
  let lines =
    Belt.Array.mapWithIndex(children, (i, line) =>
      line->Ansi.parse->renderLine(~key=Belt.Int.toString(i))
    );
  <div ?className> lines->ate </div>;
};
