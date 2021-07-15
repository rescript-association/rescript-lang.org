const { ProvidePlugin } = require('webpack');

const bsconfig = require("./bsconfig.json");
const SSRPlugin = require("next/dist/build/webpack/plugins/nextjs-ssr-import")
  .default;
const { dirname, relative, resolve, join } = require("path");
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


// Unfortunately there isn't an easy way to override the replacement function body, so we
// have to just replace the whole plugin `apply` body.
function patchSsrPlugin(plugin) {
  plugin.apply = function apply(compiler) {
    compiler.hooks.compilation.tap("NextJsSSRImport", compilation => {
      compilation.mainTemplate.hooks.requireEnsure.tap(
        "NextJsSSRImport",
        (code, chunk) => {
          // This is the block that fixes https://github.com/vercel/next.js/issues/22581
          if (!chunk.name) {
            return;
          }

          // Update to load chunks from our custom chunks directory
          const outputPath = resolve("/");
          const pagePath = join("/", dirname(chunk.name));
          const relativePathToBaseDir = relative(pagePath, outputPath);
          // Make sure even in windows, the path looks like in unix
          // Node.js require system will convert it accordingly
          const relativePathToBaseDirNormalized = relativePathToBaseDir.replace(
            /\\/g,
            "/"
          );
          return code
            .replace(
              'require("./"',
              `require("${relativePathToBaseDirNormalized}/"`
            )
            .replace(
              "readFile(join(__dirname",
              `readFile(join(__dirname, "${relativePathToBaseDirNormalized}"`
            );
        }
      );
    });
  };
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

      // We need this additional rule to make sure that mjs files are
      // correctly detected within our src/ folder
      config.module.rules.push({
        test: /\.m?js$/,
        use: options.defaultLoaders.babel,
        exclude: /node_modules/,
        type: "javascript/auto",
        resolve: {
          fullySpecified: false,
        }
      });
      config.plugins.push(new ProvidePlugin({ React: "react" }));
    }

    const ssrPlugin = config.plugins.find(
      plugin => plugin instanceof SSRPlugin
    );

    if (ssrPlugin) {
      patchSsrPlugin(ssrPlugin);
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
