/* TEST Title */
/* VERSION: 0.0.4 */

import nunjucks from "nunjucks";
import fs from "fs";
import path from "path";

// 🔑 SINGLE SOURCE OF TRUTH
const projectRoot = process.cwd();

const inputDir = path.join(projectRoot, "src", "njk");
const dataDir = path.join(projectRoot, "data");
const outputDir = path.join(projectRoot, "build");

const pageName = "test2";
const outputFile = path.join(outputDir, `${pageName}.html`);

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

const meta = loadMetadata(pageName);

const html = nunjucks.render(`${pageName}.njk`, { meta });

fs.writeFileSync(outputFile, html);

console.log(`wrote HTML → ${outputFile}`);
