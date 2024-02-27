module AcornParse = {
  type t
  @module("../ffi/acorn-parse.js") external parse: string => t = "parse"

  @module("../ffi/acorn-parse.js") external hasEntryPoint: t => bool = "hasEntryPoint"

  @module("../ffi/acorn-parse.js")
  external removeImportsAndExports: t => string = "removeImportsAndExports"
}

module Transpiler = {
  let run = code =>
    `(function () {
  ${code}
  const root = document.getElementById("root");
  ReactDOM.render(App.make(), root);
})();`
}

module Frame = {
  let css = `body {
  background-color: inherit;
  color: CanvasText;
  color-scheme: light dark;
}`

  let srcdoc = `
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>Playground Output</title>
        <style>${css}</style>
      </head>
      <body>
        <div id="root"></div>
        <script
          src="https://unpkg.com/react@17/umd/react.production.min.js"
          crossorigin
        ></script>
        <script
          src="https://unpkg.com/react-dom@17/umd/react-dom.production.min.js"
          crossorigin
        ></script>
        <script>
          window.addEventListener("message", (event) => {
            try {
              eval(event.data);
            } catch (err) {
              console.error(err);
            }
          });
          console.log = (...args) => {
            let finalArgs = args.map(arg => {
              if (typeof arg === 'object') {
                return JSON.stringify(arg);
              }
              return arg;
            });
            parent.window.postMessage({ type: 'log', args: finalArgs }, '*')
          };
        </script>
      </body>
    </html>
  `

  let sendOutput = code => {
    open Webapi

    let frame =
      Document.document
      ->Element.getElementById("iframe-eval")
      ->Js.Nullable.toOption

    switch frame {
    | Some(element) =>
      switch element->Element.contentWindow {
      | Some(win) => win->Element.postMessage(code, "*")
      | None => ()
      }
    | None => ()
    }
  }
}

let renderOutput = code => {
  let ast = AcornParse.parse(code)
  let transpiled = AcornParse.removeImportsAndExports(ast)
  switch AcornParse.hasEntryPoint(ast) {
  | true =>
    Transpiler.run(transpiled)->Frame.sendOutput
    Ok()
  | false => Error()
  }
}
