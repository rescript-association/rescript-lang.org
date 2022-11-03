import matter from "gray-matter";
import glob from "glob";
import path from "path";
import fs from "fs";
import { URL } from 'url';

const pathname = new URL('.', import.meta.url).pathname;
const __dirname = process.platform !== 'win32' ? pathname : pathname.substring(1)

const processFile = filepath => {
  const raw = fs.readFileSync(filepath, "utf8");
  const { data } = matter(raw);

  const syntaxPath = path.resolve("./misc_docs/syntax");
  const relFilePath = path.relative(syntaxPath, filepath);
  const parsedPath = path.parse(relFilePath);

  if (data.id && data.keywords && data.name && data.summary && data.category) {
    return {
      file: parsedPath.name,
      id: data.id,
      keywords: data.keywords,
      name: data.name,
      summary: data.summary,
      category: data.category
    }
  }

  console.error("Metadata missing in " + parsedPath.name + ".mdx")
  return null;
};

const extractSyntax = async version => {
  const SYNTAX_MD_DIR = path.join(__dirname, "../misc_docs/syntax");
  const SYNTAX_INDEX_FILE = path.join(__dirname, "../index_data/syntax_index.json");
  const syntaxFiles = glob.sync(`${SYNTAX_MD_DIR}/*.md?(x)`);
  const syntaxIndex = syntaxFiles.map(processFile).filter(Boolean).sort((a, b) => a.name.localeCompare(b.name))
  fs.writeFileSync(SYNTAX_INDEX_FILE, JSON.stringify(syntaxIndex), "utf8");
};

extractSyntax()
