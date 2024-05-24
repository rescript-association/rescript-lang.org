let css = `body {
  background-color: inherit;
  color: CanvasText;
  color-scheme: light dark;
}`

let reactVersion = "18.2.0"

let srcDoc = `
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>Playground Output</title>
        <style>${css}</style>
      </head>
      <body>
        <div id="root"></div>
        <script>
          window.addEventListener("message", (event) => {
            try {
              eval(event.data);
            } catch (err) {
              console.error(err);
            }
          });
          const sendLog = (logLevel) => (...args) => {
            let finalArgs = args.map(arg => {
              if (typeof arg === 'object') {
                return JSON.stringify(arg);
              }
              return arg;
            });
            parent.window.postMessage({ type: logLevel, args: finalArgs }, '*')
          };
          console.log = sendLog('log');
          console.warn = sendLog('warn');
          console.error = sendLog('error');
        </script>
      </body>
    </html>
  `

let sendOutput = code => {
  open Webapi

  let frame = Document.document->Element.getElementById("iframe-eval")

  switch frame {
  | Value(element) =>
    switch element->Element.contentWindow {
    | Some(win) => win->Element.postMessage(code, ~targetOrigin="*")
    | None => RescriptCore.Console.error("contentWindow not found")
    }
  | Null | Undefined => RescriptCore.Console.error("iframe not found")
  }
}

@react.component
let make = () => {
  <iframe width="100%" id="iframe-eval" className="relative w-full text-gray-20" srcDoc />
}
