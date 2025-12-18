# DAVIT Sass Web Starter

[![GitHub version](https://badge.fury.io/gh/DavitTec%2Fdavit-sass-web-start.svg)](https://badge.fury.io/gh/DavitTec%2Fdavit-sass-web-start)  
[![License](https://img.shields.io/badge/license-DAVIT--1.0-blue.svg)](LICENSE)

## Description

A static HTML/CSS/JS boilerplate web design starter template using SASS for styling. This project serves as a foundation for building responsive, modular static websites with a focus on web development, design protocols, and features tailored for digital archiving and validation information technology (DAVIT Technologies). It includes tools for live development, production builds, and deployment to GitHub Pages.

The template emphasizes a clean structure, reusable Sass modules, a basic color palette, and scripts for staging/development (`dist/`) and production (`build/`). It's designed for learning and iterative development, with support for features like browser DevTools integration and changelog generation.

Current version: 0.0.4 (as of December 18, 2025).

## Features

- **Sass Styling**: Modular Sass setup with variables, functions, and mixins for easy customization (e.g., color palette with primary reds and secondary orange).
- **Live Development**: Hot-reloading server with Sass watcher and file syncing for rapid iteration.
- **Production Builds**: Minified CSS, asset optimization, and clean output to `./build/` for deployment.
- **Deployment to GitHub Pages**: Automated via `gh-pages` package—deploys only production artifacts, cleaning extraneous files.
- **Browser DevTools Support**: Custom middleware to serve `.well-known/appspecific/com.chrome.devtools.json` for automatic workspace mapping in Chrome/Brave.
- **Changelog Generation**: Integrated with git-cliff for automated changelogs based on commits.
- **VSCode Integration**: Pre-configured settings for linting, formatting, and tasks (e.g., live dev).
- **Responsive Design**: Basic responsive modules (e.g., `_responsive.sass`) for mobile/desktop.
- **Asset Management**: Separate folders for production assets and dev graphics/templates.
- **Security/SEO**: Sample `robots.txt`, favicons, and manifest for PWA basics.

## Installation

### Prerequisites

- Node.js (v20+ recommended)
- pnpm (v10+; installed via `npm install -g pnpm`)

### Steps

1. Clone the repository:

   ```
   git clone https://github.com/DavitTec/davit-sass-web-start.git
   cd davit-sass-web-start
   ```

2. Install dependencies:

   ```
   pnpm install
   ```

3. (Optional) Generate DevTools JSON for browser workspace mapping:
   ```
   ./scripts/setup-devtools-json.sh
   ```

## Usage

### Development Mode

- Builds to `./dist/` with live reloading.
- Command:
  ```
  pnpm dev
  ```
- Access: http://127.0.0.1:8081 (opens automatically).
- Features: Sass watcher compiles to `dist/css/`; non-Sass changes trigger incremental sync via `stage.sh`; live-server with custom middleware for DevTools.

### Build for Staging/Dev Preview

- Manual build to `./dist/`:
  ```
  pnpm build:dev
  ```
- Serve manually:
  ```
  pnpm serve
  ```

### Production Build & Deploy

- Builds minified assets to `./build/` (compressed Sass, copied HTML/JS/assets).
- Command (builds then deploys to `gh-pages` branch):
  ```
  pnpm run deploy
  ```
- Live site: https://davittec.github.io/davit-sass-web-start/
- Notes: Ensures clean deployment (only `./build/` contents); appends to CHANGELOG.md; skips if git is dirty.

### Cleaning

- Remove build/dev folders:
  ```
  pnpm clean
  ```

### Other Scripts

- Sass only (dev): `pnpm sass:dev` (watches `src/sass/` to `dist/css/`).
- Sass only (prod): `pnpm sass:prod` (compresses to `build/css/`).

## Directory Structure

```
.
├── CHANGELOG.md                  # Project changelog (auto-generated)
├── docs/                         # Documentation files
│   ├── asset-and-deployment-policy.md
│   └── design-system-policy.md
├── .env                          # Environment variables (if needed)
├── .github/                      # GitHub workflows
│   └── workflows/
│       └── deploy.yml            # CI/CD for deployment
├── .gitignore                    # Git ignores
├── manifest.json.example         # Example manifest for cleanup (optional)
├── .markdownlint.json            # Markdown lint config (ignores long lines/duplicates for changelogs)
├── middleware/                   # Custom middleware for live-server
│   ├── middleware.js             # Serves DevTools JSON
│   └── package.json              # Forces CommonJS for middleware
├── package.json                  # Node dependencies and scripts
├── pnpm-lock.yaml                # pnpm lockfile
├── pnpm-workspace.yaml           # pnpm workspace config (if multi-package)
├── README.md                     # This file
├── requirements.yaml             # Additional requirements (e.g., for tools)
├── scripts/                      # Build/stage scripts
│   ├── build.sh                  # Production build
│   ├── setup-devtools-json.sh    # Generates DevTools JSON
│   └── stage.sh                  # Dev/staging build (incremental)
├── src/                          # Source files
│   ├── assets/                   # Production assets
│   │   ├── favicon/              # Favicons and manifests
│   │   ├── img/                  # Images (models, projects)
│   │   └── logo/                 # Logos
│   ├── assets-dev/               # Dev-only assets
│   │   └── images/               # Subfolders for favicons, icons, etc.
│   ├── fonts/                    # Web fonts (e.g., Source Sans)
│   ├── graphics-dev/             # Dev graphics (e.g., XCF templates)
│   │   └── img/
│   ├── html/                     # HTML pages
│   │   ├── about.html
│   │   ├── contact.html
│   │   ├── example-js.html
│   │   ├── index2.html
│   │   ├── index.html
│   │   └── projects.html
│   ├── js/                       # JavaScript
│   │   └── main.js
│   ├── sass/                     # Sass sources
│   │   ├── main.sass             # Main entry point
│   │   └── modules/              # Sass modules
│   │       ├── _about.sass
│   │       ├── _config.sass      # Variables, functions
│   │       ├── _contact.sass
│   │       ├── _home.sass
│   │       ├── _menu.sass
│   │       ├── _projects.sass
│   │       └── _responsive.sass
│   └── .well-known/              # DevTools config
│       └── appspecific/
│           └── com.chrome.devtools.json
├── tests/                        # Tests (empty/placeholder)
├── .vscode/                      # VSCode config
│   ├── extensions.json           # Recommended extensions
│   ├── launch.json               # Debug configs
│   ├── requirements.sha256       # Hash for requirements
│   └── settings.json             # Editor settings (e.g., linting)
└── vscode.sh                     # VSCode setup script
```

## Contributing

- Work on `main` or feature branches.
- Use `pnpm dev` for local development.
- Commit changes, bump version in `package.json`, update CHANGELOG.md.
- Deploy via `pnpm run deploy`.
- Follow design policies in `docs/` for assets and system.

See [CHANGELOG.md](CHANGELOG.md) for details on changes.

## License

DAVIT-1.0 (see [LICENSE](LICENSE) for details).
