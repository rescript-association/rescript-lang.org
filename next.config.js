const bsconfig = require("./bsconfig.json");
const withCSS = require("@zeit/next-css");
const withTM = require("next-transpile-modules");

const withMdx = require("@next/mdx")({
  extension: /\.mdx?$/,
});

const config = {
  target: "serverless",
  pageExtensions: ["jsx", "js", "bs.js", "mdx"],
  transpileModules: ["bs-platform"].concat(bsconfig["bs-dependencies"])
};

module.exports = withMdx(withTM(withCSS(config)));
