#' Helper function: read_description
#'
#' @param file path to DESCRIPTION file (default: DESCRIPTION)
#' @importFrom desc desc
#' @return list with pkg "name", "title", "desc", "version"

read_description <- function(file = "DESCRIPTION") {

  if(file.exists(file)) {
  description <- desc::desc(file)
  desc_df <- description$get(keys = c("Package", "Title", "Description", "Version"))
  names(desc_df) <- c("name", "title", "desc", "version")
  pkg <- as.list(desc_df)
  pkg$title <- gsub(pattern = "\n\\s+", "\n", pkg$title)
  pkg$desc <- gsub(pattern = "\n\\s+", "\n", pkg$desc)
  return(pkg)
  } else {
stop(sprintf("DESCIPTION file not found at: %s.\n
   Please set working directory with function setwd() properly!",
file.path(getwd(), file)))
  }
}
