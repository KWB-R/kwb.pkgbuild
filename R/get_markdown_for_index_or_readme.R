# get_markdown_for_index_or_readme ---------------------------------------------

#' @importFrom kwb.utils selectElements
get_markdown_for_index_or_readme <- function(
    is_readme,
    user = "KWB-R",
    domain = "github",
    stage = "experimental"
)
{
  pkg <- read_description()

  name <- kwb.utils::selectElements(pkg, "name")

  doc_lines <- if (is_readme) {
    markdown_documentation_links(user, domain, name = name)
  }

  title_lines <- if (is_readme) {
    c("", sprintf("# %s", pkg$name))
  }

  c(
    use_badge_ghactions(name, user),
    use_badge_codecov(name, user, domain),
    use_badge_lifecycle(stage),
    use_badge_cran(name),
    use_badge_runiverse(name),
    title_lines,
    "",
    pkg$desc,
    "",
    use_installation(name, user, domain),
    doc_lines
  )
}

# markdown_documentation_links -------------------------------------------------
markdown_documentation_links <- function(user, domain, name)
{
  url_release <- sprintf(
    "https://%s.%s.io/%s",
    tolower(user),
    tolower(domain),
    tolower(name)
  )

  c(
    "",
    "## Documentation",
    "",
    paste("Release:", markdown_link(url_release)),
    "",
    paste("Development:", markdown_link(paste0(url_release, "/dev")))
  )
}

# markdown_link ----------------------------------------------------------------
markdown_link <- function(x)
{
  sprintf("[%s](%s)", x, x)
}
