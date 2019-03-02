# read_description -------------------------------------------------------------

#' Helper function: read_description
#'
#' @param file path to DESCRIPTION file (default: DESCRIPTION)
#' @importFrom desc desc
#' @return list with pkg "name", "title", "desc", "version"

read_description <- function(file = "DESCRIPTION")
{
  if (! file.exists(file)) clean_stop(
    sprintf("DESCIPTION file not found at: %s.\n", file.path(getwd(), file)),
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
