const { getOptions } = require("loader-utils");
const mdx = require("@mdx-js/mdx");
const matter = require("gray-matter");
const stringifyObject = require("stringify-object");
const path = require("path");

const DEFAULT_RENDERER = `
import React from 'react'
import { mdx } from '@mdx-js/react'
`;

const pragma = `
/* @jsxRuntime classic */
/* @jsx mdx */
/* @jsxFrag mdx.Fragment */
`;


// This is used to inject some "Edit" link reference
// so we can point our users to the correct resource
// on github for editing
let PROJECT_DIR = path.join(__dirname, "..")
const EDIT_PREFIX = "https://github.com/reason-association/rescript-lang.org/blob/master/"
function createEditHref(filepath) {
  let rel = path.relative(PROJECT_DIR, filepath);
  return EDIT_PREFIX + rel;
}

const loader = async function(raw) {
  const callback = this.async();
  const options = Object.assign({}, getOptions(this), {
    filepath: this.resourcePath
  });

  let result;
  let data;

  try {
    const m = matter(raw);
    result = await mdx(m.content, options);
    data = m.data;
  } catch (err) {
    return callback(err);
  }

  data.__ghEditHref = createEditHref(this.resourcePath);

  const { renderer = DEFAULT_RENDERER } = options;

  /* We need to attach frontmatter to the MDXContent component function to be able
     to access the frontmatter within the App.re module without the need of writing
     custom getStaticProps etc to do the frontmatter handling and injection */
  const code = `${renderer}${pragma}\n${result}
MDXContent.frontmatter = ${stringifyObject(data)};`;

  return callback(null, code);
};

module.exports = loader;
