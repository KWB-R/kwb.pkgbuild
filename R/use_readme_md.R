# use_readme_md ----------------------------------------------------------------

#' Create KWB-styled `README.md`
#'
#' Generates a `README.md` with the KWB default badge set, the package
#' description from `DESCRIPTION`, an installation snippet and links to the
#' release and development documentation websites.
#'
#' @param user user name or organisation under which the repository is hosted
#'   (default: "KWB-R")
#' @param domain under which the repository is hosted (default: "github")
#' @param stage badge declaring the developmental stage of the package
#'   according to
#'   [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/);
#'   valid values are "experimental", "maturing", "stable", "retired",
#'   "archived", "dormant", "questioning" (default: "experimental")
#' @return writes `README.md` and adds it to `.Rbuildignore`
#' @export
#' @importFrom desc desc

use_readme_md <- function(
  user = "KWB-R",
  domain = "github",
  stage = "experimental"
)
{
  pkg <- read_description()

  docu_release <- sprintf(
    "https://%s.%s.io/%s",
    tolower(user), tolower(domain), tolower(pkg$name)
  )

  docu_dev <- sprintf("%s/dev", docu_release)

  readme_md <- c(
    use_badge_ghactions(pkg$name, user),
    use_badge_codecov(pkg$name, user, domain ),
    use_badge_lifecycle(stage),
    use_badge_cran(pkg$name),
    use_badge_runiverse(pkg$name),
    "",
    sprintf("# %s", pkg$name),
    "",
    pkg$desc,
    "",
    use_installation(pkg$name, user, domain),
    "",
    "## Documentation",
    "",
    sprintf("Release: [%s](%s)", docu_release, docu_release),
    "",
    sprintf("Development: [%s](%s)", docu_dev, docu_dev)
  )

  writeLines(readme_md, "README.md")

  write_to_rbuildignore(ignore_pattern = "^README\\.md$")
}
