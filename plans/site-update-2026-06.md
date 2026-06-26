# Site update: correctness, audience-facing restructure, applied/policy page

**Repo:** `C:\Users\dtregea\repos\danieltregeagle.github.io` · **Branch:** feature branch off `master`
**Started:** 2026-06-26 · **Owner:** Daniel Tregeagle
**Source spec:** `plans/archive/DRAFT-site-update-instructions.md` (archived)

This file is the **single source of truth and live tracker**. Resumable across
sessions; keep it current in the same commit that does the work.

---

## ▶ RESUME PROTOCOL — read this first (cheap restart)

1. **Read this file top-to-bottom** — it is the only doc you need.
2. Run `git log --oneline -15`. Commit subjects are tagged `plan(<ID>): …`.
3. Find **Current position** below. The next unchecked `[ ]` at/after it is the next action.
4. **Preconditions / how to build:**
   - All page content is authored in `content-org/site.org` as ox-hugo subtrees. **Never hand-edit `content/**/*.md`** — it is generated.
   - To regenerate + preview, use the **`build-site` skill**: `pwsh .claude/skills/build-site/scripts/build-site.ps1 [-NoBuild | -Serve]`. The batch ox-hugo export runs headless; no interactive Emacs needed.
   - Per-task loop: edit `site.org` → run build-site `-NoBuild` → `git diff content/` to confirm the export → build/serve to verify rendered output → commit.

After finishing a task: tick its box, add a one-line **Session Log** entry, update **Current position**, and commit `plan(<ID>): <summary>`. One task or tight cluster per commit.

**Status legend:** `[ ]` todo · `[~]` in progress · `[x]` done · `[!]` blocked (see Decisions) · `keep`

**Current position:** ▶ Phases 1–2 done + verified locally on branch `site-update-2026-06` (uncommitted). Surfaced D6 (social icons). Next: Phases 3–5 (Applied page, research lead-in, extension), pending Daniel's nod on the home-page approach.

### Session Log (newest first)
- 2026-06-26 · P0 · Toolchain verified (Hugo 0.163.3 extended, Emacs 29.4, ox-hugo installed). Theme submodule checked out. `build-site` skill authored + tested (export = zero diff). All required PaperMod social icons confirmed present. Source spec archived. Plan finalized.
- 2026-06-26 · bootstrap · Plan authored from DRAFT spec.

---

## 1. What this is

Five scoped changes to danieltregeagle.com, sequenced lowest-risk first: (1) a correctness pass, (2) a plain-English value statement on the home page, (3) a new Applied & Policy Work page, (4) a research-program lead-in, (5) an audience-facing extension page. Content edits go through `content-org/site.org`; some changes are Hugo `config.toml` edits. The full org→md→html pipeline runs locally, so every change is previewable before it reaches GitHub.

## 2. Background / facts (confirmed — do not re-derive)

- **Toolchain works locally.** Hugo `v0.163.3` extended + Emacs 29.4 + `ox-hugo-20250212.310` installed. PaperMod theme submodule now checked out. `build-site` skill runs export→build/serve; batch export reproduces committed `content/` byte-for-byte (zero git diff).
- **Org source:** single file `content-org/site.org`. **Export mode: subtree** — each page is a top-level heading with `:EXPORT_FILE_NAME:` (e.g. `research` → `content/research.md`). New pages = new subtrees.
- **Hugo config:** `config.toml` holds `[params]`, `[[params.socialIcons]]`, and `[[menu.main]]` nav. **Menu lives in config, not org.** Current weights: Home 1, Research 2, Teaching 3, Extension 4, CV 5.
- **Social icons present in this PaperMod:** `email`, `googlescholar`, `orcid`, `linkedin`, `researchgate` all exist in `themes/PaperMod/layouts/partials/svg.html`. No custom SVG needed.
- **Email already published & resolved:** `config.toml` has a `socialIcons` `email` → `mailto:tregeagle@ncsu.edu`. Use this address wherever a contact is needed; no TODO.
- **CI** pins Hugo 0.147.2 (`.github/workflows/hugo.yaml`); local is newer, so local builds emit harmless deprecation warnings (e.g. `languageCode`). Deploy is automatic on push to `master`; `public/` is gitignored.
- **House style:** commas and verbal phrases, never em-dashes. No invented facts.
- **Title flip date 2026-08-15 is in the future** (today 2026-06-26), so the "before" wording applies now.

### TODO handling policy (per Daniel)

All unconfirmed claims and deferred work are tracked as **real org `TODO` headings tagged `:noexport:`**, so they show up as org TODOs but never reach the site. Collect them under a dedicated `* Site update TODOs   :noexport:` subtree in `site.org` (and/or as `:noexport:` child headings co-located with the relevant content, e.g. the title-flip reminder). **No fabricated values are published:** where a value is unknown (ORCID/Scholar URL, dollar figures, wording), the content omits the value and a `:noexport:` TODO tracks filling it in. Config-only unknowns (TOML) are tracked from the same org TODO subtree.

## 3. Tasks

### Phase 0 — Pre-flight & setup
- [x] **P0.1 — Checkout theme submodule.** `git submodule update --init --recursive`. _Status:_ `[x]`
- [x] **P0.2 — Local build toolchain + `build-site` skill.** Verified export/build; skill authored. _Status:_ `[x]`
- [x] **P0.3 — Archive source spec** to `plans/archive/`. _Status:_ `[x]`
- [x] **P0.4 — Create working branch** `site-update-2026-06` off `master`. _Status:_ `[x]`
- [x] **P0.5 — Add `* Site update TODOs :noexport:` subtree** to `site.org` (verified excluded from export). _Status:_ `[x]`

### Phase 1 — Item 1: Correctness pass (lowest risk)
| ID | Item | Where | Status |
|----|------|-------|--------|
| I1.a | Title staging done; `:noexport:` TODO with DEADLINE 2026-08-15 added | `site.org` home | `[x]` |
| I1.b | Contact line added to home (email/Scholar/ORCID inline links), renders ✅ | `site.org` home | `[x]` |
| I1.c | Scholar + ORCID added. **Finding:** PaperMod `socialIcons` only render in profile/home-info mode (neither enabled), so themed icons show nowhere. Used inline contact links instead; kept config entries. **See D6.** | `config.toml` + `site.org` | `[x]` |
| I1.d | Alt text added; rendered `<img alt="Daniel Tregeagle">` verified non-empty | `site.org` home | `[x]` |

### Phase 2 — Item 2: Plain-English value statement
- [x] **I2 — Value statement.** Drafted one-sentence plain-English lead added under the title, above the bio (intact). Held for Daniel's review (D3). _Status:_ `[x]`

### Phase 3 — Item 3: Applied & Policy Work page
- [ ] **I3.a — Scaffold page + nav.** New `site.org` subtree `:EXPORT_FILE_NAME: applied`, title "Applied & Policy Work". Add `[[menu.main]]` in `config.toml` weight 5; renumber CV to 6 → order Home, Research, Teaching, Extension, Applied & Policy Work, CV. _Status:_ `[ ]`
- [ ] **I3.b — Page content.** Lead line, "How I can help" problem-framed list, 3–5 project cards (title → outcome sentence → `Methods:` line), Skills/methods block. Unknown figures omitted, tracked as `:noexport:` TODOs (D4). `Methods:`/`Skills:` framing on this page only. _Status:_ `[ ]`
- [ ] **I3.c — Résumé link target.** Add a `:noexport:` TODO for the résumé PDF (PDF itself out of scope). _Status:_ `[ ]`

### Phase 4 — Item 4: Research page theme lead-in
- [ ] **I4 — Research program intro.** 2–3 theme headings + one-sentence descriptions above the publication list. **Do not reorder/remove publications.** Group existing pubs under themes only if low-effort. Themes tracked as `:noexport:` TODO (D3) until confirmed. _Status:_ `[ ]`

### Phase 5 — Item 5: Extension page for its audience
- [ ] **I5 — Extension audience pass.** Grower-facing lead line (using `tregeagle@ncsu.edu`); tighten each item to a one-sentence plain summary leading with the crop; optional commodity subheadings if clean; confirm narrow-width rendering. _Status:_ `[ ]`

### Phase 6 — Final verification
- [ ] **X1 — Full build + review.** Run `build-site`, review all changed pages rendered (nav order, icons, alt text, mobile width), confirm `git diff content/` matches intent, hand Daniel the open TODOs. _Status:_ `[ ]`

## 4. Method / per-task protocol

1. Edit the relevant `site.org` subtree (or `config.toml`).
2. Regenerate: `pwsh .claude/skills/build-site/scripts/build-site.ps1 -NoBuild`; inspect `git diff content/`.
3. Verify rendered output where acceptance is visual (icons, alt, nav, mobile): build or `-Serve` and inspect `public/` HTML.
4. Commit one task/cluster, tagged `plan(<ID>): …`, updating this tracker in the same commit.

## 5. Verification standard

- **Export fidelity:** `git diff content/` after export shows only the intended change.
- **Rendered checks (Claude-runnable locally — no longer gated on Daniel):**
  - I1.c icons resolve in built HTML once URLs exist.
  - I1.d exported `<img>` has a non-empty `alt`.
  - I3.a nav order correct in built HTML.
  - I5 page reads cleanly at narrow width.
- Build must complete without errors (deprecation warnings OK).

## 6. Decisions (open — need Daniel's values; do not block starting)

| ID | Question | Status |
|----|----------|--------|
| D1 | Google Scholar profile URL | **resolved → `https://scholar.google.com/citations?user=PccgqYIAAAAJ&hl=en`** (2026-06-26) |
| D2 | ORCID iD | **resolved → `https://orcid.org/0000-0002-8863-2832`** (2026-06-26) |
| D3 | Value-statement wording (Item 2) + research themes (Item 4) | **resolved → Claude drafts; Daniel reviews before publishing online** (2026-06-26) |
| D4 | Dollar figures / crop lists for Item 3 cards | **resolved → leave as `:noexport:` TODOs** (2026-06-26) |
| D5 | Nav label "Applied & Policy Work" as written? | **resolved → "Applied & Policy Work"** (2026-06-26) |

| D6 | Themed home-page social icons require enabling PaperMod profile/home-info mode. | **resolved → keep inline links now; explore profile mode after these edits land** (2026-06-26) |

**Publishing gate (D3):** all edits stay on the working branch and are previewed locally. Do **not** push to `master` (which auto-deploys) until Daniel reviews the drafted prose.

## 7. Out of scope

- The applied résumé PDF (Item 3 follow-on; separate LaTeX/markdown→PDF doc).
- Workflow and theme styling changes (deliberately excluded).
- Resolving `TODO`/Decision placeholders beyond inserting them.
- Deployment (automatic on push to `master`).
