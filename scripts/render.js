/* render.js
   VERSION: 0.1.0
*/

import fs from "fs";
import path from "path";
import njk from "nunjucks";
import dotenv from "dotenv";

// -----------------------------------------------------------------------------
// ENV
// -----------------------------------------------------------------------------
dotenv.config();

const ROOT_DIR = process.env.ROOT_DIR;
const NJK_DIR = process.env.NJK_DIR;
const DATA_DIR = process.env.DATA_DIR;
const DIST_DIR = process.env.DIST_DIR;

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

function getBooks(dir) {
  return fs
    .readdirSync(dir)
    .filter((f) => f.endsWith(".njk"))
    .map((f) => path.parse(f).name);
}

// -----------------------------------------------------------------------------
// Metadata
// -----------------------------------------------------------------------------
const packageMeta = loadJSON(path.join(DATA_DIR, "package.json"));

// -----------------------------------------------------------------------------
// Render
// -----------------------------------------------------------------------------
const books = getBooks(BOOKS_DIR);

for (const book of books) {
  const bookMeta = loadJSON(path.join(BOOK_DATA_DIR, `${book}.json`));

  const meta = {
    ...packageMeta,
    ...bookMeta,
  };

  const html = njk.render(`pages/${book}.njk`, { meta });

  const outputFile = path.join(DIST_DIR, `${book}.html`);
  fs.writeFileSync(outputFile, html);

  console.log(`✔ rendered book → ${outputFile}`);
}
