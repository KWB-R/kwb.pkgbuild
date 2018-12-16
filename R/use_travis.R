# use_travis
#' Adds default .travis.yml
#' @return writes .travis.yml and adds it .Rbuildignore
#' @importFrom yaml as.yaml
#' @export

use_travis <- function() {
  travis_yml <- yaml::as.yaml(list(
    language = "r",
    r = list(
      "oldrel",
      "release"
    ),
    sudo = "required",
    cache = "packages",
    r_packages = list(
      "remotes",
      "covr"
    ),
    after_success = list("Rscript -e 'covr::codecov()'")
  ),
  indent = 3
  )


  writeLines(
    text = travis_yml,
    con = ".travis.yml"
  )


  write_to_rbuildignore(ignore_pattern = "^.travis\\.yml$")
}
