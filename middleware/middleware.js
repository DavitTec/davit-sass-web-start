const fs = require("fs");
const path = require("path");
module.exports = function (req, res, next) {
  if (req.url === "/.well-known/appspecific/com.chrome.devtools.json") {
    const filePath = path.join(
      __dirname,
      "..", // Go up one level to project root
      "dist",
      ".well-known",
      "appspecific",
      "com.chrome.devtools.json"
    );
    fs.readFile(filePath, (err, data) => {
      if (err) {
        console.error("Error reading DevTools JSON:", err);
        return next();
      }
      res.setHeader("Content-Type", "application/json");
      res.end(data);
    });
  } else {
    next();
  }
};
