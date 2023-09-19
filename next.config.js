import fs from "fs";
import url from "url";
import path from "path";
import webpack from "webpack";
import rehypeSlug from 'rehype-slug';
import remarkGfm from 'remark-gfm';
import remarkComment from 'remark-comment';
import nextMDX from "@next/mdx";
import remarkFrontmatter from 'remark-frontmatter'
// import remarkParseFrontmatter from "remark-parse-frontmatter";
// import remarkMdxFrontmatter from 'remark-mdx-frontmatter'

const bsconfig = JSON.parse(fs.readFileSync("./bsconfig.json"))

const { ProvidePlugin } = webpack;

const transpileModules = ["rescript"].concat(bsconfig["bs-dependencies"]);

const withMDX = nextMDX({
  extension: /\.mdx?$/,
  options: {
    remarkPlugins: [remarkComment, remarkGfm, remarkFrontmatter],
    providerImportSource: '@mdx-js/react',
    rehypePlugins: [rehypeSlug]
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

    // const loader_path = url.fileURLToPath(path.dirname(import.meta.url));

    // config.module.rules.push({
    //   test: /\.mdx?$/,
    //   use: [{ loader: path.resolve(loader_path, "frontmatter.js") }]
    // });

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

export default withMDX({
  transpilePackages: transpileModules,
  ...config
})
