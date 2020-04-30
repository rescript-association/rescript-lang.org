const { getOptions } = require("loader-utils");
const mdx = require("@mdx-js/mdx");
const matter = require("gray-matter");
const stringifyObject = require("stringify-object");

const DEFAULT_RENDERER = `
import React from 'react'
import { mdx } from '@mdx-js/react'
`;

const loader = async function(raw) {
  const callback = this.async();
  const options = Object.assign({}, getOptions(this), {
    filepath: this.resourcePath
  });

  let result;

  const { content, data } = matter(raw);

  try {
    result = await mdx(content, options);
  } catch (err) {
    return callback(err);
  }

  const { renderer = DEFAULT_RENDERER } = options;

  /* We need to attach frontmatter to the MDXContent component function to be able
     to access the frontmatter within the App.re module without the need of writing
     custom getStaticProps etc to do the frontmatter handling and injection */
  const code = `${renderer}\n${result}
MDXContent.frontmatter = ${stringifyObject(data)};`;

  return callback(null, code);
};

module.exports = loader;
