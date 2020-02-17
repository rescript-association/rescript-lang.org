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
  const files = glob.sync(`./pages/**/*.md?(x)`, { cwd });
  const results = files.map(processFile);

  const pageMap = createPageIndex(files);

  const testLinks = test => {
    const filepath = test.filepath;

    test.links.forEach(link => {
      const parsed = urlModule.parse(link.url);

      // Drops .md / .mdx file extension in pathname section, since UI ignores them
      // Needs to be kept in sync with `components/Markdown.re`s <A> component
      let url = link.url;
      if (parsed.pathname) {
        parsed.pathname = parsed.pathname.replace(/\.md(x)?$/, "");
        url = urlModule.format(parsed);
      }

      // Scenarios where links should NOT be checked
      // Case 1: url = #hello-world
      // Case 2: url = https://...
      // Case 3: url = //reasonml.github.io/abc/def -> Special markdown link format pointing to external urls
      //
      // Everything else is a relative link and should be checked
      // in the files map
      // Possibe relative links:
      // - /apis/javascript/foo
      // - latest/belt
      // - ../manual/variants
      if (parsed.protocol == null && url !== parsed.hash && !parsed.pathname.startsWith('//')) {
        // If there is a relative link like '../manual/latest', we need to resolve it
        // relatively from the links source filepath
        let resolved;
        if (!path.isAbsolute(url)) {
          resolved = path.join("/", path.dirname(filepath), parsed.pathname);
        }
        else {
          // e.g. /api/javascript/latest/js needs to be prefixed to actual pages dir
          resolved = path.join("/pages", parsed.pathname);
        }

        // If there's no page stated the relative link
        if (!pageMap[resolved]) {
          const { line, column } = link.position.start;
          const err = `${filepath}: Unknown link '${url}' in line ${line}:${column}`;
          console.log(err);
        }
      }
    });
  };
  results.forEach(testLinks);
};

main();
