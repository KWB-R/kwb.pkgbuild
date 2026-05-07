# Adds Claude Code workflows to .github/workflows/

Copies the Claude Code workflows (`claude.yaml` and
`claude-code-review.yaml`) into `.github/workflows/`. Requires a
`CLAUDE_CODE_OAUTH_TOKEN` repository secret to be configured in GitHub
for the workflows to function.

## Usage

``` r
use_ghactions_claude()
```

## Value

writes Claude workflow YAML files into `.github/workflows/`
