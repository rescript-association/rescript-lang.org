import React from "react";
import { Html, Head, Main, NextScript } from "next/document";

const isProduction = process.env.ENV === "production";

export default function Document() {
  return (
    <Html>
      <Head>
        <link
          rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/docsearch.js@2/dist/cdn/docsearch.min.css"
        />
        <script
          type="text/javascript"
          src="https://cdn.jsdelivr.net/npm/docsearch.js@2/dist/cdn/docsearch.min.js"
        />
      </Head>
      <body>
        <Main />
        <NextScript />

        {isProduction && (
          <React.Fragment>
            <script
              async
              defer
              src="https://scripts.simpleanalyticscdn.com/latest.js"
            />
            <noscript>
              <img
                src="https://queue.simpleanalyticscdn.com/noscript.gif"
                alt=""
              />
            </noscript>
          </React.Fragment>
        )}
      </body>
    </Html>
  );
}
