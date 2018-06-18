# use_gitlab_ci ----------------------------------------------------------------
#' Adds .gitlab-ci.yml (if repo contains a "docs" subfolder)
#' @return writes .gitlab-ci.yml and adds it .Rbuildignore
#' @importFrom yaml as.yaml
#' @export

use_gitlab_ci <- function() {

yml_docs <- yaml::as.yaml(list("pages" = list(script = list("mv docs public"),
                                artifacts = list(paths = list("public")),
                                only = list("master"))))


yml_ghpages <- yaml::as.yaml(list("pages" = list(stage = "deploy",
                                          script = list("mkdir .public",
                                                        "cp -r * .public",
                                                        "mv .public public"),
                                          artifacts = list(paths = list("public")),
                                              only = list("gh-pages"))))


if(dir.exists("docs")) {
  writeLines(text = yml_docs,
             con =  ".gitlab-ci.yml")


ignored_files <- readLines(".Rbuildignore")

gi_ci_pat <- "\\^.gitlab-ci\\\\.yml|.gitlab-ci.yml"

has_gitlab_yml <- any(grepl(x = ignored_files, pattern = gi_ci_pat ))

if (! has_gitlab_yml) {
ignored_files <- append(x = ignored_files, values = "^.gitlab-ci\\.yml$")
writeLines(text = ignored_files,
           con = ".Rbuildignore")
}
} else {
 warning("No 'docs' folder, no .gitlab-ci.yml created!")
}
}

