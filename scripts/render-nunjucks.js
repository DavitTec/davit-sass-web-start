import nunjucks from "nunjucks";
import fs from "fs";
import path from "path";

const inputDir = "src/html/pages";
const outputDir = "dist"; // Change to 'dist' for dev if needed

// Ensure outputDir exists
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Configure Nunjucks with base path for resolution (resolves includes relative to src/html)
nunjucks.configure("src/html", { autoescape: true });

const files = fs.readdirSync(inputDir).filter((file) => file.endsWith(".njk"));

files.forEach((file) => {
  const templatePath = path.join(inputDir, file);
  const outputFile = path.join(outputDir, file.replace(".njk", ".html"));

  try {
    const rendered = nunjucks.render(`pages/${file}`, {
      currentYear: new Date().getFullYear(),
    }); // Render relative to configure base
    fs.writeFileSync(outputFile, rendered);
    console.log(`Rendered ${file} to ${outputFile}`);
  } catch (err) {
    console.error(`Error rendering ${file}:`, err);
  }
});
