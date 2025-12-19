/* TEST 3 Title */
/* VERSION: 0.0.4 */

import nunjucks from "nunjucks";
import fs from "fs";
import path from "path";
import prettier from "prettier";

// 🔑 SINGLE SOURCE OF TRUTH
const projectRoot = process.cwd();

const inputDir = path.join(projectRoot, "src", "njk");
const dataDir = path.join(projectRoot, "data");
const outputDir = path.join(projectRoot, "build");

const pageName = "test2";
const outputFile = path.join(outputDir, `${pageName}.html`);

function addBuildComments(html, meta) {
  const banner = `
<!--
  BUILD VERSION: 0.0.4
  PAGE: ${meta.title ?? "untitled"}
  GENERATED: ${new Date().toISOString()}
-->
`;

  return banner + html;
}

function getPages(dir) {
  const pagesDir = path.join(dir, "pages");

  return fs
    .readdirSync(pagesDir)
    .filter((file) => file.endsWith(".njk"))
    .map((file) => path.parse(file).name);
}

// Load global metadata (runtime-safe, not import-time fragile)
const globalMeta = JSON.parse(
  fs.readFileSync(path.join(dataDir, "metadata", "global.json"), "utf-8")
);

// Ensure outputDir exists
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Safety check
if (fs.existsSync(outputFile) && fs.lstatSync(outputFile).isDirectory()) {
  throw new Error(`${outputFile} is a directory, expected a file`);
}

nunjucks.configure(inputDir, { autoescape: true });

async function formatHtml(html) {
  return prettier.format(html, {
    parser: "html",
    tabWidth: 2,
    useTabs: false,
  });
}

function loadMetadata(pageName) {
  const pageMetaPath = path.join(
    dataDir,
    "metadata",
    "pages",
    `${pageName}.json`
  );

  let pageMeta = {};
  if (fs.existsSync(pageMetaPath)) {
    pageMeta = JSON.parse(fs.readFileSync(pageMetaPath, "utf-8"));
  }

  return {
    ...globalMeta,
    ...pageMeta,
  };
}

const pages = getPages(inputDir);

for (const pageName of pages) {
  const meta = loadMetadata(pageName);

  let html = nunjucks.render(`pages/${pageName}.njk`, { meta });

  html = addBuildComments(html, meta); // add build comments
  html = await formatHtml(html); // 👈 await // prettier pages

  const outputFile = path.join(outputDir, `${pageName}.html`);
  fs.writeFileSync(outputFile, html);

  console.log(`wrote HTML → ${outputFile}`);
}
