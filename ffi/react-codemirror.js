// Inspired by:
// - https://github.com/ResourcesCo/snippets/blob/master/docs/codemirror-with-next.md
// - https://jaketrent.com/post/render-codemirror-on-server/
//
// I'd like to get rid of this setup, feels really hacky

import React, { Component } from "react";
import { UnControlled as CodeMirror } from "react-codemirror2";
import "codemirror/lib/codemirror.css";
import "codemirror/theme/material.css";

import "codemirror/lib/codemirror.css";

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

if (typeof window !== 'undefined' && typeof window.navigator !== 'undefined') {
  require('codemirror/mode/javascript/javascript')
  require('codemirror/mode/rust/rust')
}

export default function CodeMirrorReact(props) {
  return (
    <CodeMirror
      value={props.value}
      options={{ theme: "material" }}
      onChange={props.onChange}
    />
  );
}
