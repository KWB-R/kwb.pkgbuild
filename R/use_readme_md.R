# use_readme_md ----------------------------------------------------------------

#' Use README
#' @param user user name or organisation under which repository defined in\cr
#' parameter "repo" is hosted (default: "KWB-R")\cr
#' @param domain under which repository is hosted (default: "github")
#' @param stage badge declares the developmental stage of a package, according
#' to [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#' valid arguments are: "experimental", "maturing", "stable", "retired",
#' "archived", "dormant", "questioning"), (default: "experiment")
#' @return generates README.md
#' @export
#' @importFrom desc desc

use_readme_md <- function(
    user = "KWB-R",
    domain = "github",
    stage = "experimental"
)
{
  content <- get_markdown_for_index_or_readme(
    is_readme = TRUE,
    user = user,
    domain = domain,
    stage = stage
  )

  writeLines(content, "README.md")
  write_to_rbuildignore(ignore_pattern = "^README\\.md$")
}
