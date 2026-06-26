#!/usr/bin/env pwsh
# Export Org content to Hugo markdown via ox-hugo (batch Emacs), then build or serve.
#
# Usage (from anywhere):
#   pwsh .claude/skills/build-site/scripts/build-site.ps1            # export + production build
#   pwsh .claude/skills/build-site/scripts/build-site.ps1 -Serve     # export + live-reload server
#   pwsh .claude/skills/build-site/scripts/build-site.ps1 -NoBuild   # export only (regenerate content/*.md)
[CmdletBinding()]
param(
  [switch]$Serve,    # run `hugo server -D` after export (live reload)
  [switch]$NoBuild,  # export only; skip the Hugo build
  [int]$Port = 1313
)
$ErrorActionPreference = 'Stop'

# Repo root = three levels up from this script (.claude/skills/build-site/scripts/).
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
$org  = Join-Path $repo 'content-org\site.org'
if (-not (Test-Path $org)) { throw "Org source not found: $org" }
$orgFwd = ($org -replace '\\','/')   # Emacs find-file is happiest with forward slashes

# The PaperMod theme is a git submodule; any Hugo build fails without it.
if (-not (Test-Path (Join-Path $repo 'themes\PaperMod\theme.toml'))) {
  Write-Host '== Initializing PaperMod theme submodule ==' -ForegroundColor Cyan
  git -C $repo submodule update --init --recursive
}

Write-Host '== Exporting Org -> Hugo markdown (ox-hugo batch) ==' -ForegroundColor Cyan
$eval = "(progn (package-initialize) (require 'ox-hugo) (find-file ""$orgFwd"") (org-hugo-export-wim-to-md :all-subtrees))"
emacs --batch --eval $eval
if ($LASTEXITCODE -ne 0) { throw "ox-hugo export failed (exit $LASTEXITCODE)" }

if ($Serve) {
  Write-Host "== hugo server -D on http://localhost:$Port ==" -ForegroundColor Cyan
  hugo server -D -p $Port --source $repo
} elseif (-not $NoBuild) {
  Write-Host '== hugo --minify (production build to public/) ==' -ForegroundColor Cyan
  hugo --minify --gc --source $repo
  if ($LASTEXITCODE -ne 0) { throw "hugo build failed (exit $LASTEXITCODE)" }
}
Write-Host '== Done ==' -ForegroundColor Green
