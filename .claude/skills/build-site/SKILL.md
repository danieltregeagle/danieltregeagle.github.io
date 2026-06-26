---
name: build-site
description: Build danieltregeagle.com locally. Exports the Org source (content-org/site.org) to Hugo markdown via a batch ox-hugo Emacs run, then builds or serves the site with Hugo. Use whenever you edit site.org and need to regenerate content/*.md, preview the site locally before pushing, or produce a production build. Also covers first-time setup (theme submodule).
---

# Build danieltregeagle.com locally

This site authors page content in **Org** (`content-org/site.org`) and exports it to
Markdown with **ox-hugo**, which Hugo then builds. `content/**/*.md` is **generated** —
never hand-edit it; edit the matching subtree in `site.org` and re-export.

The full pipeline is scriptable; no interactive Emacs is required.

```
content-org/site.org  --(ox-hugo batch)-->  content/*.md  --(hugo)-->  public/
```

## Quick start

Run the helper from the repo root:

```powershell
# Export Org -> markdown, then production build to public/
pwsh .claude/skills/build-site/scripts/build-site.ps1

# Export, then live-reload preview at http://localhost:1313
pwsh .claude/skills/build-site/scripts/build-site.ps1 -Serve

# Export only (regenerate content/*.md, no Hugo build) — useful for git-diffing the export
pwsh .claude/skills/build-site/scripts/build-site.ps1 -NoBuild
```

The script auto-initializes the PaperMod theme submodule on first run if it is missing.

## What each step is (if you need to run it by hand)

1. **Theme submodule** (one-time, required for any build):
   ```powershell
   git submodule update --init --recursive
   ```
2. **Batch export** Org -> markdown (exports every subtree with an `EXPORT_FILE_NAME`,
   skips `:noexport:` subtrees):
   ```powershell
   emacs --batch --eval "(progn (package-initialize) (require 'ox-hugo) (find-file \"C:/Users/dtregea/repos/danieltregeagle.github.io/content-org/site.org\") (org-hugo-export-wim-to-md :all-subtrees))"
   ```
3. **Build / serve** with Hugo:
   ```powershell
   hugo --minify        # build to public/
   hugo server -D -p 1313   # live-reload preview (-D includes drafts)
   ```

## Verifying an edit

- After editing `site.org`, run the script with `-NoBuild` and `git diff content/` to see
  exactly what your Org change produced in the generated markdown.
- For changes whose acceptance is the *rendered* result (image `alt` text, social icons,
  nav order, mobile width), build and inspect the HTML under `public/` or use `-Serve`.

## Notes

- **Page section:** `site.org` sets `#+hugo_section: .` so every page subtree exports to `content/` root. Without it, ox-hugo's default `org-hugo-section` (`posts`) would send pages to `content/posts/`. Do not remove this keyword.

- Local Hugo is newer than CI (CI pins 0.147.2 in `.github/workflows/hugo.yaml`). Local
  builds may emit Hugo deprecation warnings (e.g. `languageCode`) that CI does not; these
  are warnings, not failures.
- `public/` is gitignored. Deployment is automatic on push to `master` via GitHub Actions —
  this skill is for local preview/verification only, not deployment.
- Requires Emacs with the `ox-hugo` package installed (present in this environment) and
  `hugo` (extended) on PATH.
