const bsconfig = require("./bsconfig.json");
const withCSS = require("@zeit/next-css");
const withTM = require("next-transpile-modules");
const path = require('path');
const remarkSlug = require('remark-slug');

const withMdx = require("@next/mdx")({
  extension: /\.mdx?$/,
  options: {
    remarkPlugins: [remarkSlug]
  }
});

const config = {
  target: "serverless",
  pageExtensions: ["jsx", "js", "bs.js", "mdx"],
  transpileModules: ["bs-platform"].concat(bsconfig["bs-dependencies"]),
  webpack: (config, _options) => {
    // Here is the magic
    // We push our config into the resolve.modules array
    config.resolve.modules.push(path.resolve('./'))
    return config
  }
};

module.exports = withMdx(withTM(withCSS(config)));
