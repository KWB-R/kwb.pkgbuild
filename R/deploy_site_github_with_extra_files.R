#' cat_line
#' @keywords internal
#' @noRd
#'
cat_line <- function (...) {
  cat(paste0(..., "\n"), sep = "")
}

#' write_lines
#' @keywords internal
#' @noRd
#'
write_lines <- function (text, path) {
  base::writeLines(enc2utf8(text), path, useBytes = TRUE)
}

# add function from usethis
# https://github.com/r-lib/usethis/blob/ef2354ccf350ae98c549dc952230069704355c3c/R/browse.R#L78

#' github_url_rx
#' @keywords internal
#' @noRd
#'
github_url_rx <- function() {
  paste0(
    "^",
    "(?:https?://github.com/)",
    "(?<owner>[^/]+)/",
    "(?<repo>[^/#]+)",
    "/?",
    "(?<fragment>.*)",
    "$"
  )
}

# pkgdown functions (missing in pkgdown >= 1.5.0) ------------------------------

#' git
#' @importFrom processx run
#' @keywords internal
#' @noRd
#'
git <- function(...) {
  processx::run("git", c(...), echo_cmd = TRUE, echo = TRUE)
}

#' construct_commit_message
#'
#' @keywords internal
#' @noRd
#'
construct_commit_message <- function(pkg, commit = Sys.getenv("TRAVIS_COMMIT")) {
  pkg <- pkgdown::as_pkgdown(pkg)

  sprintf("Built site for %s: %s@%s", pkg$package, pkg$version, substr(commit, 1, 7))
}

#' rule
#' @importFrom cli cat_rule
#' @importFrom crayon bold
#' @keywords internal
#' @noRd
#'
rule <- function (left, ...)
{
  cli::cat_rule(left = crayon::bold(left), ...)
}

#' github_clone
#'
#' @keywords internal
#' @noRd
#'
github_clone <- function(dir, repo_slug) {
  remote_url <- sprintf("git@github.com:%s.git", repo_slug)
  rule("Cloning existing site", line = 1)
  git("clone",
      "--single-branch", "-b", "gh-pages",
      "--depth", "1",
      remote_url,
      dir
  )
}


#' github_push
#'
#' @importFrom withr with_dir
#' @keywords internal
#'
github_push <- function(dir, commit_message) {
  # force execution before changing working directory
  force(commit_message)

  rule("Commiting updated site", line = 1)

  withr::with_dir(dir, {
    git("add", "-A", ".")
    git("commit", "--allow-empty", "-m", commit_message)

    rule("Deploying to GitHub Pages", line = 1)
    git("remote", "-v")
    git("push", "--force", "origin", "HEAD:gh-pages")
  })
}

# deploy_site_github_with_extra_files ------------------------------------------

#' deploy_site_github_with_extra_files
#'
#' @description for details see pkgdown::deploy_site_github(), only parameter
#' vignettes_file_pattern_to_copy added
#' @param pkg "."
#' @param vignettes_file_pattern_to_copy  file patern for copying files from
#' vignettes directory into deploy directory (default: "\\.json$")
#' @param install Optionally, opt-out of automatic installation. This is
#'   necessary if the package you're documenting is a dependency of pkgdown
#' @param tarball tarball Sys.getenv("PKG_TARBALL", "")
#' @param ssh_id ssh_id Sys.getenv("id_rsa", "")
#' @param commit_message commit_message (default: construct_commit_message(pkg))
#' @param clean Clean all files from old site (default: FALSE)
#' @param verbose Print verbose output (default: TRUE)
#' @param host The GitHub host url (default: "github.com")
#' @param repo_slug The `user/repo` slug for the repository.
#' @param ... additional arguments passed to [deploy_to_branch_with_extra_files]
#' @return deploy pkgdown site including additional files in "vignettes" source
#' folder to "gh-pages"
#' @export
#' @importFrom fs dir_create file_temp dir_delete file_chmod
#' @importFrom rematch2 re_match
#' @importFrom pkgdown build_site
#' @importFrom callr rcmd
#' @importFrom openssl base64_decode
deploy_site_github_with_extra_files <- function(
  pkg = ".",
  vignettes_file_pattern_to_copy = "\\.json$",
  install = TRUE,
  tarball = Sys.getenv("PKG_TARBALL", ""),
  ssh_id = Sys.getenv("id_rsa", ""),
  commit_message =construct_commit_message(pkg),
  clean = FALSE,
  verbose = TRUE,
  host = "github.com",
  repo_slug = Sys.getenv("TRAVIS_REPO_SLUG", ""),
  ...
)
{
  stop_if_missing <- function(x, ...) if (! nzchar(x)) clean_stop(...)

  stop_if_missing(
    tarball, "No built tarball detected, please provide the location of one ",
    "with `tarball`"
  )

  stop_if_missing(
    ssh_id, "No deploy key found, please setup with ",
    "`travis::use_travis_deploy()`"
  )

  stop_if_missing(
    repo_slug, "No repo detected, please supply one with `repo_slug`"
  )

  rule("Deploying site", line = 2)

  if (install) {
    rule("Installing package", line = 1)
    callr::rcmd("INSTALL", tarball, show = verbose, fail_on_status = TRUE)
  }

  ssh_id_file <- "~/.ssh/id_rsa"
  rule("Setting up SSH id", line = 1)
  cat_line("Copying private key to: ", ssh_id_file)
  write_lines(rawToChar(openssl::base64_decode(ssh_id)), ssh_id_file)
  cat_line("Setting private key permissions to 0600")
  fs::file_chmod(ssh_id_file, "0600")

  deploy_to_branch_with_extra_files(pkg,
                                    vignettes_file_pattern_to_copy,
                                    commit_message,
                                    clean,
                                    ...)

  rule("Deploy completed", line = 2)
}

# copy_files_from_vignettes_dir_to_deploy_dir ----------------------------------

#' Copy files from Vignettes Dir to Deploy idir
#'
#' @param source_dir default: "."
#' @param deploy_dir default: "docs
#' @param pattern file pattern to export (default: "\\.json$")
#' @param overwrite should existing files be overwritten (default: TRUE)
#' @return files matching pattern copied to deploy_dir
#' @export
#' @importFrom fs dir_ls file_copy
copy_files_from_vignettes_dir_to_deploy_dir <- function(
  source_dir = ".", deploy_dir = "docs", pattern = "\\.json$", overwrite = TRUE
)
{
  from <- fs::dir_ls(file.path(source_dir, "vignettes"), regexp = pattern)

  to <- file.path(deploy_dir, basename(from))

  fs::file_copy(from, to, overwrite = overwrite)
}

#' Build and deploy a site locally with extra files
#'
#' Assumes that you're in a git clone of the project, and the package is
#' already installed.
#' @param pkg "."
#' @param vignettes_file_pattern_to_copy  file patern for copying files from
#' vignettes directory into deploy directory (default: "\\.json$")
#' @param branch The git branch to deploy to
#' @param remote The git remote to deploy to
#' @param github_pages Is this a GitHub pages deploy. If `TRUE`, adds a `CNAME`
#'   file for custom domain name support, and a `.nojekyll` file to suppress
#'   jekyll rendering.
#' @param ... Additional arguments passed to pkgdown::build_site()
#' @inheritParams deploy_site_github_with_extra_files
#' @importFrom utils getFromNamespace
#' @export
deploy_to_branch_with_extra_files <- function(pkg = ".",
                             vignettes_file_pattern_to_copy = "\\.json",
                             commit_message = construct_commit_message(pkg),
                             clean = FALSE,
                             branch = "gh-pages",
                             remote = "origin",
                             github_pages = (branch == "gh-pages"),
                             ...) {
  dest_dir <- fs::dir_create(fs::file_temp())
  on.exit(fs::dir_delete(dest_dir))

  if (!git_has_remote_branch(remote, branch)) {
    old_branch <- git_current_branch()

    # If no remote branch, we need to create it
    git("checkout", "--orphan", branch)
    git("rm", "-rf", "--quiet", ".")
    git("commit", "--allow-empty", "-m", sprintf("Initializing %s branch", branch))
    git("push", remote, paste0("HEAD:", branch))

    # checkout the previous branch
    git("checkout", old_branch)
  }

  # Explicitly set the branches tracked by the origin remote.
  # Needed if we are using a shallow clone, such as on travis-CI
  git("remote", "set-branches", remote, branch)

  git("fetch", remote, branch)

  github_worktree_add(dest_dir, remote, branch)
  on.exit(github_worktree_remove(dest_dir), add = TRUE)

  pkg <- pkgdown::as_pkgdown(pkg, override = list(destination = dest_dir))

  if (clean) {
    rule("Cleaning files from old site", line = 1)
    pkgdown::clean_site(pkg)
  }

  pkgdown::build_site(pkg, devel = FALSE, preview = FALSE, install = FALSE, ...)

  copy_files_from_vignettes_dir_to_deploy_dir(
    source_dir = pkg$src_path,
    deploy_dir = dest_dir,
    pattern = vignettes_file_pattern_to_copy,
    overwrite = TRUE
  )

  if (github_pages) {
    utils::getFromNamespace("build_github_pages", "pkgdown")(pkg)
  }

  github_push(dest_dir, commit_message, remote, branch)

  invisible()
}

#' git_has_remote_branch
#' @keywords internal
#' @noRd
#'
git_has_remote_branch <- function(remote, branch) {
  has_remote_branch <- git("ls-remote", "--quiet", "--exit-code", remote, branch, echo = FALSE, echo_cmd = FALSE, error_on_status = FALSE)$status == 0
}


#' git_current_branch
#' @keywords internal
#' @noRd
#'
git_current_branch <- function() {
  branch <- git("rev-parse", "--abbrev-ref", "HEAD", echo = FALSE, echo_cmd = FALSE)$stdout
  sub("\n$", "", branch)
}

#' github_worktree_add
#' @keywords internal
#' @noRd
#'
github_worktree_add <- function(dir, remote, branch) {
  rule("Adding worktree", line = 1)
  git("worktree",
      "add",
      "--track", "-B", branch,
      dir,
      paste0(remote, "/", branch)
  )
}

#' github_worktree_remove
#' @keywords internal
#' @noRd
#'
github_worktree_remove <- function(dir) {
  rule("Removing worktree", line = 1)
  git("worktree", "remove", dir)
}


#' github_push
#' @keywords internal
#' @noRd
#' @importFrom withr with_dir
#'
github_push <- function(dir, commit_message, remote, branch) {
  # force execution before changing working directory
  force(commit_message)

  rule("Commiting updated site", line = 1)

  withr::with_dir(dir, {
    git("add", "-A", ".")
    git("commit", "--allow-empty", "-m", commit_message)

    rule("Deploying to GitHub Pages", line = 1)
    git("remote", "-v")
    git("push", "--force", remote, paste0("HEAD:", branch))
  })
}

#' git
#' @keywords internal
#' @noRd

git <- function(..., echo_cmd = TRUE, echo = TRUE, error_on_status = TRUE) {
  processx::run("git", c(...), echo_cmd = echo_cmd, echo = echo, error_on_status = error_on_status)
}


#' construct_commit_message
#' @keywords internal
#' @noRd
#'
construct_commit_message <- function(pkg, commit = ci_commit_sha()) {
  pkg <- pkgdown::as_pkgdown(pkg)

  sprintf("Built site for %s: %s@%s", pkg$package, pkg$version, substr(commit, 1, 7))
}

#' ci_commit_sha
#' @keywords internal
#' @noRd
#'
ci_commit_sha <- function() {
  env_vars <- c(
    # https://docs.travis-ci.com/user/environment-variables/#default-environment-variables
    "TRAVIS_COMMIT",
    # https://help.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables#default-environment-variables
    "GITHUB_SHA"
  )

  for (var in env_vars) {
    commit_sha <- Sys.getenv(var, "")
    if (commit_sha != "")
      return(commit_sha)
  }

  ""
}
