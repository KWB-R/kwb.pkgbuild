
#' @keywords internal
#' @noRd
ignore_docs_folder <- function(ignore_pattern = "docs/.*", dbg = TRUE) {
  # Put "docs" folder to .gitignore
  msg <- c(
    "",
    # Ignore "docs" folder as pkgdown::build_site() is run on Travis-CI',
    '# and deploys the website to "gh-pages" branch'
  )
  if (dbg) print(sprintf("Adding '%s' to .gitignore", ignore_pattern))
  write_to_gitignore(ignore_pattern, msg)
}

#' Use Travis Auto Pkgdown Yml Template
#' @return default yaml if Auto Pkgdown is used
#' @export
#' @examples
#' cat(travis_autopkgdown_yml(), sep = '\n')
#'
travis_autopkgdown_yml <- function() {
  c(
    "language: r",
    "sudo: required",
    "cache: packages",
    "r_packages:",
    "  - remotes",
    "- covr",
    "matrix:",
    "  include:",
    "  - r: devel",
    "  - r: release",
    "after_success:",
    "  - Rscript -e 'covr::codecov()'",
    "before_deploy:",
    "  -  Rscript -e 'remotes::install_cran(\"pkgdown\")'",
    "deploy:",
    "  provider: script",
    "script: Rscript -e 'pkgdown::deploy_site_github(verbose = TRUE)'",
    "skip_cleanup: true",
    "- r: oldrel"
  )
}


#' Create Travis Auto Pkgdown Yml
#'
#' @param travis_template default: travis_autopkgdown_yml()
#' @param dbg (default: TRUE)
#' @return ".travis.yml" with content specified in travis_autopkgdown_yml()
#' @export
#' @importFrom fs file_exists file_delete
#'
create_travis_autopkgdown_yml <- function(travis_template = travis_autopkgdown_yml(),
                                          dbg = TRUE) {
  travis_yml <- ".travis.yml"
  if (fs::file_exists(travis_yml)) {
    if (dbg) cat(sprintf("Deleting existing '%s'\n", travis_yml))
    fs::file_delete(travis_yml)
  }

  if (dbg) {
    cat("Writing '.travis.yml':\n")
    cat(travis_template, sep = "\n")
  }
  writeLines(travis_template, ".travis.yml")
}



#' Use Auto Pkgdown
#' @description automate pkgdown::build_site by running it on Travis and
#' deploying to gh-pages branch
#' @inheritParams create_empty_branch_ghpages
#' @return workflow required for automating pkgdown::build_site() on Travis
#' @export
use_autopkgdown <- function(repo = NULL,
                            org = "KWB-R",
                            set_githubuser = TRUE,
                            git_exe = "C:/Program Files/Git/bin/git.exe",
                            dest_dir = tempdir(),
                            execute = TRUE,
                            dbg = TRUE,
                            ...) {
  if (is.null(repo)) {
    repo <- desc::desc_get_field("Package")
  }

  # 1) Add "docs" folder to .gitignore
  ignore_docs_folder(dbg = dbg)

  # 2) Add deploy key for Travis
  travis::use_travis_deploy()

  # 3) Create empty gh-pages branch
  create_empty_branch_ghpages(repo,
    org,
    set_githubuser,
    git_exe = git_check_if_windows(git_exe),
    dest_dir,
    execute,
    dbg,
    ...
  )

  # 4) Update .travis.yml
  create_travis_autopkgdown_yml(dbg)
}
