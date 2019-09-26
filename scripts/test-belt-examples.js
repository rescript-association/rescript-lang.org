/*
 * This script is still experimental.
 * It enables us to capture all necessary codeblocks from all belt markdown files
 * and filtering the codeblocks by language / meta strings
 *
 * Things needed to be done:
 * - Pipe results through bsc and see if it compiles
 * - If compile fails, make proper report to file & position
 */
const unified = require("unified");
const markdown = require("remark-parse");
const stringify = require("remark-stringify");
const codeblocks = require("./lib/codeblocks");
const glob = require("glob");
const path = require("path");
const fs = require("fs");

const filterBy = ({meta, lang}) => {
  return meta == null && lang === "re";
};

const processor = unified()
  .use(markdown, { gfm: true })
  .use(stringify)
  .use(codeblocks, {filterBy});

const BELT_MD_DIR = path.join(__dirname, "../pages/belt_docs");
const files = glob.sync(`${BELT_MD_DIR}/*.md?(x)`);

const content = fs.readFileSync(files[0], 'utf8');

const result = processor.processSync(content);

console.log(JSON.stringify(result.data.codeblocks.re[0]));


