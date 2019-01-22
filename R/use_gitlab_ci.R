#' @keywords internal
#' @noRd
gitlab_ci_template_docs <- function() {

  docs_yml <- system.file("templates/gitlab_ci_template_docs.yml",
                             package = "kwb.pkgbuild")

  yaml::read_yaml(docs_yml)

}

#' @keywords internal
#' @noRd
gitlab_ci_template_ghpages <- function() {

  ghpages_yml <- system.file("templates/gitlab_ci_template_ghpages.yml",
                             package = "kwb.pkgbuild")

  yaml::read_yaml(ghpages_yml)

}

#' @keywords internal
#' @noRd
gitlab_ci_template_pkgdown <- function() {

  pkgdown_yml <- system.file("templates/gitlab_ci_template_pkgdown.yml",
                              package = "kwb.pkgbuild")

  yaml::read_yaml(pkgdown_yml)

}


#' @keywords internal
#' @noRd
#' @importFrom yaml read_yaml
gitlab_ci_template_blogdown <- function() {

 blogdown_yml <- system.file("templates/gitlab_ci_template_blogdown.yml",
             package = "kwb.pkgbuild")

 yaml::read_yaml(blogdown_yml)

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
#' Adds .gitlab-ci.yml (which should be saved in root dir of "gh-pages" branch)
#' @param dest_dir directoy to write (default:
#' getwd())
#' @param yml_list a valid yml list (default: gitlab_ci_template_ghpages())
#' @return writes .gitlab-ci.yml
#' @importFrom yaml as.yaml
#' @importFrom fs file_exists
#' @export

use_gitlab_ci_ghpages <- function(dest_dir = getwd(),
                                  yml_list = gitlab_ci_template_ghpages()) {


    writeLines(text = yaml::as.yaml(yml_list),
               con =  file.path(dest_dir, ".gitlab-ci.yml"))

}

# use_gitlab_ci_blogdown--------------------------------------------------------
#' Adds .gitlab-ci.yml (if repo contains on root in a "gh-pages" branch)
#' @param dest_dir directoy to write (default:
#' getwd())
#' @param yml_list a valid yml list (default: gitlab_ci_template_blogdown())
#' @return writes .gitlab-ci.yml
#' @importFrom yaml as.yaml
#' @importFrom fs file_exists
#' @export

use_gitlab_ci_blogdown <- function(dest_dir = getwd(),
                                  yml_list = gitlab_ci_template_blogdown()) {


  writeLines(text = yaml::as.yaml(yml_list),
             con =  file.path(dest_dir, ".gitlab-ci.yml"))

  write_to_rbuildignore(ignore_pattern = "^.gitlab-ci\\.yml$")

}

# use_gitlab_ci_pkgdown--------------------------------------------------------
#' Adds .gitlab-ci.yml
#' @param dest_dir directoy to write (default:
#' getwd())
#' @param yml_list a valid yml list (default: gitlab_ci_template_pkgdown(),
#' where "<owner>/<repo>" is replaced with value from DESCRIPTION specified in
#' field URL, e.g. https://github.com/KWB-R/kwb.pkgbuild" sets
#' "KWB-R/kwb.pkgbuild" as "<owner>/<repo>")
#' @return writes .gitlab-ci.yml
#' @importFrom yaml as.yaml
#' @importFrom stringr str_remove
#' @importFrom desc desc_get
#' @export

use_gitlab_ci_pkgdown <- function(dest_dir = getwd(),
                                  yml_list = gitlab_ci_template_pkgdown()) {


  owner_repo <- stringr::str_remove(desc::desc_get("URL"),
                                   "^http(s)?://github.com/")

  yml_list[["before_script"]] <- stringr::str_replace(yml_list[["before_script"]],
                       pattern = "<owner>/<repo>",
                       replacement = owner_repo)



  writeLines(text = yaml::as.yaml(yml_list),
             con =  file.path(dest_dir, ".gitlab-ci.yml"))

  write_to_rbuildignore(ignore_pattern = "^.gitlab-ci\\.yml$")

}
