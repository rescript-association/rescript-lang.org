/*
    This module parses ANSI encoded string into structured data.
    It is mostly build for parsing BuckleScript terminal output and
    is not implementing the whole Ansi functionality.

    See: https://en.wikipedia.org/wiki/ANSI_escape_code#Escape_sequences

    Other relevant resources:
    ----
    OCaml compiler Misc.Color encoding colors in the output printers:
    https://github.com/BuckleScript/ocaml/blob/0a3ec12fef5dbee795778a47b18024563b5e49f2/utils/misc.ml
 */

type color =
  | Black // fg=30 bg=40
  | Red // fg=31 bg=41
  | Green // fg=32 bg=42
  | Yellow // fg=33 bg=43
  | Blue // fg=34 bg=44
  | Magenta // fg=35 bg=45
  | Cyan // fg=36 bg=46
  | White; // fg=37 bg=47

module Color = {
  let toString = (c: color) =>
    switch (c) {
    | Black => "black"
    | Red => "red"
    | Green => "green"
    | Yellow => "yellow"
    | Blue => "blue"
    | Magenta => "magenta"
    | Cyan => "cyan"
    | White => "white"
    };
};

// We don't encode Clear (0) here since it's a special case
type sgr =
  | Bold // 1
  | Fg(color) // 30 - 37
  | Bg(color) // 40 - 47
  | Unknown(string);

let sgrToString = s => {
  switch (s) {
  | Bold => "bold"
  | Fg(c) => "Fg(" ++ Color.toString(c) ++ ")"
  | Bg(c) => "Bg(" ++ Color.toString(c) ++ ")"
  | Unknown(s) => "Unknown: " ++ s
  };
};

let esc = {j|\u001B|j};

let isAscii = (c: string) => {
  Js.Re.test_([%re {|/[\x40-\x7F]/|}], c);
};

module Location = {
  type t = {
    input: string,
    mutable pos: int,
  };

  type loc = {
    startPos: int,
    endPos: int,
  };

  let fromString = input => {input, pos: (-1)};

  let isDone = p => p.pos >= Js.String.length(p.input) - 1;

  let next = p =>
    if (!isDone(p)) {
      let c = Js.String2.get(p.input, p.pos + 1);
      p.pos = p.pos + 1;
      c;
    } else {
      Js.String2.get(p.input, p.pos);
    };

  let untilNextEsc = p => {
    let ret = ref(None);
    while (!isDone(p) && ret^ == None) {
      let c = next(p);

      if (c === esc) {
        ret := Some();
      };
    };
    ret^;
  };

  // Look is useful to look ahead without reading the character
  // from the stream
  let look = (p, num) => {
    let length = Js.String.length(p.input);

    let pos =
      if (p.pos + num >= length) {
        length - 1;
      } else {
        p.pos + num;
      };

    Js.String2.get(p.input, pos);
  };
};

module Lexer = {
  open Location;

  type token =
    | Text({
        loc: Location.loc,
        content: string,
      })
    | Sgr({
        loc: Location.loc,
        raw: string,
        sgrs: array(sgr),
      })
    | ClearSgr({
        loc: Location.loc,
        raw: string,
      });

  type state =
    | Start
    | SgrOpen({
        startPos: int,
        content: string,
      }) // contains collected data
    | ReadText({
        startPos: int,
        content: string,
      });

  let rec lex =
          (~acc: array(token)=[||], ~state=Start, p: Location.t)
          : array(token) =>
    if (isDone(p)) {
      acc;
    } else {
      switch (state) {
      | Start =>
        let c = next(p);
        // We start by checking the first character to see if we start
        // with reading text or reading an SGR sequence
        let state =
          if (c === esc) {
            SgrOpen({startPos: p.pos, content: ""});
          } else {
            ReadText({startPos: p.pos, content: c});
          };
        lex(~acc, ~state, p);
      | ReadText({startPos, content}) =>
        let c = next(p);

        // Determine if we are keep reading text, or start read SGRs
        if (c === esc) {
          let token = Text({
                        loc: {
                          startPos,
                          endPos: p.pos,
                        },
                        content,
                      });
          let acc = Js.Array2.concat(acc, [|token|]);
          lex(~acc, ~state=SgrOpen({startPos: p.pos, content: c}), p);
        } else if (isDone(p)) {
          let token = Text({
                        loc: {
                          startPos,
                          endPos: p.pos,
                        },
                        content,
                      });
          let acc = Js.Array2.concat(acc, [|token|]);
          acc;
        } else {
          let content = content ++ c;
          lex(~acc, ~state=ReadText({startPos, content}), p);
        };
      | SgrOpen({startPos, content}) =>
        let c = next(p);

        // on termination
        if (c !== "[" && isAscii(c)) {
          let raw = content ++ c;

          let loc = {startPos, endPos: startPos + Js.String.length(raw) - 1};

          let token =
            Js.Re.exec_([%re {|/\[([0-9;]+)([\x40-\x7F])/|}], raw)
            ->(
                fun
                | Some(result) => {
                    let groups = Js.Re.captures(result);
                    switch (Js.Nullable.toOption(groups[1])) {
                    | Some(str) =>
                      switch (Js.String2.split(str, ";")) {
                      | [|"0"|] => ClearSgr({loc, raw})
                      | other =>
                        let sgrs =
                          Belt.Array.map(other, s => {
                            switch (s) {
                            | "1" => Bold
                            | "30" => Fg(Black)
                            | "31" => Fg(Red)
                            | "32" => Fg(Green)
                            | "33" => Fg(Yellow)
                            | "34" => Fg(Blue)
                            | "35" => Fg(Magenta)
                            | "36" => Fg(Cyan)
                            | "37" => Fg(White)
                            | "40" => Bg(Black)
                            | "41" => Bg(Red)
                            | "42" => Bg(Green)
                            | "43" => Bg(Yellow)
                            | "44" => Bg(Blue)
                            | "45" => Bg(Magenta)
                            | "46" => Bg(Cyan)
                            | "47" => Bg(White)
                            | o => Unknown(o)
                            }
                          });
                        Sgr({loc, raw, sgrs});
                      }

                    | None => Sgr({loc, raw, sgrs: [||]})
                    };
                  }
                | None => Sgr({loc, raw, sgrs: [||]})
              );
          let acc = Js.Array2.concat(acc, [|token|]);
          lex(~acc, ~state=Start, p);
        } else {
          lex(~acc, ~state=SgrOpen({startPos, content: content ++ c}), p);
        };
      };
    };

};

let parse = (input: string) => {
  let p = Location.fromString(input);
  Lexer.lex(p);
};

let onlyText = (tokens: array(Lexer.token)) => {
  Lexer.(
    Belt.Array.keep(
      tokens,
      fun
      | Text(_) => true
      | _ => false,
    )
  );
};

module Printer = {
  open Lexer;

  let tokenString = (t: token): string => {
    switch (t) {
    | Text({content, loc: {startPos, endPos}}) =>
      let content =
        Js.String2.(
          replaceByRe(content, [%re "/\\n/g"], "\\n")->replace(esc, "")
        );
      {j|Text "$content" ($startPos to $endPos)|j};
    | Sgr({sgrs, raw, loc: {startPos, endPos}}) =>
      let raw = Js.String2.replace(raw, esc, "");
      let commands =
        Belt.Array.map(sgrs, sgrToString)->Js.Array2.joinWith(", ");
      {j|Sgr "$raw" -> $commands ($startPos to $endPos)|j};
    | ClearSgr({loc: {startPos, endPos}, raw}) =>
      let raw = Js.String2.replace(raw, esc, "");
      {j|Clear Sgr "$raw" ($startPos to $endPos)|j};
    };
  };

  let plainString = (tokens: array(token)): string => {
    Belt.Array.map(
      tokens,
      fun
      | Lexer.Text({content}) => content
      | _ => "",
    )
    ->Js.Array2.joinWith("");
  };
};
