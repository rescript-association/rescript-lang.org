/*
 * This script is used for generating the table of contents for prose
 * text documents
 */
const unified = require("unified");
const markdown = require("remark-parse");
const matter = require("gray-matter");
const stringify = require("remark-stringify");
const slug = require('remark-slug');
const glob = require("glob");
const path = require("path");
const fs = require("fs");

// orderArr: ["introduction", "overview",,...]
const orderFiles = (filepaths, orderArr) => {
  const order = orderArr.reduce((acc, next, i) => {
    acc[next] = null;
    return acc;
  }, {});

  filepaths.forEach((filepath) => {
    const id = path.basename(filepath, path.extname(filepath));
    order[id] = filepath;
  });

  return Object.values(order);
};

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
  const raw = fs.readFileSync(filepath, "utf8");
  const { content, data } = matter(raw);
  const result = processor.processSync(content);

  const pagesPath = path.resolve("./pages");
  const relFilepath = path.relative(pagesPath, filepath);
  const parsedPath = path.parse(relFilepath);
  const filename = path.basename(filepath, path.extname(filepath));

  let title = result.data.mainHeader || data.title || filename;

  const dataset = {
    id: filename,
    headers: result.data.headers,
    href: path.join(parsedPath.dir, parsedPath.name),
    title,
  };

  if(data.category != null) {
    dataset.category = data.category;
  }
  return dataset;
};

const createTOC = result => {
  // Currently we reorder the data to a map, the key is
  // reflected as the router pathname, as defined by the
  // NextJS router
  return result.reduce((acc, data) => {
    const { title, headers, category, id } = data;
    acc["/" + data.href] = {
      id,
      title,
      headers,
      category,
    };

    return acc;
  }, {});
};

const createLatestManualToc = () => {
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

const createV800ManualToc = () => {
  const MD_DIR = path.join(__dirname, "../pages/docs/manual/v8.0.0");
  const TARGET_FILE = path.join(__dirname, "../index_data/manual_v800_toc.json");

  const files = glob.sync(`${MD_DIR}/*.md?(x)`);
  const result = files.map(processFile);
  const toc = createTOC(result);

  fs.writeFileSync(TARGET_FILE, JSON.stringify(toc), "utf8");
};


const createReactToc = () => {
  const MD_DIR = path.join(__dirname, "../pages/docs/react/latest");
  const TARGET_FILE = path.join(__dirname, "../index_data/react_latest_toc.json");

  const FILE_ORDER = [
    "introduction",
    "installation",
    "elements-and-jsx",
    "rendering-elements",
    "components-and-props",
    "arrays-and-keys",
    "refs-and-the-dom",
    "hooks-overview",
    "hooks-state",
    "hooks-reducer",
    "hooks-effect",
    "hooks-context",
    "hooks-ref",
    "hooks-custom",
  ];

  const files = glob.sync(`${MD_DIR}/*.md?(x)`);
  const ordered = orderFiles(files, FILE_ORDER);

  const result = ordered.map(processFile);
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

const createCommunityToc = () => {
  const MD_DIR = path.join(__dirname, "../pages/community");
  const TARGET_FILE = path.join(__dirname, "../index_data/community_toc.json");

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
createLatestManualToc();
createV800ManualToc();
createReasonCompilerToc();
createReactToc();
createGenTypeToc();
createCommunityToc();
