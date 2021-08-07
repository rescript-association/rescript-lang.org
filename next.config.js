const { ProvidePlugin } = require('webpack');
const { ESBuildMinifyPlugin } = require('esbuild-loader');

const bsconfig = require("./bsconfig.json");
const path = require("path");
const remarkSlug = require("remark-slug");
const fs = require("fs");

const transpileModules = ["rescript"].concat(bsconfig["bs-dependencies"]);
const withTM = require("next-transpile-modules")(transpileModules);

const withMdx = require("./plugins/next-mdx")({
  extension: /\.mdx?$/,
  options: {
    remarkPlugins: [remarkSlug],
  },
});


// esbuild-loader specific features
// See: https://github.com/privatenumber/esbuild-loader-examples/blob/master/examples/next/next.config.js
function useEsbuildMinify(config, options) {
  const terserIndex = config.optimization.minimizer.findIndex(minimizer => (minimizer.constructor.name === 'TerserPlugin'));
  if (terserIndex > -1) {
    config.optimization.minimizer.splice(
      terserIndex,
      1,
      new ESBuildMinifyPlugin(options),
    );
  }
}

const isWebpack5 = true;
const config = {
  target: "serverless",
  pageExtensions: ["jsx", "js", "bs.js", "mdx", "mjs"],
  env: {
    ENV: process.env.NODE_ENV,
  },
  webpack: (config, options) => {
    const { isServer } = options;
    if (isWebpack5) {
      if (!isServer) {
        // We shim fs for things like the blog slugs component
        // where we need fs access in the server-side part
        config.resolve.fallback = {
          fs: false,
          path: false,
        };
      }
      useEsbuildMinify(config);
      // We need this additional rule to make sure that mjs files are
      // correctly detected within our src/ folder
      config.module.rules.push({
        test: /\.m?js$/,
        // v-- currently using an experimental setting with esbuild-loader
        //use: options.defaultLoaders.babel,
        use: [{loader: 'esbuild-loader', options: { loader: 'jsx'}}],
        exclude: /node_modules/,
        type: "javascript/auto",
        resolve: {
          fullySpecified: false,
        }
      });
      config.plugins.push(new ProvidePlugin({ React: "react" }));
    }
    return config;
  },
  async redirects() {
    return [
      {
        source: "/community",
        destination: "/community/overview",
        permanent: true,
      },
      {
        source: "/bucklescript-rebranding",
        destination: "/blog/bucklescript-is-rebranding",
        permanent: true,
      },
    ];
  },
  future: {
    webpack5: isWebpack5,
  },
};

module.exports = withMdx(withTM(config));
