/*
 * This script globs all `pages/*.mdx` files and
 * parses all <a> hrefs with relative links (starting with '/' or `./`)
 *
 * It will report any href which does not link to a valid page within
 * the website.
 */

const unified = require("unified");
const markdown = require("remark-parse");
const stringify = require("remark-stringify");
const glob = require("glob");
const path = require("path");
const fs = require("fs");
const urlModule = require("url");

// Creates a lookup table of all available pages within the website
// { key=url: value=original_filepath}
const createPageIndex = files => {
  return files.reduce((acc, path) => {
    const url = path.replace(/^\.\//, "/").replace(/\.md?(x)/, "");
    acc[url] = path;
    return acc;
  }, {});
};

const flattenChildren = children => {
  return children.reduce((acc, node) => {
    if (node.type === "link") {
      return acc.concat([node]);
    } else if (node.children) {
      let value = flattenChildren(node.children);
      return acc.concat(value);
    }
    return acc;
  }, []);
};

// Finds all relative links within a file
const hrefs = options => (tree, file) => {
  const links = flattenChildren(tree.children);

  file.data = Object.assign({}, file.data, { links });
};

const processor = unified()
  .use(markdown, { gfm: true })
  .use(stringify)
  .use(hrefs);

const processFile = filepath => {
  const content = fs.readFileSync(filepath, "utf8");
  const result = processor.processSync(content);

  result.data.filepath = filepath;

  return result.data;
};

const main = () => {
  const cwd = path.join(__dirname, "..");
  const files = glob.sync(`./pages/docs/manual/**/*.md?(x)`, { cwd });
  const results = files.map(processFile);

  const pageMap = createPageIndex(files);

  const testLinks = test => {
    const filepath = test.filepath;

    test.links.forEach(link => {
      const { url } = link;
      const parsed = urlModule.parse(url);

      // Scenarios where links should NOT be checked
      // Case 1: url = #hello-world
      // Case 2: url = https://...
      //
      // Everything else is a relative link and should be checked
      // in the files map
      if (parsed.protocol == null && url !== parsed.hash) {
        // If there is a relative link like '../manual/latest', we need to resolve it
        // relatively from the links source filepath
        let resolved = url;
        if (!path.isAbsolute(url)) {
          resolved = path.join("/", path.dirname(filepath), parsed.pathname);
        }

        // If there's no page stated the relative link
        if (!pageMap[resolved]) {
          const { line, column } = link.position.start;
          const err = `Unknown link '${url}' found in '${filepath}' line ${line}:${column}`;
          console.log(err);
        }
      }
    });
  };
  results.forEach(testLinks);
};

main();
