# use_ghactions-----------------------------------------------------------------

#' Adds default .github/workflows/
#'
#' Copies the default GitHub Actions workflows (R-CMD-check, pkgdown,
#' pr-commands, test-coverage) into `.github/workflows/`. Optionally adds the
#' Claude Code workflows (`claude.yaml`, `claude-code-review.yaml`) when
#' `claude = TRUE`. Those workflows require a `CLAUDE_CODE_OAUTH_TOKEN`
#' repository secret to be configured in GitHub.
#'
#' @param claude if `TRUE`, additionally copies the Claude Code workflows
#'   (`claude.yaml` and `claude-code-review.yaml`) into `.github/workflows/`.
#'   Defaults to `FALSE`.
#' @return writes `.github/workflows/` and adds it to `.Rbuildignore`
#' @importFrom fs dir_copy
#' @export
use_ghactions <- function(claude = FALSE)
{
  fs::dir_copy(
    path = system.file("templates/ci_github-actions/", package = "kwb.pkgbuild"),
    new_path = ".github/workflows",
    overwrite = TRUE
  )

  if (isTRUE(claude)) {
    use_ghactions_claude()
  }

  write_to_rbuildignore(ignore_pattern = "^\\.github$")
}

# use_ghactions_claude----------------------------------------------------------

#' Adds Claude Code workflows to .github/workflows/
#'
#' Copies the Claude Code workflows (`claude.yaml` and `claude-code-review.yaml`)
#' into `.github/workflows/`. Requires a `CLAUDE_CODE_OAUTH_TOKEN` repository
#' secret to be configured in GitHub for the workflows to function.
#'
#' @return writes Claude workflow YAML files into `.github/workflows/`
#' @importFrom fs dir_create file_copy dir_ls
#' @export
use_ghactions_claude <- function()
{
  fs::dir_create(".github/workflows")

  src_dir <- system.file(
    "templates/ci_github-actions-claude/",
    package = "kwb.pkgbuild"
  )

  fs::file_copy(
    path = fs::dir_ls(src_dir, glob = "*.yaml"),
    new_path = ".github/workflows/",
    overwrite = TRUE
  )
}
