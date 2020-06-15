// Inspired by:
// - https://github.com/ResourcesCo/snippets/blob/master/docs/codemirror-with-next.md
// - https://jaketrent.com/post/render-codemirror-on-server/
//
// I'd like to get rid of this setup, feels really hacky

import React, { Component } from "react";
import { UnControlled as CodeMirror } from "react-codemirror2";
import "codemirror/lib/codemirror.css";

// We use our own forked codemirror theme here
import "../styles/cm.css";

//import javascript from 'codemirror/mode/javascript/javascript';
//import mllike from 'codemirror/mode/mllike/mllike';
//import rust from 'codemirror/mode/rust/rust';

/*
  options = {
    mode: 'rust',
    lineNumbers: true,
  },
  language = "javascript",
  */

if (typeof window !== "undefined" && typeof window.navigator !== "undefined") {
  require("codemirror/mode/javascript/javascript");
  require("../plugins/cm-reason-mode");
}

export default function CodeMirrorReact(props) {
  return (
    <CodeMirror
      autoCursor={false}
      readOnly={props.readOnly}
      value={props.value}
      onBeforeChange={props.onBeforeChange}
      options={{
        mode:props.mode,
        lineNumbers: true,
        theme: "material",
        readOnly: props.readOnly
      }}
      onChange={props.onChange}
    />
  );
}
