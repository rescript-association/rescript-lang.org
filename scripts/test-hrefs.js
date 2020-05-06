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

// Our blogposts are stored in a different directory than `pages`
// So we need to function to map between pages <--> _blogposts
// e.g. "./_blogposts/compiler/foo.mdx" => "./pages/blog/foo.mdx"
// e.g. "./_blogposts/other.mdx" => "./pages/blog/other.mdx"
const mapBlogFilePath = (path) => {
  const match = path.match(/\.\/_blogposts\/(.*\/)*(.*\.mdx)/);

  if(match) {
    return `./pages/blog/${match[2]}`;
  }
  return path;
};

// Creates a lookup table of all available pages within the website
// It will also automatically map urls for dedicated directorys (such as _blogposts)
// to the correct url
// { key=url: value=original_filepath}
const createPageIndex = files => {
  return files.reduce((acc, path) => {
    // We need to consider all the different file formats used in pages
    // Calculate the website url by stripping .re, .bs.js, .md(x), etc.
    let url = mapBlogFilePath(path).replace(/^\.\//, "/").replace(/\.re|\.bs\.js|\.js|\.md(x)?$/, "");

    // For index we need to special case, since it can be referred as '/' as well
    if(path.match(/\.\/pages\/index(\.re|\.bs\.js|\.js|\.md(x))?$/)) {
      url = "/pages/";
    }

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

const showErrorMsg = failedTest => {
  const { stderr } = failedTest;
  console.log(`\n-----------\nError Preview:`);
  console.log(stderr);
};

const testFile = (pageMap, test) => {
  const filepath = test.filepath;

  // Used for storing failed / ok hrefs
  const results = [];

  test.links.forEach(link => {
    const parsed = urlModule.parse(link.url);

    // Drops .md / .mdx / .html file extension in pathname section, since UI ignores them
    // Needs to be kept in sync with `components/Markdown.re`s <A> component
    // This requirements stems from the original documentation on reasonml.github.io, where lots of .md / .html
    // hrefs are included
    let url = link.url;
    if (parsed.pathname) {
      parsed.pathname = parsed.pathname.replace(/\.md(x)?|\.html$/, "");
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
    if (
      parsed.protocol == null &&
      url !== parsed.hash &&
      !parsed.pathname.startsWith("//")
    ) {
      // If there is a relative link like '../manual/latest', we need to resolve it
      // relatively from the links source filepath
      let resolved;
      if (!path.isAbsolute(url)) {
        resolved = path.join("/", path.dirname(filepath), parsed.pathname);
      } else {
        // e.g. /api/javascript/latest/js needs to be prefixed to actual pages dir
        resolved = path.join("/pages", parsed.pathname);
      }

      // If there's no page stated the relative link
      if (!pageMap[resolved]) {
        const { line, column } = link.position.start;
        const stderr = `${filepath}: Unknown href '${url}' in line ${line}:${column}`;
        results.push({
          status: "failed",
          filepath,
          stderr,
          link
        });
        return;
      }
    }

    results.push({
      status: "ok",
      link
    });
  });

  if (results.length > 0) {
    console.log(`\n-------Results for '${filepath}'----------`);

    results.forEach(r => {
      const { status } = r;
      const { line, column } = r.link.position.start;

      if (status === "failed") {
        console.log(`${filepath}:${line} => ${status} / Unknown href '${r.link.url}' in line ${line}:${column}`);
      } else {
        console.log(`${filepath}:${line} => ${status}`);
      }
    });
  }

  return {
    data: test,
    results
  };
};

const main = () => {
  const [, , pattern] = process.argv;
  const cwd = path.join(__dirname, "..");
  const files = glob.sync(pattern ? pattern : `./{pages,_blogposts}/**/*.md?(x)`, { cwd });

  // We need to capture all files independently from the test file glob
  const pageMapFiles = glob.sync("./{pages,_blogposts}/**/*.{js,mdx}", { cwd });
  const pageMap = createPageIndex(pageMapFiles);

  const processedFiles = files.map(processFile);

  const allTested = processedFiles.map(file => testFile(pageMap, file));

  const failed = allTested.reduce((acc, test) => {
    return acc.concat(test.results.filter(r => r.status === "failed"));
  }, []);

  const success = allTested.reduce((acc, test) => {
    return acc.concat(test.results.filter(r => r.status === "ok"));
  }, []);

  console.log("-----------\nSummary:");
  console.log(`Total Links: ${failed.length + success.length}`);
  console.log(`Failed: ${failed.length}`);
  console.log(`Success: ${success.length}`);

  if (failed.length > 0) {
    console.log(
      `\nTip: You can also run tests just for specific files / globs:`
    );
    console.log('`node scripts/test-hrefs.js "pages/**/*.mdx"`');
    showErrorMsg(failed[0]);
    process.exit(1);
  }
};

main();
