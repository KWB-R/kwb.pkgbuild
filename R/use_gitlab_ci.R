#' @keywords internal
#' @noRd
gitlab_ci_template_docs <- function() {

  list("pages" = list(script = list("mv docs public"),
                      artifacts = list(paths = list("public")),
                      only = list("master")))

}

#' @keywords internal
#' @noRd
gitlab_ci_template_ghpages <- function() {

  list("pages" = list(stage = "deploy",
                      script = list("mkdir .public",
                                    "cp -r * .public",
                                    "mv .public public"),
                      artifacts = list(paths = list("public")),
                      only = list("gh-pages")))

}


# use_gitlab_ci_docs -----------------------------------------------------------
#' Adds .gitlab-ci.yml (if repo contains a "docs" subfolder)
#' @param dest_dir directoy to write (default:
#' getwd())
#' @param yml_list a valid yml list (default: gitlab_ci_template_docs())
#' @return writes .gitlab-ci.yml and adds it .Rbuildignore
#' @importFrom yaml as.yaml
#' @importFrom fs file_exists
#' @export

use_gitlab_ci_docs <- function(dest_dir = getwd(),
                               yml_list = gitlab_ci_template_docs()) {


if(dir.exists("docs")) {
  writeLines(text = yaml::as.yaml(yml_list),
             con =  file.path(dest_dir, ".gitlab-ci.yml"))


write_to_rbuildignore(ignore_pattern = "^.gitlab-ci\\.yml$")
} else {
 warning("No 'docs' folder, no .gitlab-ci.yml created!")
}
}

# use_gitlab_ci_ghpages---------------------------------------------------------
#' Adds .gitlab-ci.yml (if repo contains on root in a "gh-pages" branch)
#' @param dest_dir directoy to write (default:
#' getwd())
#' @param yml_list a valid yml list (default: gitlab_ci_template_ghpages())
#' @return writes .gitlab-ci.yml and adds it .Rbuildignore
#' @importFrom yaml as.yaml
#' @importFrom fs file_exists
#' @export

use_gitlab_ci_ghpages <- function(dest_dir = getwd(),
                                  yml_list = gitlab_ci_template_ghpages()) {


    writeLines(text = yaml::as.yaml(yml_list),
               con =  file.path(dest_dir, ".gitlab-ci.yml"))

}

