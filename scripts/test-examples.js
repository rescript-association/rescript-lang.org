/*
 * This script globs all `pages/*.mdx` files and
 * parses all codeblocks with an `example` and `prelude` meta string.
 *
 * For every mdx files with prelude, it will prepand all prelude snippets on each
 * parse example.
 *
 * It will then run the full prelude + example code through `bsc -i -e
 * '[code]'` (only since version 5.2) and check if there was a non-0 exit code.
 *
 * If an error was found, then stderr will be modified to output the right
 * error location in the mdx file (pointing to the correct line inside the
 * codeblock)
 *
 * This script can also be run for a subset of files via a glob:
 *
 * ```
 * # Don't forget the doubleticks, otherwise asterisks might not be recognized
 * node scripts/test-examples.js "pages/belt_docs/array.mdx"
 * ```
 *
 */
const unified = require("unified");
const markdown = require("remark-parse");
const stringify = require("remark-stringify");
const glob = require("glob");
const path = require("path");
const fs = require("fs");
const child_process = require("child_process");
const util = require("util");

const execFile = util.promisify(child_process.execFile);

// Plugin for parsing the test candiates
const candidates = options => (tree, file) => {
  const signatures = [];
  const examples = [];
  const preludes = [];

  const formatter = v => v;

  const { children } = tree;

  children.forEach(child => {
    if (child.type === "code" && child.value) {
      const { meta, lang = "_" } = child;
      if (lang === "re") {
        if (meta === "sig") {
          signatures.push(formatter(child.value));
        } else if (meta === "example") {
          const line = child.position.start.line;
          examples.push({ value: formatter(child.value), line });
        } else if (meta === "prelude") {
          const line = child.position.start.line;
          preludes.push({ value: formatter(child.value), line });
        }
      }
    }
  });

  const candidates = { signatures, examples, preludes };
  file.data = Object.assign({}, file.data, { candidates });
};

const processor = unified()
  .use(markdown, { gfm: true })
  .use(stringify)
  .use(candidates);

const MD_DIR = path.join(__dirname, "../pages");

const BSC = path.join(__dirname, "../node_modules/.bin/bsc");

// relFilepath: instead of whole absolute path, just paths like `pages/...`
// prelude: All prelude snippets in one string which will be prepended to each example
const testExample = async (relFilepath, example, prelude) => {
  const { line, value } = example;

  const preludeLines = prelude !== "" ? prelude.split("\n").length : 0;
  const fullCode = prelude ? `${prelude}\n${value}` : value;

  console.log(`Testing example in '${relFilepath}' on line ${line}...`);
  try {
    const ret = await execFile(BSC, ["-i", "-e", fullCode]);
    return { status: "ok" };
  } catch (e) {
    const { stderr } = e;

    const matchParseErr = stderr.match(/, line ([0-9]+)/);
    const matchCompErr = stderr.match(/([0-9]+):(.*)/);

    // Relative line inside the codesnippet
    let relLine;
    let relPos;

    if (matchParseErr) {
      relLine = matchParseErr[1];
    } else if (matchCompErr) {
      relLine = matchCompErr[1];
      relPos = matchCompErr[2];
    }

    // Markdown line + relative line - prelude lines = the actual error line
    const errorLine = line + (relLine ? parseInt(relLine) : 0) - preludeLines;

    // If there are parsing errors, there might not be a relPos (e.g. [line]:1-5)
    const lineAndPos = errorLine + (relPos ? ":" + relPos : "");

    const improvedStderr = stderr.replace(
      /\/var.*/g,
      `${relFilepath}: ${lineAndPos}`
    );

    //console.error(improvedStderr);
    return { status: "failed", stderr: improvedStderr, line: errorLine };
  }
};

const testPrelude = async (relFilepath, prelude) => {
  const { line, value } = prelude;
  console.log(`Testing prelude in '${relFilepath}' on line ${line}...`);

  try {
    const ret = await execFile(BSC, ["-i", "-e", value]);
    return { status: "ok" };
  } catch (e) {
    const { stderr } = e;

    // Relative line inside the codesnippet
    const [_, relLine, relPos] = stderr.match(/([0-9]+):(.*)/);

    // Markdown line + relative line = the actual error line
    const errorLine = line + (relLine ? parseInt(relLine) : 0);

    // If there are parsing errors, there might not be a relPos (e.g. [line]:1-5)
    const lineAndPos = errorLine + (relPos ? ":" + relPos : "");

    const improvedStderr = stderr.replace(
      /\/var.*/g,
      `${relFilepath}: ${lineAndPos}`
    );

    //console.error(improvedStderr);
    return { status: "failed", stderr: improvedStderr, line: errorLine };
  }
};

const testFile = async filepath => {
  const content = fs.readFileSync(filepath, "utf8");
  const root = path.resolve(".");
  const relFilepath = path.relative(root, filepath);

  const result = processor.processSync(content);
  const { examples, preludes } = result.data.candidates;

  const testedPreludes = await Promise.all(
    preludes.map(async prelude => {
      const result = await testPrelude(relFilepath, prelude);
      return {
        ...prelude,
        filepath: relFilepath,
        result
      };
    })
  );

  const preludeFailed =
    testedPreludes.filter(e => e.result.status === "failed").length > 0;

  // Don't attempt to test the examples if one of the preludes is broken
  if (preludeFailed) {
    return testedPreludes;
  }

  // This is the prelude code which will get appended to each example
  const fullPrelude = preludes.map(prelude => prelude.value).join("\n");

  const testedExamples = await Promise.all(
    examples.map(async example => {
      const result = await testExample(relFilepath, example, fullPrelude);
      return {
        ...example,
        filepath: relFilepath,
        result
      };
    })
  );

  if (testedExamples.length > 0) {
    console.log(`\n-------Results for '${relFilepath}'----------`);
    testedExamples.forEach(e => {
      const { line, filepath } = e;
      const { status } = e.result;
      console.log(`${filepath}:${line} => ${status}`);
    });
  }

  return testedExamples;
};

const showErrorMsg = failedExample => {
  const { stderr } = failedExample.result;
  console.log(`\n-----------\nError Preview:`);
  console.log(stderr);
};

const main = async () => {
  const [, , pattern] = process.argv;
  const files = glob.sync(pattern ? pattern : `${MD_DIR}/**/*.md?(x)`);

  const allTested = await files.reduce(async (acc, filepath) => {
    const tested = await testFile(filepath);
    return [...(await acc), ...tested];
  }, []);

  const failed = allTested.filter(e => e.result.status === "failed");
  const success = allTested.filter(e => e.result.status === "ok");

  console.log("-----------\nSummary:");
  console.log(`Total Examples: ${allTested.length}`);
  console.log(`Failed: ${failed.length}`);
  console.log(`Success: ${success.length}`);

  if (failed.length > 0) {
    console.log(
      `\nTip: You can also run tests just for specific files / globs:`
    );
    console.log('`node scripts/test-examples.js "pages/belt_docs/array.mdx"`');
    showErrorMsg(failed[0]);
    process.exit(1);
  }
};

main();
