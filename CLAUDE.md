# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal academic website for Daniel Tregeagle (https://www.danieltregeagle.com), built with Hugo +
the PaperMod theme and deployed to GitHub Pages. There is no application code, no test suite, and no
linter — the work here is content editing plus Hugo configuration.

## Content pipeline (the key thing to understand)

Pages are **not** authored in Markdown. `content-org/site.org` is the single hand-edited source; each
top-level subtree with an `:EXPORT_FILE_NAME:` property is exported by **ox-hugo** to the
corresponding `content/*.md`:

| org subtree | generated file |
|---|---|
| `Daniel Tregeagle, Ph.D.` (`_index`) | `content/_index.md` |
| `CV` / `Extension` / `Research` / `Teaching` | `content/cv.md`, `extension.md`, `research.md`, `teaching.md` |

Consequences that bite:

- **Never edit `content/*.md` directly** — the next export overwrites it.
- The generated `content/*.md` **are committed**, and CI does **not** run the org export. An org edit
  that isn't re-exported and committed never reaches the live site. Always commit org + regenerated
  Markdown together.
- Subtrees tagged `:noexport:` are skipped: the long "Hugo local development workflow" notes section
  and "About This Website". `content/about.md` is a stale leftover from before that tag — it is still
  tracked but no longer regenerated.
- `.gitignore` excludes `content/site.md` (ox-hugo's export of the file-level `#+title`).

Export from Emacs with the org file open: `C-c C-e H A` (all subtrees) or `C-c C-e H H` (current
subtree). `#+hugo_base_dir: ../` at the top of `site.org` points ox-hugo back at the repo root, and
`init.el` sets `org-hugo-default-section-directory` to `""`, which is why pages land in `content/`
root instead of ox-hugo's default `posts/`.

Verified headless equivalent (produces byte-identical output to the in-Emacs export, so it is safe
to run and review with `git diff content/`):

```sh
emacs --batch  --eval "(progn (require 'package) (setq package-user-dir (expand-file-name \"~/.emacs.d/elpa\")) (package-initialize))"  --eval "(require 'ox-hugo)"  --eval "(setq org-hugo-default-section-directory \"\")"  --eval "(find-file \"content-org/site.org\")"  --eval "(org-hugo-export-wim-to-md t)"
```

## Commands

```sh
git submodule update --init --recursive   # REQUIRED before any local build (see below)
hugo server -D -p 1313                    # local preview at http://localhost:1313
hugo --minify                             # production build into public/ (gitignored)
```

The theme is **Anatole** (`themes/anatole`, a git submodule pinned to tag v1.21.0). The old
`themes/PaperMod` submodule is still present but unused; switch back by changing `theme =` in
`config.toml`. When a theme submodule is not checked out, Hugo does **not** fail — with PaperMod
it exited 0 with only `found no layout file for "html"` warnings and contentless HTML (4 pages
instead of 13). If a local preview looks blank, initialize the submodules rather than debugging the
templates.

**Dart Sass is required.** Anatole compiles its SCSS with `toCSS` (transpiler `dartsass`), which
Hugo does not bundle. Without a `sass` executable on PATH the build fails with `TOCSS-DART: failed
to transform "/scss/main.scss"`. Locally the standalone Dart Sass lives in
`C:\Users\dtregea\tools\dart-sass` (on the user PATH); CI installs it with `snap install
dart-sass`. Hugo writes the compiled CSS cache to `resources/` (gitignored).

Hugo version: CI pins `0.163.3` extended, matching the local install (Anatole needs >= 0.158).
`config.toml` uses `locale`, not the deprecated `languageCode`.

## Conventions

- **Styling.** Site-wide styling is `assets/css/custom.css` (Anatole's `params.customCss`; it must
  live under `assets/`, not `static/`, because the theme loads it with `resources.Get`). It sets the
  Inter font, ragged-right text, compact body-size paper titles, a 760px text column, and a sidebar
  of 20% (`params.contentratio = 0.8`) with a 280px floor. Page-specific styling is still inline
  `#+begin_export html <style>…</style>` at the top of each page subtree (e.g.
  `body { text-align: justify }`, which custom.css overrides inside page content, and the
  `.floatRight` home-page photo, which custom.css hides because the photo is in the sidebar). This is
  why `markup.goldmark.renderer.unsafe = true` is required in `config.toml`.
- **Abstract collapse.** `#+begin_collapse` blocks (`#+hugo_paired_shortcodes: collapse`) render
  through the project's own `layouts/shortcodes/collapse.html` (`<details>`), so they work under
  any theme.
- **Assets.** PDFs go in `static/files/`, images in `static/photos/`. Link them from org as
  root-relative paths — `[[/files/paper.pdf][Title]]`, `[[/photos/pic.jpg]]`. (`../static/files/...`
  also exports correctly, but the root-relative form is the norm here.)
- **CV updates.** Add a new dated `static/files/tregeagleCV_YYYY_MM.pdf`, update the link in the `CV`
  subtree of `site.org`, re-export. Old CV PDFs are kept, not deleted. The CV is the upstream source
  of truth for the Research and Extension pages; its own PDF hyperlinks carry the canonical DOIs, so
  extract them (`pypdf` link annotations) rather than guessing, and cross-check against Crossref.
- **Navigation** is hardcoded as `[[menu.main]]` entries in `config.toml`. A new page needs both a new
  org subtree *and* a menu entry.
- Research/Extension entries follow a fixed shape: heading is the title (linked to a DOI or a
  `/files/` PDF), then the journal/outlet line ending in an org line break `\\`, then
  `(with coauthors)` on the next line, then the abstract (Research: inside a `#+begin_collapse`
  block with `#+attr_shortcode: :summary Abstract`; Extension: a plain paragraph).

## Deploy

Push to `master` → `.github/workflows/hugo.yaml` checks out with `submodules: recursive`, installs
Dart Sass, runs `hugo --minify`, and deploys `public/` to GitHub Pages. `CNAME` maps the site to
`www.danieltregeagle.com`. There is no deploy step for the org export — see the pipeline note above.
