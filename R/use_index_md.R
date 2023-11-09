# use_index_md ----------------------------------------------------------------

#' Use index.md (used for pkgdown::build_home())
#' @param user user name or organisation under which repository defined in\cr
#' parameter "repo" is hosted (default: "KWB-R")\cr
#' @param domain under which repository is hosted (default: "github")
#' @param stage badge declares the developmental stage of a package, according
#' to [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#' valid arguments are: "experimental", "maturing", "stable", "retired",
#' "archived", "dormant", "questioning"), (default: "experiment")
#' @return generates travis badge link
#' @export
#' @importFrom desc desc

use_index_md <- function(
    user = "KWB-R",
    domain = "github",
    stage = "experimental"
)
{
  content <- get_markdown_for_index_or_readme(
    is_readme = FALSE,
    user = user,
    domain = domain,
    stage = stage
  )

  writeLines(content, "index.md")
  write_to_rbuildignore(ignore_pattern = "^index\\.md$")

  content
}
