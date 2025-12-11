# Design System & Naming Protocol Policy

## 1. Purpose

This document defines the **official, enforceable protocol** for naming, grouping, structuring, and documenting all design‑system assets in this project, including Sass architecture, theme, colour palettes, component names, and developer conventions. It eliminates ambiguity, ensures longevity, and prevents naming inconsistencies across the team.

It is written for **professional teams**, future maintainers, and automated tooling.

---

## 2. Language & Spelling Policy (en‑GB)

All naming—folders, variables, classes, functions, tokens, themes—**must follow British English**.

### Required British spellings

- `colour` (NOT `color`)
- `grey` (NOT `gray`)
- `organisation` (NOT `organization`)
- `centre` (NOT `center`)

### Reason

Avoid ambiguity and enforce cultural consistency. Using one clear language dialect avoids mixed spelling, which becomes disastrous in large codebases (e.g. `colors/`, `colours/`, `color-utils/`).

---

## 3. Naming Protocol

A naming protocol defines **how things are named**, regardless of folder placement.

We divide the naming protocol into:

1. **Groups (collections of things)**
2. **Objects (an individual thing)**
3. **Attributes (variant, modifier, theme)**
4. **Grammar (punctuation rules)**

---

### 3.1 Groups (collections)

Group names follow **plural nouns**.

Examples:

- `colours/`
- `themes/`
- `components/`
- `utilities/`

Plural groups indicate a _set_.

> [!IMPORTANT]
>
> **Rule**: A folder representing a set MUST use plural form.

---

### 3.2 Objects (single items)

Objects use **singular nouns**.

Examples:

- `button`
- `card`
- `palette`
- `theme`

> [!IMPORTANT]
>
> **Rule**: A file representing one object MUST use singular form.

---

### 3.3 Abbreviations

Abbreviations are allowed **only if included in the glossary**.

Not permitted:

- `c-`, `col-`, `clr-`, `colr-`, etc.

Permitted (if defined):

- `ui-` (user interface)
- `ds-` (design system)

> [!IMPORTANT]
>
> **Rule**: No abbreviation may be used unless it is documented in the glossary.

---

### 3.4 Grammar (punctuation rules)

#### Prefixes

Prefixes are used to define _namespace_.

Examples:

- `ds-` → design-system global class
- `c-` → component
- `t-` → theme

#### Dashes

Use `-` for compound words.

```sass
.c-button-primary
.ds-spacing-large
```

#### Double dashes

Used for **variant modifiers**, inspired by BEM but not restricted to BEM.

```sass
.c-button--large
.c-card--type1
```

#### Underscores

Underscores are **never used in CSS classes**.
They are reserved for Sass partial filenames:

```sass
_button.sass
_colour-palette.sass
```

#### Dots

Dots are used **only in Sass namespaces**, not filenames:

```sass
@use "themes/corporate" as corp
corp.$palette
```

---

## 4. Folder Architecture Protocol

The system must avoid both:

- meaningless abstraction (`abstracts`, `tokens`)
- deep nested hierarchies (`a/b/c/d/e/f`)

The allowed top‑level folders are:

```sass
sass/
  colours/
  themes/
  components/
  utilities/
  layouts/
  base/
  main.sass
```

### Why this structure?

- **Names are self‑explaining**
- Zero duplication (`theme` vs `themes`)
- No ambiguous metaphors (`tokens`, `abstracts`)
- Works for small & large systems

---

## 5. Theming Protocol

A theme represents:

- a colour palette
- spacing + typography overrides
- component styling overrides

### 5.1 Theme Naming

Theme names must describe _context_, not sentiment.

**Good**:

- `corporate`
- `light`
- `dark`
- `brand-a`

**Bad**:

- `clean`
- `modern`
- `default` (ambiguous)

### 5.2 Theme Structure

Each theme must expose:

- `$colours`
- `$surface`
- `$semantic`
- optional `$component-overrides`

---

## 6. Colour Palette Protocol

### 6.1 Colour Scale

All palettes use the **10–110 scale**.

Example:

```sass
$blue: (
  10: #ebf6ff,
  20: #d4ecff,
  30: #addcff,
  ...
  110: #021b33,
)
```

### 6.2 Required Palette Structure

Every theme must provide **primary, secondary, tertiary**.

```sass
$colours: (
  primary: $blue,
  secondary: $green,
  tertiary: $purple,
)
```

#### Rationale

> A single primary colour rarely works across all mediums, accessibility settings, or corporate branding contexts.

---

## 7. Component Naming Protocol

Components follow a consistent naming:

```sass
.c-[object]
.c-[object]--[variant]
.c-[object]--[state]
```

Examples:

```sass
.c-button
.c-button--type1
.c-button--disabled
.c-card--elevated
```

> [!IMPORTANT]
>
> **Rule**: Themes do NOT appear in component classes.

Theme overrides instead:

```sass
.t-corporate .c-button { ... }
```

---

## 8. Data Dictionary

This dictionary defines every permitted term in the system.

| Term      | Definition                            | Allowed Forms         |
| --------- | ------------------------------------- | --------------------- |
| colour    | hue/light/dark attributes in palettes | colour, colours       |
| palette   | set of colours 10–110 range           | palette               |
| theme     | collection of palettes + overrides    | theme, themes         |
| component | UI element                            | component, components |
| variant   | modification of a component           | variant, variants     |
| layout    | structural rules                      | layout, layouts       |
| utility   | reusable Sass tools                   | utility, utilities    |

This table **must be updated** when new naming appears.

---

## 9. Glossary of Approved Abbreviations

| Abbreviation | Meaning        | Allowed In |
| ------------ | -------------- | ---------- |
| ds           | design system  | prefixes   |
| ui           | user interface | prefixes   |
| c            | component      | prefixes   |
| t            | theme          | prefixes   |

Any abbreviation not listed here is **forbidden**.

---

## 10. Allowed Punctuation Summary

| Symbol | Purpose            | Allowed In         |
| ------ | ------------------ | ------------------ |
| `-`    | compound names     | classes, variables |
| `--`   | variant modifiers  | classes            |
| `_`    | Sass partial names | filenames only     |
| `.`    | namespaces         | Sass `@use` only   |
| `/`    | folder hierarchy   | filesystem         |

---

## 11. Spell‑Checking Requirements

All code must be validated using an en‑GB spell checker.

This includes:

- variable names
- folder names
- documentation
- theme names

Tools allowed:

- VSCode Code Spell Checker (en‑GB)
- internal CI spelling script

---

## 12. Final Principles Summary

1. **One language dialect** (en‑GB)
2. Singular for objects, plural for groups
3. No abbreviations unless documented
4. Themes do not alter class names
5. Colour scales are numeric (10–110)
6. A theme is a wrapper, not a component
7. Components use clear namespaces (`c-`, `ds-`, `t-`)
8. Shallow hierarchy always preferred
9. No duplicated folder names
10. Data dictionary governs future decisions

---

## 13. Change Control

Any update to this protocol requires:

- justification
- team approval
- update to glossary & data dictionary
- version bump in system documentation

---

## References

---

Version: 0.1.0
