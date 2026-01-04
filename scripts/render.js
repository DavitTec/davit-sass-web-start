/* render.js
   VERSION: 0.1.1
*/

import fs from "fs";
import path from "path";
import njk from "nunjucks";
import dotenv from "dotenv";
import prettier from "prettier";

// -----------------------------------------------------------------------------
// ENV
// -----------------------------------------------------------------------------
dotenv.config();

const ROOT_DIR = process.env.ROOT_DIR; // 👈 keep for future root level changes
const NJK_DIR = process.env.NJK_DIR; // 👈 all nunjucks sources
const DATA_DIR = process.env.DATA_DIR; // 👈 content related metadata sources
const DIST_DIR = process.env.DIST_DIR; // 👈 build destination and mode:DEV|STAGE|BUILD
const MODE = process.env.MODE; // 👈 build destination and mode:DEV|STAGE|BUILD
const VERSION = process.env.VERSION; // 👈 Construction version

// Books live here
const BOOKS_DIR = path.join(NJK_DIR, "pages");
const BOOK_DATA_DIR = path.join(DATA_DIR, "pages");

// -----------------------------------------------------------------------------
// Setup
// -----------------------------------------------------------------------------
if (!fs.existsSync(DIST_DIR)) {
  fs.mkdirSync(DIST_DIR, { recursive: true });
}

njk.configure(NJK_DIR, {
  autoescape: true,
  noCache: true,
});

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------
function loadJSON(filePath) {
  if (!fs.existsSync(filePath)) return {};
  return JSON.parse(fs.readFileSync(filePath, "utf-8"));
}

function addBuildComments(html, meta) {
  const banner = `
<!--
  BUILD VERSION: ${VERSION ?? "unknown"}
  MODE: ${MODE}
  PAGE: ${meta.title ?? "untitled"}
  GENERATED: ${new Date().toISOString()}
-->
`;

  return banner + html;
}

function getBooks(dir) {
  return fs
    .readdirSync(dir)
    .filter((f) => f.endsWith(".njk"))
    .map((f) => path.parse(f).name);
}

async function formatHtml(html) {
  return prettier.format(html, {
    parser: "html",
    tabWidth: 2,
    useTabs: false,
  });
}

// -----------------------------------------------------------------------------
// Metadata
// -----------------------------------------------------------------------------
const packageMeta = loadJSON(path.join(DATA_DIR, "package.json"));

// -----------------------------------------------------------------------------
// Render
// -----------------------------------------------------------------------------
async function renderAll() {
  const books = getBooks(BOOKS_DIR);

  for (const book of books) {
    const bookMeta = loadJSON(path.join(BOOK_DATA_DIR, `${book}.json`));

    const meta = {
      ...packageMeta,
      ...bookMeta,
    };

    let html = njk.render(`pages/${book}.njk`, { meta });

    const outputFile = path.join(DIST_DIR, `${book}.html`);

    html = addBuildComments(html, meta);
    html = await formatHtml(html);

    fs.writeFileSync(outputFile, html);

    console.log(`✔ rendered and prettied module → ${outputFile}`);
  }
}

renderAll().catch((err) => {
  console.error("❌ Render failed:", err);
  process.exit(1);
});
