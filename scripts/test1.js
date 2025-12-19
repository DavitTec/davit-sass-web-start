/* TEST Title */
/* VERSION: 0.0.2*/

import nunjucks from "nunjucks";
import fs from "fs";
import path from "path";
import metadata from "../tests/data/metadata.json" with { type: "json" };

const inputDir = "tests/test1";

const outputDir = "tests/test1/build";
const outputFile = path.join(outputDir, "index.html");


// Ensure outputDir exists
if (fs.existsSync(outputFile) && fs.lstatSync(outputFile).isDirectory()) {
  throw new Error("index.html is a directory, expected a file");
}

nunjucks.configure(inputDir, { autoescape: true });

// Give it a template in a string form and JS Object with info

let htmlStr = nunjucks.render("index.njk", {
  metadata,
});

fs.writeFileSync(outputFile, htmlStr, (err) => {
  if (err) throw err;
  console.log('The file has been saved!');
});

console.log("wrote HTML")