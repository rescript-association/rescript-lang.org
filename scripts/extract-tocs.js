/*
 * This script is used for generating the table of contents for prose
 * text documents
 */
const unified = require("unified");
const markdown = require("remark-parse");
const stringify = require("remark-stringify");
const slug = require('remark-slug');
const glob = require("glob");
const path = require("path");
const fs = require("fs");

// Used for collapsing nested inlineCodes with the actual header text
const collapseHeaderChildren = (children) => {
  return children.reduce((acc, node) => {
    if(node.type === "link") {
      return acc + collapseHeaderChildren(node.children);
    }
    // Prevents 'undefined' values in our headers
    else if(node.value == null) {
      return acc;
    }
    return acc + node.value
  }, "");
}

const headers = options => (tree, file) => {
  const headers = [];
  let mainHeader;
  tree.children.forEach(child => {
    if (child.type === "heading" && child.depth === 1) {
      if (child.children.length > 0) {
        mainHeader = collapseHeaderChildren(child.children);
      }
    }
    if (child.type === "heading" && child.depth === 2) {
      if (child.children.length > 0) {
        // Take the id generated from remark-slug
        const headerValue = collapseHeaderChildren(child.children);
        const id = child.data.id || "";
        headers.push({ name: headerValue, href: id });
      }
    }
  });

  file.data = Object.assign({}, file.data, { headers, mainHeader });
};

const processor = unified()
  .use(markdown, { gfm: true })
  .use(slug)
  .use(stringify)
  .use(headers);

const processFile = filepath => {
  const content = fs.readFileSync(filepath, "utf8");
  const result = processor.processSync(content);

  const pagesPath = path.resolve("./pages");
  const relFilepath = path.relative(pagesPath, filepath);
  const parsedPath = path.parse(relFilepath);
  const filename = path.basename(filepath, path.extname(filepath));

  const dataset = {
    headers: result.data.headers,
    href: path.join(parsedPath.dir, parsedPath.name),
    title: result.data.mainHeader || filename
  };
  return dataset;
};

const createTOC = result => {
  // Currently we reorder the data to a map, the key is
  // reflected as the router pathname, as defined by the
  // NextJS router
  return result.reduce((acc, data) => {
    const { title, headers } = data;
    acc["/" + data.href] = {
      title,
      headers
    };

    return acc;
  }, {});
};

const createManualToc = () => {
  const MD_DIR = path.join(__dirname, "../pages/docs/manual/latest");
  const TARGET_FILE = path.join(__dirname, "../index_data/manual_toc.json");

  const files = glob.sync(`${MD_DIR}/*.md?(x)`);
  const result = files.map(processFile);
  const toc = createTOC(result);

  fs.writeFileSync(TARGET_FILE, JSON.stringify(toc), "utf8");
};

const createReasonCompilerToc = () => {
  const MD_DIR = path.join(__dirname, "../pages/docs/reason-compiler/latest");
  const TARGET_FILE = path.join(__dirname, "../index_data/reason_compiler_toc.json");

  const files = glob.sync(`${MD_DIR}/*.md?(x)`);
  const result = files.map(processFile);
  const toc = createTOC(result);

  fs.writeFileSync(TARGET_FILE, JSON.stringify(toc), "utf8");

};

const createReasonReactToc = () => {
  const MD_DIR = path.join(__dirname, "../pages/docs/reason-react/latest");
  const TARGET_FILE = path.join(__dirname, "../index_data/reason_react_toc.json");

  const files = glob.sync(`${MD_DIR}/*.md?(x)`);
  const result = files.map(processFile);
  const toc = createTOC(result);

  fs.writeFileSync(TARGET_FILE, JSON.stringify(toc), "utf8");
};

const createGenTypeToc = () => {
  const MD_DIR = path.join(__dirname, "../pages/docs/gentype/latest");
  const TARGET_FILE = path.join(__dirname, "../index_data/gentype_toc.json");

  const files = glob.sync(`${MD_DIR}/*.md?(x)`);
  const result = files.map(processFile);
  const toc = createTOC(result);

  fs.writeFileSync(TARGET_FILE, JSON.stringify(toc), "utf8");
};

/*
const debugToc = () => {
  const MD_DIR = path.join(__dirname, "../pages/docs/manual/latest");

  const files = glob.sync(`${MD_DIR}/introduction.md?(x)`);
  const result = files.map(processFile);
  const toc = createTOC(result);

  console.log(JSON.stringify(toc, null, 2));

};

debugToc();
*/

// main
createManualToc();
createReasonCompilerToc();
createReasonReactToc();
createGenTypeToc();
