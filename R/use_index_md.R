# use_index_md ----------------------------------------------------------------

#' Create KWB-styled \code{index.md}
#'
#' Generates an \code{index.md} (used by \code{pkgdown::build_home()}) with the
#' KWB default badge set (GitHub Actions, codecov, lifecycle, CRAN, R-universe),
#' the package description from \code{DESCRIPTION} and an installation snippet.
#' @param user user name or organisation under which the repository is hosted
#'   (default: "KWB-R")
#' @param domain under which the repository is hosted (default: "github")
#' @param stage badge declaring the developmental stage of the package
#'   according to
#'   [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/);
#'   valid values are "experimental", "maturing", "stable", "retired",
#'   "archived", "dormant", "questioning" (default: "experimental")
#' @return writes \code{index.md} (used as `pkgdown` home) and adds the
#'   pattern to \code{.Rbuildignore}. Invisibly returns the character vector
#'   that was written.
#' @export
#' @importFrom desc desc

use_index_md <- function(
  user = "KWB-R", domain = "github", stage = "experimental"
)
{
  pkg <- read_description()

  index_md <- c(
    use_badge_ghactions(pkg$name, user),
    use_badge_codecov(pkg$name, user, domain ),
    use_badge_lifecycle(stage),
    use_badge_cran(pkg$name),
    use_badge_runiverse(pkg$name),
    "",
    pkg$desc,
    "",
    use_installation(pkg$name, user, domain)
  )

  writeLines(index_md, "index.md")

  write_to_rbuildignore(ignore_pattern = "^index\\.md$")

  index_md
}
