# Modular Project Instructions

## Project Overview

This project, titled **"davit-sass-web-start",** serves as a structured framework for developing a modular static HTML website using Sass for styling. It builds on the existing "davit-sass-web-start" repository, focusing on phased development to enhance modularity, maintainability, and scalability. The project emphasizes clean code practices, version control, and separation of concerns across chats and phases.

The live site is available at: https://davittec.github.io/davit-sass-web-start/  
The public GitHub repository is at: https://github.com/DavitTec/davit-sass-web-start

Current tag: v0.0.4 (as of December 18, 2025).

## Basic Rules	

- **Language and Locale**: All documentation, comments, and content must use British English (en-GB). For example, use "colour" instead of "color", "organise" instead of "organize".
- **Code Formatting**: Use 2 spaces for indentation (no tabs). Ensure consistent line endings (LF) and no trailing whitespace. Format code with tools like Prettier where applicable.
- **Version Control**: Adhere to [Semantic Versioning (SemVer) 2.0.0.][semver] Increment versions as follows:
  - Patch (0.0.x): Bug fixes or minor changes.
  - Minor (0.x.0): New features or enhancements without breaking changes.
  - Major (x.0.0): Breaking changes or major refactors.
  - Use git branches for features (e.g., "feat/modular-html"), and merge via pull requests. Tag releases (e.g., `git tag v0.0.5`).
- **Development Environments**:
  - **Development**: Use `pnpm dev` for local building to `./dist/`. Focus on generic, fictional data for testing layouts/styles.
  - **Staging**: (To be implemented) Use real-world-like data; no new styles/layouts unless predefined.
  - **Production**: Deploy via `pnpm run deploy` to GitHub Pages; default to generic content, optional flag for staged data.
- **File Structure and Naming**: Follow the existing directory tree. Use kebab-case for file names (e.g., "header.njk"). Partials in `src/njk/partials/`, macros in `partials/macros.njk`, components in `components/`.
- **Templating**: Use **[Nunjucks][Nunjucks]** for modular HTML. Render via `scripts/render.js` (ESM script). Prefer macros for parameterized components, includes for static ones.
- **Sass Practices**: Use the 7-1 pattern. Employ `@use` with namespaces (e.g., `@use 'abstracts/variables' as vars`). Avoid global imports.
- **Testing and Deployment**: Test locally with `pnpm dev`. Commit changes before deploy. Ensure clean builds (no dev artifacts on `gh-pages`).
- **Documentation**: Update `docs/Modular-HTML-Structure.md` (or similar) per phase. Include git logs, progress notes, and rules adherence.
- **Etc.**: Prioritize accessibility (ARIA roles), responsiveness (media queries), and performance (minified assets). No external dependencies without review. Keep commits atomic and descriptive.

## Phase Guidelines

- Each phase (e.g., stage1: Basic modular HTML) should be on a dedicated branch (e.g., "dev/modular-HTML-structure1").
- Commit logical stops (working states) before expanding complexity.
- After a phase, merge to `main`, bump version, deploy, and document in [CHANGELOG.md](../CHANGELOG.md).

Follow these for consistent, efficient development!

## References

1. [SemVer]: https://semver.org/ "Semantic Versioning 2.0.0"
2. [Nunjucks]: https://mozilla.github.io/nunjucks/getting-started.html	"Getting Started with Nunjucks"
3. add ref here

   

   

   

