module Transpiler = {
  @module("../ffi/removeImportsAndExports") external transpile: string => string = "default"

  let run = code =>
    `(function () {
  ${transpile(code)}
  const root = document.getElementById("root");
  ReactDOM.render(App.make(), root);
})();`
}

module Frame = {
  type document
  type element
  type contentWindow
  @send external postMessage: (contentWindow, string, string) => unit = "postMessage"
  @get external contentWindow: element => option<contentWindow> = "contentWindow"
  @send external getElementById: (document, string) => Js.nullable<element> = "getElementById"
  @val external doc: document = "document"

  let srcdoc = `
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>Playground Output</title>
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
        <script
          src="https://bundleplayground.s3.sa-east-1.amazonaws.com/bundle.js"
          crossorigin
        ></script>
        <script>
          window.addEventListener("message", (event) => {
            try {
              eval(event.data);
            } catch (err) {
              console.log(err);
            }
          });
          console.log = (...args) => {
            let finalArgs = args.map(arg => {
              if (typeof arg == 'object') {
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
    let frame = Js.toOption(doc->getElementById("iframe-eval"))
    switch frame {
    | Some(element) =>
      switch element->contentWindow {
      | Some(win) => win->postMessage(code, "*")
      | None => ()
      }
    | None => ()
    }
  }
}

let renderOutput = code =>
  switch code {
  | Some(code) => Transpiler.run(code)->Frame.sendOutput
  | None => ()
  }
