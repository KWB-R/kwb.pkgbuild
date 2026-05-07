# read_description -------------------------------------------------------------

#' Helper: read selected fields from a `DESCRIPTION` file
#'
#' @param file path to DESCRIPTION file (default: "DESCRIPTION")
#' @importFrom desc desc
#' @return list with elements `name`, `title`, `desc`, `version`
#' @keywords internal
#' @noRd

read_description <- function(file = "DESCRIPTION")
{
  if (! file.exists(file)) clean_stop(
    sprintf("DESCRIPTION file not found at: %s.\n", file.path(getwd(), file)),
    "Please set working directory with function setwd() properly!"
  )

  description <- desc::desc(file)

  pkg <- as.list(stats::setNames(
    description$get(keys = c("Package", "Title", "Description", "Version")),
    nm = c("name", "title", "desc", "version")
  ))

  remove_space_after_eol <- function(x) gsub("\n\\s+", "\n", x)

  pkg$title <- remove_space_after_eol(pkg$title)
  pkg$desc <- remove_space_after_eol(pkg$desc)

  pkg
}
