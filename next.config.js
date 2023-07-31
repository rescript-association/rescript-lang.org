import webpack from "webpack";
import rehypeSlug from 'rehype-slug';
import remarkGfm from 'remark-gfm';
import remarkComment from 'remark-comment';
import nextMDX from "@next/mdx";
import bsconfig from "./bsconfig.json" assert {type: 'json'};
import remarkFrontmatter from 'remark-frontmatter'

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
  pageExtensions: ["jsx", "js", "bs.js", "mdx", "mjs", "md"],
  env: {
    ENV: process.env.NODE_ENV,
  },
  experimental: { esmExternals: 'loose' },
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

export default withMDX({
  transpilePackages: transpileModules,
  ...config
})
