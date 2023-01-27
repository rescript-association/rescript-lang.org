const { ProvidePlugin } = require("webpack");

const bsconfig = require("./bsconfig.json");
const remarkSlug = require("remark-slug");

const transpileModules = ["rescript"].concat(bsconfig["bs-dependencies"]);
const withTM = require("next-transpile-modules")(transpileModules);

const withMdx = require("@next/mdx")({
  extension: /\.mdx?$/,
  options: {
    remarkPlugins: [remarkSlug],
  },
});

const config = {
  pageExtensions: ["jsx", "js", "bs.js", "mdx", "mjs"],
  env: {
    ENV: process.env.NODE_ENV,
  },
  swcMinify: true,
  webpack: (config, options) => {
    const { isServer } = options;
    if (!isServer) {
      // We shim fs for things like the blog slugs component
      // where we need fs access in the server-side part
      config.resolve.fallback = {
        fs: false,
        path: false,
      };
    }
    // We need this additional rule to make sure that mjs files are
    // correctly detected within our src/ folder
    config.module.rules.push({
      test: /\.m?js$/,
      // v-- currently using an experimental setting with esbuild-loader
      //use: options.defaultLoaders.babel,
      use: [{ loader: "esbuild-loader", options: { loader: "jsx" } }],
      exclude: /node_modules/,
      type: "javascript/auto",
      resolve: {
        fullySpecified: false,
      },
    });
    config.plugins.push(new ProvidePlugin({ React: "react" }));
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
};

module.exports = withMdx({
  transpilePackages: transpileModules,
  ...config,
});
