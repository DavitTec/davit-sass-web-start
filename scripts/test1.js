/* TEST Title */
/* VERSION: 0.0.2*/

import nunjucks from "nunjucks";
import fs from "fs";
import path from "path";
import metadata from "../data/metadata.json" with { type: "json" };

const inputDir = "src/njk";

const outputDir = "build";
const outputFile = path.join(outputDir, "test1.html");

// Ensure outputDir exists
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Ensure exists
if (fs.existsSync(outputFile) && fs.lstatSync(outputFile).isDirectory()) {
  throw new Error("test1.html is a directory, expected a file");
}

nunjucks.configure(inputDir, { autoescape: true });

// Give it a template in a string form and JS Object with info

let htmlStr = nunjucks.render("test1.njk", {
  metadata,
});

fs.writeFileSync(outputFile, htmlStr, (err) => {
  if (err) throw err;
  console.log('The file has been saved!');
});

console.log("wrote HTML")