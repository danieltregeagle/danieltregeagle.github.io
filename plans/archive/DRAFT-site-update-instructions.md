# Site update instructions for Claude Code

**Repo type:** Hugo site, PaperMod theme, content authored in Org and exported via **ox-hugo**.

These instructions cover five scoped changes to danieltregeagle.com. Read the ground rules and run the pre-flight before touching anything.

---

## Ground rules

1. **The `.org` files are the source of truth.** Do **not** hand-edit the generated `content/**/*.md` files; ox-hugo overwrites them on the next export. Find and edit the Org sources.
2. **Re-export after editing.** Check the repo for a build/export script (Makefile, justfile, `scripts/`, a CI config, or an Emacs batch command). If one exists, run it. If not, list the Org files you changed and tell Daniel the export command to run in Emacs (`C-c C-e H A` for all subtrees, or `C-c C-e H H` per file). Never leave Org edited without a matching re-export.
3. **Mirror the existing export pattern.** Determine whether the repo uses ox-hugo's *one-post-per-subtree* style (`:EXPORT_HUGO_*:` properties on headings) or *one-file-per-page* style (file-level `#+hugo_*` keywords), and follow whichever is already in use when adding pages or menu entries.
4. **Config vs. content.** Some changes below are Hugo config edits (`config.toml`/`config.yaml` under `params`), not Org content. The instructions say which is which. Don't put config-driven values into Org content or vice versa.
5. **House writing style.** For any prose you add to the site, use commas and verbal phrases for clarifying clauses, never em-dashes. Keep sentences plain and concrete.
6. **No invented facts.** Do not fabricate titles, dates, dollar figures, IDs, or URLs. Where a value is unknown, insert a clearly marked `TODO(daniel): ...` placeholder instead of guessing.
7. **Keep academic pages uncluttered.** The home, research, and teaching pages stay clean and scholarly. Industry-facing material lives on its own page (Item 3), not bolted onto these.

### Pre-flight (do this first, then report back before editing)

1. Locate and print paths for: the Org source directory, the Hugo config file (the one holding PaperMod `params`), the `content/` output directory, and the theme directory.
2. State the export mode (subtree vs. file) and whether a build/export script exists.
3. Print the current Org source for the **home**, **research**, and **extension** pages so edits target the right blocks.

---

## Item 1 — Correctness pass

Lowest risk, helps every audience.

**(a) Title staging.** In the home Org source, replace the current "Assistant Professor and Extension Specialist" line.

- Before August 15, 2026: `Assistant Professor and Extension Specialist (promotion to Associate Professor with tenure effective August 15, 2026)`
- On or after August 15, 2026: `Associate Professor with Tenure and Extension Specialist`

Use the first version now and leave a `TODO(daniel): flip title to Associate on/after 2026-08-15` comment so the change isn't forgotten.

**(b) Contact path.** Add a visible way to reach him. Pick whichever fits the current setup:

- Add an `email` entry to `params.socialIcons` with `url = "mailto:TODO(daniel)@ncsu.edu"`, and/or
- Add a one-line `Contact: TODO(daniel)@ncsu.edu` to the home Org content.

Use a `TODO` for the address; do not publish an email that isn't already in the repo.

**(c) ORCID + Google Scholar.** Add to `params.socialIcons` in the Hugo config:

```toml
[[params.socialIcons]]
name = "googlescholar"
url = "TODO(daniel): Google Scholar profile URL"

[[params.socialIcons]]
name = "orcid"
url = "https://orcid.org/TODO(daniel)"
```

**Verify the icons exist** in this PaperMod version (check the theme's `assets/svg.json` or the `social_icons` partial for `googlescholar` and `orcid`). If either name is missing, add a custom SVG via a project-level `assets/` override, or fall back to an `email`/website icon. Do not assume the icon name resolves.

**(d) Home image alt text.** The landing photo currently exports as `![](...)` with empty alt (an accessibility and SEO miss). In the Org source, give it descriptive alt text. Try:

```org
#+attr_html: :alt Daniel Tregeagle :title Daniel Tregeagle
[[/photos/danielTregeaglePicture2.JPG]]
```

Then **verify the exported HTML `<img>` has a non-empty `alt`**. If this ox-hugo version doesn't pick up `:alt` that way, fall back to a raw export block (`#+begin_export md` ... `<img src="..." alt="Daniel Tregeagle">` ... `#+end_export`) or move the photo into PaperMod `profileMode`. The acceptance test is the rendered output, not the Org syntax.

**Acceptance:** title reads correctly for the date; a contact method is visible; Scholar and ORCID icons resolve; the home image has a meaningful, non-empty alt attribute.

---

## Item 2 — Plain-English value statement on the home page

**Goal:** one short, non-jargon statement above the research detail, true to his academic identity but legible to a non-specialist.

**Where:** top of the home Org content, immediately under the name and title, before the existing research and extension paragraphs. Do not delete the existing bio paragraphs; this leads into them.

**Draft copy** (mark `TODO(daniel): confirm wording`, since these are claims about him):

> I am an agricultural economist who helps growers, industry groups, agencies, and research teams use economic evidence to make better decisions about specialty crops, technology adoption, supply chains, and policy.

Keep it to one or two sentences. Comma and verbal style, no em-dashes.

**Acceptance:** the statement renders as the first text block under the title on the homepage; existing paragraphs intact below it.

---

## Item 3 — Applied & Policy Work page

**Goal:** a dedicated industry-facing surface so the homepage and research page stay academic. This is the new home for the problem-framed, skills-tagged material.

**Scaffold a new page** mirroring the repo's export pattern:

- New Org source (e.g., `applied.org`, or a new subtree if the repo is subtree-based) with a title such as `Applied & Policy Work`.
- Add it to the main menu after Extension, using the same mechanism as existing entries (`menu.main` in config, or `#+hugo_menu`/`:EXPORT_HUGO_MENU:` depending on mode). Set the weight so nav order is Home, Research, Teaching, Extension, Applied & Policy Work, CV.

**Page structure** (prose marked `TODO` is his to confirm; figures must trace to already-published work on the site):

- **Lead line:** `I translate economic analysis into decisions for growers, agribusiness, and agencies.`
- **"How I can help"** as a problem-framed list: technology and variety adoption; specialty-crop market analysis; enterprise budgeting and cost-of-production; regulatory and policy impact analysis; perennial-crop investment and replacement; supply-chain and processing economics; decision tools and stakeholder presentations.
- **3 to 5 project cards.** Each card is a bold title, then one outcome sentence that leads with the number or the decision, then a `Methods:` line. Seed from known public work, mark all figures `TODO` to confirm against the published articles already linked on the Extension and Research pages:
  - **Green Industry Economic Impact.** Quantified North Carolina's green-industry contribution for legislators and industry stakeholders. `Methods:` economic impact analysis, stakeholder reporting.
  - **Pesticide Withdrawal Cost Studies.** Estimated the revenue effects of pesticide cancellations across major crops to inform state regulatory decisions. `Methods:` partial-budget and impact analysis. `TODO(daniel): confirm $ and crop list from the published articles.`
  - **Technology and Variety Adoption.** Estimated grower willingness-to-pay for disease resistance and new varieties. `Methods:` survey design, discrete choice, willingness-to-pay analysis.
  - **Perennial-Crop Investment.** Modeled orchard and cane replacement and replanting dynamics. `Methods:` dynamic optimization, supply response.
- **Skills and methods block** (single list): economic impact analysis, cost-benefit analysis, enterprise budgeting, market analysis, technology-adoption modeling, survey design, discrete choice and willingness-to-pay, supply response, regulatory impact analysis, scenario analysis, stakeholder communication.

Keep the `Methods:`/`Skills:` framing on this page only. It must **not** appear on the homepage or research page.

**Follow-on, out of scope for Org edits (flag for Daniel):** a one-page "Applied Agricultural Economist" résumé PDF. That is a separate document (LaTeX or markdown to PDF), not an ox-hugo edit. Leave a `TODO(daniel): résumé.pdf` link target on this page so it can be wired up once the PDF exists.

**Acceptance:** new page appears in nav and renders; no fabricated figures (all unconfirmed numbers are `TODO`); homepage, research, and teaching pages untouched.

---

## Item 4 — Research page theme lead-in

**Goal:** turn the publication list into a research program without a full rewrite.

**Where:** the top of the research Org source, above the existing publication list. Do **not** reorder or remove any publications.

Add a short intro with two or three theme headings, each followed by a one-sentence description, then leave the existing publications beneath as evidence. Suggested themes (`TODO(daniel): confirm`):

- **Perennial-crop dynamics:** investment, replanting, and supply response in orchards, vineyards, and cane systems.
- **Specialty-crop adoption and supply response:** how growers value new varieties and technologies, and how supply adjusts.
- **Controlled-environment and emerging systems:** the economics of CEA and new production systems.

If grouping the existing publications under these themes is low-effort given the current markup, do it. If grouping is messy, just add the intro and leave the flat list as is.

**Acceptance:** the research page opens with a brief program statement; the publication list is intact.

---

## Item 5 — Extension page for its audience

**Goal:** grower- and agent-facing, scannable, mobile-friendly.

**Where:** the extension Org source.

- Add a top line: `Practical economics for specialty-crop growers and agents: budgets, market outlook, and impact analysis. For extension questions, reach me at TODO(daniel)@ncsu.edu.`
- Above each existing PDF link, ensure a one-sentence, plain-language summary written in grower terms, leading with the crop. Most items already have a summary; tighten each to a single scannable sentence.
- Where it helps, group items by commodity using subheadings (strawberries, sweetpotatoes, caneberries and blackberries, multi-crop and policy), but only if the current markup allows it without heavy churn.
- After export, confirm the page reads cleanly at narrow width. PaperMod is responsive; just check that no wide tables or embedded PDFs overflow on mobile.

**Acceptance:** grower-facing lead line present; each item has a one-line plain summary; optional commodity grouping applied where clean; page renders well at narrow width.

---

## Out of scope / for Daniel to handle

- The applied résumé PDF (Item 3 follow-on).
- Confirming all `TODO(daniel)` placeholders: email, ORCID iD, Google Scholar URL, dollar figures, exact research themes, and the title-flip date.
- Running the ox-hugo export if no build script exists in the repo.
- Workflow and theme styling changes, which were deliberately excluded as low-return.
