import React from "react";
import Document, { Head, Main, NextScript } from "next/document";

export default class extends Document {
  render() {
    const isProduction = process.env.ENV === "production";
    return (
      <html>
        <Head></Head>
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
      </html>
    );
  }
}
