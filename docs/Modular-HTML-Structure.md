# Modular HTML Structure



## Phase 1

### Progress Version v0.0.4
The basic Sass modules, color palette, and prod build/deploy working is a solid foundation, especially as a learning process. The site at https://davittec.github.io/davit-sass-web-start/ looks clean and functional as a starter. Now, modularizing will make it more maintainable, scalable, and easier to refine styles/assets later. We'll focus on breaking pages into reusable components (e.g., TopNav, Nav, MenuNav, Footer), reorganizing Sass with logical structure and namespacing, and addressing potential NAV headaches upfront.

Since this is a static site, we'll keep it simple with pure HTML/Sass/Node, but I'll suggest lightweight tools (e.g., for templating) to avoid copy-paste repetition in HTML. The goal: Mechanics first (structure, reuse), then styles/layout.

### Next Steps: Implementation Plan

1. **Setup Templating**: Install Nunjucks, update scripts, create partials/components from existing HTML.
2. **Restructure Sass**: Move files to new folders, update `@use` with namespaces in `main.sass`.
3. **Test Locally**: `pnpm dev`—ensure no broken styles/links.
4. **Refine Mechanics**: Add JS for MenuNav toggle if needed (e.g., in `js/main.js`).
5. **Deploy**: Bump version, `pnpm run deploy`, check live site.
6. **Assets/Styles**: Once mechanics are solid, optimize images (e.g., compress with tools like ImageOptim) and refine layouts.

### Installation nunjucks

#### Getting Started

When Using Node...

```text
pnpm install -D nunjucks
```

Once installed, simply use `require('nunjucks')` to load it.

Nunjucks supports all modern browsers and any version of Node.js [currently supported by the Node.js Foundation](https://github.com/nodejs/Release#release-schedule1). This includes the most recent version and all versions still in maintenance.

**When in the Browser...**

Grab [nunjucks.js](https://mozilla.github.io/nunjucks/files/nunjucks.js) ([min](https://mozilla.github.io/nunjucks/files/nunjucks.min.js)) for the full library, or [nunjucks-slim.js](https://mozilla.github.io/nunjucks/files/nunjucks-slim.js) ([min](https://mozilla.github.io/nunjucks/files/nunjucks-slim.min.js)) for the slim version which only works with precompiled templates.

### Which file should you use?

- Use **nunjucks.js** to dynamically load templates, auto-reload templates when they are changed, and use precompiled templates. Comes with the full compiler so is larger (20K min/gzipped). Use this to get started, and use in production if you don't mind a larger file size.
- Use **nunjucks-slim.js** to load precompiled templates and use them. Doesn't come with the full compiler so it's smaller (8K min/gzipped), but *only* works with precompiled templates. Typically used for production, and possibly development if you use the [grunt](https://github.com/jlongster/grunt-nunjucks) or [gulp](https://github.com/sindresorhus/gulp-nunjucks) tasks to automatically recompile templates.

Simply include nunjucks with a `script` tag on the page:

```html
<script src="nunjucks.js"></script>
```

or load it as an AMD module:

```js
define(['nunjucks'], function(nunjucks) {
});
```

> Whatever you do, make sure to precompile your templates in production! There are [grunt](https://github.com/jlongster/grunt-nunjucks) and [gulp](https://github.com/sindresorhus/gulp-nunjucks) tasks to help with that. Read more about optimal client-side configurations in [Browser Usage](https://mozilla.github.io/nunjucks/api.html#browser-usage).

## Usage

This is the simplest way to use nunjucks. First, set any configuration flags (i.e. autoescaping) and then render a string:

```js
nunjucks.configure({ autoescape: true });
nunjucks.renderString('Hello {{ username }}', { username: 'James' });
```

You usually won't use `renderString`, instead you should write templates in individual files and use `render`. That way you can inherit and include templates. In this case, you need to tell nunjucks where these files live with the first argument of `configure`:

```js
nunjucks.configure('views', { autoescape: true });
nunjucks.render('index.html', { foo: 'bar' });
```

In node, `'views'` would be a path relative to the current working directory. In the browser, it would be a relative URL, and you probably want it to be absolute, like `'/views'`.

Using express? Simply pass your express app into `configure`:

```js
var app = express();

nunjucks.configure('views', {
    autoescape: true,
    express: app
});

app.get('/', function(req, res) {
    res.render('index.html');
});
```

The above API works in node and in the browser (express is only in node, obviously). In node, nunjucks loads templates from the filesystem by default, and in the browser loads them over HTTP.

If you [precompiled](https://mozilla.github.io/nunjucks/api.html#precompiling) your templates in the browser, they will automatically be picked up by the system and nothing more has to be changed. This makes it easy to use the same code in development and production, while using precompiled templates in production.

#### More Information

https://mozilla.github.io/nunjucks/getting-started.html

## Phase 1

### Step 1: Modular HTML Structure

To break pages into modules like TopNav, Nav, MenuNav, Footer (with sub-parts like FooterNav, BottomFooter), use **HTML partials**. Currently, your pages (e.g., `index.html`, `projects.html`) likely duplicate headers/footers—modularizing fixes that.

#### Recommended Approach: Add Templating for Reusability

- Pure HTML copy-paste works but leads to maintenance hell. Instead, integrate a simple templating engine like Nunjucks (lightweight, Node-based) to include partials (e.g., `{% include "partials/header.html" %}`).
  - **Why?** Allows reusable components without a full framework. Your build scripts can compile templates to static HTML.
  - Install: `pnpm add -D nunjucks nunjucks-cli`
  - Update `build.sh` and `stage.sh` to render templates (example below).

## 

### Progress Version v0.0.4
The basic Sass modules, color palette, and prod build/deploy working is a solid foundation, especially as a learning process. The site at https://davittec.github.io/davit-sass-web-start/ looks clean and functional as a starter. Now, modularizing will make it more maintainable, scalable, and easier to refine styles/assets later. We'll focus on breaking pages into reusable components (e.g., TopNav, Nav, MenuNav, Footer), reorganizing Sass with logical structure and namespacing, and addressing potential NAV headaches upfront.

Since this is a static site, we'll keep it simple with pure HTML/Sass/Node, using Nunjucks for templating to avoid copy-paste repetition in HTML. The goal: Mechanics first (structure, reuse), then styles/layout.

### Nunjucks Templating Setup
To enable modular HTML, we've integrated Nunjucks with a custom Node.js render script (avoiding CLI path issues). This assembles pages from partials/macros during builds.

#### Installation

```bash
pnpm add -D nunjucks
```


#### Render Script (`scripts/render-nunjucks.js`)
This ESM script renders all `.njk` templates in `src/html/pages/` to plain HTML in `build/` (or `dist/` for dev):
```javascript
import nunjucks from 'nunjucks';
import fs from 'fs';
import path from 'path';

const inputDir = 'src/html/pages';
const outputDir = 'build';  // Change to 'dist' for dev

nunjucks.configure('src/html', { autoescape: true });

const files = fs.readdirSync(inputDir).filter(file => file.endsWith('.njk'));

files.forEach(file => {
  const templatePath = path.join(inputDir, file);
  const outputFile = path.join(outputDir, file.replace('.njk', '.html'));

  try {
    const context = { currentYear: new Date().getFullYear() };  // Example dynamic context
    const rendered = nunjucks.render(`pages/${file}`, context);
    fs.writeFileSync(outputFile, rendered);
    console.log(`Rendered ${file} to ${outputFile}`);
  } catch (err) {
    console.error(`Error rendering ${file}:`, err);
  }
});

```
Add to 

- `package.json`  

  ```json
  scripts: 
    "render": "node scripts/render-nunjucks.js"
  ```

- Integrate into `build.sh` (after asset copies):

  ```bash
  echo "🛠 Rendering Nunjucks templates..."
  #TODO
  ```

- Render

  ```bash
  pnpm run render
  ```

#### Folder Structure Suggestion

Organise `src/html/` into modular parts:

```bash
src/html/
├── pages/          # Full pages (Nunjucks templates)
│   ├── index.njk
│   └── projects.njk
├── partials/       # Reusable modules (static includes)
│   ├── header.njk  # TopNav + Nav + MenuNav
│   ├── footer.njk  # FooterNav + BottomFooter + FooterMenu
│   └── macros.njk  # Macros for parameterized components (e.g., section, button)
└── components/     # Smaller bits (optional, embed in partials)
    ├── button.njk
    └── card.njk
```

**Example Usage**

- **Example: index.njk**: 

  pages/index.njk (assembles modules):

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>DAVIT Technologies</title>
  <link rel="stylesheet" href="css/main.css">
</head>
<body>
  {% include "partials/header.njk" %} <!-- TopNav, Nav, MenuNav -->

  <main>
    <section class="hero">
      <!-- Hero content -->
      Hero content here.
    </section>

    {% from "partials/macros.njk" import section, button %}
    {{ section("about", "Your about text") }} <!-- Reusable section -->
    {{ button("Learn More", "/about") }}
  </main>

  {% include "partials/footer.njk" %} <!-- FooterNav, BottomFooter, FooterMenu -->
</body>
</html>
```

- **Example: partials/header.njk** (modular NAV):

  ```html
  <header class="top-nav">
    <!-- Logo, TopNav items -->
    <nav class="main-nav">
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/projects">Projects</a></li>
      </ul>
    </nav>
    <div class="menu-nav">
      <!-- Hamburger or mobile menu -->
    </div>
  </header>
  ```

- **Example: partials/footer.njk**:

  ```html
  <footer class="main-footer">
    <nav class="footer-nav">
      <!-- Footer links -->
    </nav>
    <div class="bottom-footer">
      <p>&copy; 2008-2025 DAVIT Technologies</p>
      <nav class="footer-menu">
        <!-- Social/privacy links -->
      </nav>
    </div>
  </footer>
  ```

#### Integrate into Builds

- Update `build.sh` (prod) and `stage.sh` (dev) to render Nunjucks:
  Add after HTML copy:

  ```bash
  echo "🛠 Rendering Nunjucks templates..."
  npx nunjucks-cli src/html/pages/*.njk -p src/html/ -o build/  # Renders to build/*.html
  ```

  - For dev: Change `-o build/` to `-o dist/`.
  - This compiles `.njk` templates to plain `.html` in output dirs.

- **NAV Headaches to Watch**: 

  - **Responsive/Mobile**: MenuNav (e.g., hamburger) might overlap with TopNav—use Sass media queries and JS for toggle (in `js/main.js`).
  - **Accessibility**: Add ARIA roles (e.g., `role="navigation"`) and keyboard nav.
  - **Duplication**: With partials, changes to header/footer propagate everywhere—no manual sync.
  - **Sticky/Fixed**: If TopNav sticks, use `position: sticky;` in Sass—test cross-browser.

If Nunjucks feels overkill, stick to copy-paste for now, but templating saves time long-term.

Run

```bash

pnpm run render
```

 to generate `build/index.html`.



## Step 2: Modifications for Modular HTML Updates

Modified dev Branch to get to v0.0.4 website as per modular

fix: modified build:dev with dev.sh script in package.json

- add dev.sh: script to build:dev in /dist with render
- built: modular to replicate current v0.0.4 site in dist/
-  various njk Pages, and Partials 
- add header to main.sass for 0.0.4

**Setup (v0.0.4 on dev/modular-HTML-structure1),**

These build on the existing Nunjucks structure: 

- Use macros for loops/params where possible, partials for static reuse. 
- All changes are tested conceptually—run pnpm run render after updating to generate build/*.html.

Commit these as a new commit: 

```bash
git add src/html/* && git commit -m "feat: add project loop, extract social-icons component, make title dynamic".
```

#### 1. Modify pages/projects.njk for Looping Through Projects (1-6)

This is possible with Nunjucks's {% for %} loop. We'll pass an array of project data (e.g., title, image, description) via context in the render script. For simplicity, hardcode the array in the script (later, load from JSON for dev/stage separation).













## Step 3: Reorganize Sass with Better Logic and Namespacing

Your current Sass is basic (`main.sass` importing modules like `_config.sass`, `_menu.sass`). Adopt the **7-1 Pattern** (common for Sass): 7 folders for categories, 1 main file. This groups logically (e.g., components separate from layouts) and uses `@use` with namespaces to avoid conflicts.

#### New Sass Folder Structure

```
src/sass/
├── abstracts/      # Tools/vars (no CSS output)
│   ├── _variables.sass  # Colors, fonts ($color-primary, etc.)
│   ├── _functions.sass  # set-text-color(), etc.
│   └── _mixins.sass     # transition-ease(), etc.
├── base/           # Global resets/base styles
│   ├── _reset.sass      # Normalize/resets
│   ├── _typography.sass # Fonts, headings
│   └── _base.sass       # Body, html defaults
├── components/     # Reusable UI bits (match HTML components)
│   ├── _button.sass
│   └── _card.sass
├── layout/         # Structural (grids, sections)
│   ├── _header.sass     # TopNav, Nav, MenuNav
│   ├── _footer.sass     # FooterNav, BottomFooter
│   ├── _grid.sass       # Containers/sections
│   └── _hero.sass
├── pages/          # Page-specific (overrides)
│   ├── _home.sass       # Index tweaks
│   └── _projects.sass
├── themes/         # If multi-themes (optional)
│   └── _default.sass
├── vendors/        # Third-party (optional)
│   └── _normalize.sass
└── main.sass       # Imports all with @use
```

## **Namespacing Best Practices**:

- Use `@use 'path/to/module' as mod;` for short namespaces (e.g., `mod.$color-primary`).

- In `main.sass` (entry point):

  ```sass
  @use 'abstracts/variables' as vars
  @use 'abstracts/mixins' as mix
  @use 'base/reset'
  @use 'base/typography'
  @use 'layout/header' as head  // Namespace for header-specific
  @use 'layout/footer' as foot
  @use 'components/button' as btn
  
  // Usage example
  .top-nav
    background: vars.$color-primary
    @include mix.transition-ease
  
  // Page-specific at bottom
  @use 'pages/home'
  ```

- Avoid `@use ... as *;`—prevents conflicts.

- Migrate existing: Move colors to `_variables.sass`, functions to `_functions.sass`, etc. Update imports accordingly.

- **Compilation**: Your `sass:dev` and `sass:prod` already handle directory compilation—outputs `dist/css/main.css` (or `build/css/main.css` minified). If adding more entries (e.g., `projects.sass`), compile them too.

## Addressing NAV in Sass

- Group header/footer in `layout/`—use BEM-like selectors (e.g., `.header__top-nav`, `.footer__bottom`).
- Potential Issues/Fixes:
  - **Overlaps/Conflicts**: Namespaces prevent var/mixin clashes (e.g., `head.$nav-color` vs `foot.$nav-color`).
  - **Media Queries**: Place in a shared `_media.sass` in `abstracts/`, imported where needed.
  - **Variables**: Centralize in `_variables.sass`—easy overrides.
  - Test: Run `pnpm dev`, tweak header/footer Sass—should hot-reload without breaking.

If NAV gives specific errors, share code snippets/logs. This structure scales well for your IT/archiving focus—e.g., add components for "archive previews" later. Let me know where to dive deeper!

## Next Steps: Implementation Plan

Expand Partials/Macros: 

- Add full logic to header/footer (e.g., mobile toggle), more macros for components.
- Add JS for Interactivity: E.g., hamburger menu toggle in js/main.js.
- Restructure Sass: Move to 7-1 pattern, update @use with namespaces.
- Test Locally: pnpm dev—ensure rendering/hot-reload works (add .njk watcher if needed).
- Deploy: Bump version, pnpm run deploy, check live site.
- Assets/Styles: Optimize images, refine layouts.

If NAV gives specific errors, share code snippets/logs. This structure scales well for your IT/archiving focus—e.g., add components for "archive previews" later. Let me know where to dive deeper!

This updated doc removes CLI references, adds the script details, and includes the working example. Commit as suggested, then proceed with expansion on the branch. If ready for staging after this, we can plan it next. Keep the momentum!



