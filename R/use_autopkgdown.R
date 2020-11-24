# use_autopkgdown --------------------------------------------------------------

#' Use Auto Pkgdown
#' @description automate pkgdown::build_site by running it on Travis and
#' deploying to gh-pages branch
#' @inheritParams create_empty_branch_ghpages
#' @return workflow required for automating pkgdown::build_site() on Travis
#' @export
use_autopkgdown <- function(
  repo = NULL,
  org = "KWB-R",
  set_githubuser = TRUE,
  git_exe = path_to_git(),
  dest_dir = tempdir(),
  execute = TRUE,
  dbg = TRUE,
  ...
)
{
  if (is.null(repo)) {
    repo <- desc::desc_get_field("Package")
  }

  # Add "docs" folder to .gitignore
  ignore_docs_folder(dbg = dbg)


  # Create empty gh-pages branch
  create_empty_branch_ghpages(repo,
    org,
    set_githubuser,
    git_exe = git_check_if_windows(git_exe),
    dest_dir,
    execute,
    dbg,
    ...
  )

  # Create .gitlab-ci.yml for "main" branch with "docs" folder
  use_gitlab_ci_docs(dest_dir = file.path(dest_dir, repo))

  # Update Github Actions
  use_ghactions()

  # Delete .gitlab-ci.yml (if existing in "main" branch)
  fs::file_delete(".gitlab-ci.yml")

  # Delete "docs" folder (if existing in "main" branch)
  #fs::dir_delete(path = "docs")
}

# ignore_docs_folder -----------------------------------------------------------

#' @keywords internal
#' @noRd
ignore_docs_folder <- function(ignore_pattern = "docs", dbg = TRUE)
{
  # Put "docs" folder to .gitignore
  msg <- c(
    "",
    # Ignore "docs" folder as pkgdown::build_site() is run on Travis-CI',
    '# and deploys the website to "gh-pages" branch'
  )

  kwb.utils::catAndRun(
    dbg = dbg,
    messageText = sprintf("Adding '%s' to .gitignore", ignore_pattern),
    expr = write_to_gitignore(ignore_pattern, msg)
  )
}
