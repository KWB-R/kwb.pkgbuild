# create_empty_branch_ghpages --------------------------------------------------

#' Create Empty gh-pages branch
#'
#' @inheritParams create_empty_branch
#' @return create and push an empty gh-pages branch to org/repo
#' @export
create_empty_branch_ghpages <- function(
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
  create_empty_branch(
    repo = repo,
    branch = "gh-pages",
    org = org,
    set_githubuser = set_githubuser,
    git_exe = git_exe,
    dest_dir = dest_dir,
    execute = execute,
    dbg = dbg,
    ...
  )
}

# create_empty_branch ----------------------------------------------------------

#' Create Empty Branch From Github
#'
#' @param repo name of existing Github repository (default: NULL)
#' @param branch name of branch to be created (default: NULL)
#' @param org repo owner (default: "KWB-R")
#' @param set_githubuser should the Github user be set before executing the
#' branch creation (default: TRUE). In this case set_github_user() is run
#' @param git_exe path to GIT executable (default:
#'   kwb.pkgbuild:::path_to_git()), only required on "windows". On all other
#'   platforms it is assumed that "git" is sufficient!
#' @param dest_dir directory where the the repo should be checked out (default:
#' tempdir())
#' @param execute should a batch file be run?
#' @param dbg print debug messages (default: TRUE)
#' @param ... additional arguments passed to set_github_user
#' @return create empty branch (defined in 'branch') and push to org/repo on
#' Github
#' @export
#' @importFrom  fs dir_create
create_empty_branch <- function(
  repo = NULL,
  branch = NULL,
  org = "KWB-R",
  set_githubuser = TRUE,
  git_exe = path_to_git(),
  dest_dir = tempdir(),
  execute = TRUE,
  dbg = TRUE,
  ...
)
{
  if (is.null(repo)) clean_stop(
    "Specify the name of the repo to be checked out with parameter 'repo'"
  )

  if (is.null(branch)) clean_stop(
    "Specify the name of the branch to be created in parameter 'branch'"
  )

  git_exe <- git_check_if_windows(git_exe)

  fs::dir_create(dest_dir)

  cmd <- c(
    sprintf('cd "%s"', dest_dir),
    sprintf('"%s" clone https://github.com/%s/%s', git_exe, org, repo),
    sprintf('cd "%s"', repo),
    sprintf('"%s" checkout --orphan %s', git_exe, branch),
    sprintf('"%s" rm -rf .', git_exe),
    sprintf('"%s" commit --allow-empty -m "Initial gh-pages commit"', git_exe),
    sprintf('"%s" push origin %s', git_exe, branch),
    sprintf('"%s" checkout master', git_exe)
  )

  if (set_githubuser) cmd <- c(
    set_github_user(git_exe = git_exe, dbg = dbg, ...), cmd
  )

  file <- file.path(dest_dir, sprintf("create_empty_%s_branch.bat", branch))

  kwb.utils::catAndRun(
    dbg = dbg,
    messageText = paste("Writing batch file:", file),
    expr = writeLines(cmd, file)
  )

  if (execute) kwb.utils::catAndRun(
    dbg = dbg,
    messageText = paste("Running batch file:", file),
    expr = system(file)
  )

  git_exe <- git_check_if_windows(git_exe)

  fs::dir_create(dest_dir)

  cmd_checkout <- c(
    sprintf('cd "%s"', dest_dir),
    sprintf('"%s" clone https://github.com/%s/%s', git_exe, org, repo),
    sprintf('"%s" checkout -b %s', git_exe, branch)
  )

  write_git_batch_and_execute(
    cmd_checkout,
    set_githubuser,
    bat_name = sprintf("add_%s_branch.bat", branch),
    dest_dir,
    git_exe,
    execute,
    dbg,
    ...
  )

  checkout_path <- file.path(dest_dir, repo)

  use_gitlab_ci_ghpages(dest_dir = checkout_path)

  cmd_push <- c(
    sprintf('cd "%s"', checkout_path),
    sprintf('"%s" add %s', git_exe, ".gitlab-ci.yml"),
    sprintf('"%s" commit -m "Add backup deploy config for GitLab"', git_exe),
    sprintf('"%s" push origin %s', git_exe, branch)
  )

  write_git_batch_and_execute(
    cmd_push,
    set_githubuser,
    bat_name = sprintf("add_%s_branch.bat", branch),
    dest_dir,
    git_exe,
    execute,
    dbg,
    ...
  )
}

# clean_stop -------------------------------------------------------------------
clean_stop <- function(...)
{
  stop(..., call. = FALSE)
}
