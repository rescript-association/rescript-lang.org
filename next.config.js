const bsconfig = require("./bsconfig.json");
const withCSS = require("@zeit/next-css");
const withTM = require("next-transpile-modules");
const path = require('path');
const remarkSlug = require('remark-slug');

const withMdx = require("./plugins/next-mdx")({
  extension: /\.mdx?$/,
  options: {
    remarkPlugins: [remarkSlug]
  }
});

const config = {
  target: "serverless",
  pageExtensions: ["jsx", "js", "bs.js", "mdx"],
  transpileModules: ["bs-platform"].concat(bsconfig["bs-dependencies"]),
  env: {
    ENV: process.env.NODE_ENV,
  },
  webpack: (config, options) => {
    const { isServer } = options;
    if (!isServer) {
      // We shim fs for things like the blog slugs component
      // where we need fs access in the server-side part
      config.node = {
        fs: 'empty'
      }
    }
    return config
  }
};

module.exports = withMdx(withTM(withCSS(config)));
