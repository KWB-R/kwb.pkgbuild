# use_gitlab_ci ----------------------------------------------------------------
#' Adds .gitlab-ci.yml (if repo contains a "docs" subfolder)
#' @return writes .gitlab-ci.yml and adds it .Rbuildignore
#' @importFrom yaml as.yaml
#' @importFrom fs file_exists
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


write_to_rbuildignore(ignore_pattern = "^.gitlab-ci\\.yml$")
} else {
 warning("No 'docs' folder, no .gitlab-ci.yml created!")
}
}

