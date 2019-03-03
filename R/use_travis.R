# use_travis -------------------------------------------------------------------

#' Adds default .travis.yml
#' @param auto_build_pkgdown  prepare Travis for pkgdown::build_site()
#' (default: FALSE)
#' @param dbg print debug messages (default: TRUE)
#' @return writes .travis.yml and adds it .Rbuildignore
#' @importFrom yaml as.yaml write_yaml
#' @export

use_travis <- function(auto_build_pkgdown = FALSE, dbg = TRUE)
{
  travis_yml <- ".travis.yml"

  if (fs::file_exists(travis_yml)) {

    kwb.utils::catAndRun(
      dbg = dbg,
      messageText = sprintf("Deleting existing '%s'\n", travis_yml),
      expr = fs::file_delete(travis_yml)
    )
  }

  release_list <- list(
    r = "release",
    after_success = list("Rscript -e 'covr::codecov()'")
  )

  if (auto_build_pkgdown) {

    release_list$before_deploy <- list(
      "Rscript -e 'remotes::install_cran(\"pkgdown\")'"
    )

    release_list$deploy <- list(
      provider = "script",
      script = "Rscript -e 'pkgdown::deploy_site_github(verbose = TRUE)'",
      skip_cleanup = "true"
    )
  }

  include_list <- list(list(r = "devel"), release_list, list(r = "oldrel"))

  travis_list <- list(
    language = "r",
    sudo = "required",
    cache = "packages",
    r_packages = c("remotes", "covr"),
    matrix = list("include" = include_list)
  )

  kwb.utils::catIf(dbg, "Writing '.travis.yml':\n")
  kwb.utils::catIf(dbg, yaml::as.yaml(travis_list), sep = "\n")

  yaml::write_yaml(travis_list, travis_yml)

  write_to_rbuildignore(ignore_pattern = "^.travis\\.yml$")
}
