# Adds default .github/workflows/

Copies the default GitHub Actions workflows (R-CMD-check, pkgdown,
pr-commands, test-coverage) into `.github/workflows/`. Optionally adds
the Claude Code workflows (`claude.yaml`, `claude-code-review.yaml`)
when `claude = TRUE`. Those workflows require a
`CLAUDE_CODE_OAUTH_TOKEN` repository secret to be configured in GitHub.

## Usage

``` r
use_ghactions(claude = FALSE)
```

## Arguments

- claude:

  if `TRUE`, additionally copies the Claude Code workflows
  (`claude.yaml` and `claude-code-review.yaml`) into
  `.github/workflows/`. Defaults to `FALSE`.

## Value

writes `.github/workflows/` and adds it to `.Rbuildignore`
