/* TEST Title */
/* VERSION: 0.0.1*/

import nunjucks from "nunjucks";

nunjucks.configure("src/html", { autoescape: true });

// Give it a template in a string form and JS Object with info

let titleStr = nunjucks.renderString("Welcome to {{ title }}", {
  title: "Davit Portfolio",
});

console.log(titleStr);
