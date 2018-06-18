# use_travis
#' Adds default .travis.yml
#' @return writes .travis.yml and adds it .Rbuildignore
#' @importFrom yaml as.yaml
#' @export

use_travis <- function() {


travis_yml <- yaml::as.yaml(list(language = "r",
       r = list("oldrel",
                "release"),
       sudo =  "required",
       r_packages = list("devtools",
                         "covr"),
       after_success = list("Rscript -e 'covr::codecov()'")),
       indent = 3)


writeLines(text = travis_yml,
           con =  ".travis.yml")

ignored_files <- readLines(".Rbuildignore")

travis_ci_pat <- "\\^.travis\\\\.yml|.travis.yml"

has_travis_yml <- any(grepl(x = ignored_files, pattern = travis_ci_pat ))

if (! has_travis_yml) {
  ignored_files <- append(x = ignored_files, values = "^.travis\\.yml$")
  writeLines(text = ignored_files,
             con = ".Rbuildignore")
}


}
