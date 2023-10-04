// import App from 'next/app'


//function MyApp({ Component, pageProps }) {
  //console.log(pageProps);
  //return <Component {...pageProps} />
//}

import "styles/main.css";
import "styles/utils.css";
import "codemirror/lib/codemirror.css";
import "styles/cm.css";
import "styles/docson.css";

import hljs from 'highlight.js/lib/core'
import javascript from 'highlight.js/lib/languages/javascript'
import css from 'highlight.js/lib/languages/css'
import ocaml from 'highlight.js/lib/languages/ocaml'
import reason from 'plugins/reason-highlightjs'
import rescript from 'plugins/rescript-highlightjs'
import bash from 'highlight.js/lib/languages/bash'
import json from 'highlight.js/lib/languages/json'
import html from 'highlight.js/lib/languages/xml'
import text from 'highlight.js/lib/languages/plaintext'
import diff from 'highlight.js/lib/languages/diff'

hljs.registerLanguage('reason', reason)
hljs.registerLanguage('rescript', rescript)
hljs.registerLanguage('javascript', javascript)
hljs.registerLanguage('css', css)
hljs.registerLanguage('ts', javascript)
hljs.registerLanguage('ocaml', ocaml)
hljs.registerLanguage('sh', bash)
hljs.registerLanguage('json', json)
hljs.registerLanguage('text', text)
hljs.registerLanguage('html', html)
hljs.registerLanguage('diff', diff)

// import {make as ResApp} from "src/common/App.mjs";

export default function App({ Component, pageProps }) {
  return  <Component {...pageProps} />;
};
