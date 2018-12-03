#' Write to .Rbuildignore
#'
#' @param ignore_pattern pattern that should be added to .Rbuildignore
#' @return .Rbuildignore created/updated with pattern
#' @export
#' @importFrom fs file_exists
#'
write_to_rbuildignore <- function (ignore_pattern) {

  if (fs::file_exists(".Rbuildignore")) {
    ignored_files <- readLines(".Rbuildignore")


    has_pattern <- any(grepl(x = ignored_files, pattern = ignore_pattern,
                               fixed = TRUE))

    if (!   has_pattern ) {
      ignored_files <- append(x = ignored_files, values = ignore_pattern)
      writeLines(text = ignored_files,
                 con = ".Rbuildignore")
    }
  } else {
    writeLines(text = ignore_pattern,
               con = ".Rbuildignore")
  }
}

