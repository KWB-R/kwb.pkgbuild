# write_to_rbuildignore --------------------------------------------------------

#' Write to .Rbuildignore
#'
#' @param ignore_pattern pattern that should be added to .Rbuildignore
#' @param comment optional comment to write to file before the ignore pattern
#' (default: NULL)
#' @return .Rbuildignore created/updated with pattern
#' @export
#' @importFrom fs file_exists
#'
write_to_rbuildignore <- function(ignore_pattern, comment = NULL)
{
  write_ignorepattern_to_file(ignore_pattern, comment, file = ".Rbuildignore")
}

# write_to_gitignore -----------------------------------------------------------

#' Write to .gitignore
#'
#' @param ignore_pattern pattern that should be added to .Rbuildignore
#' @param comment optional comment to write to file before the ignore pattern
#' #' (default: NULL)
#' @return .gitignore created/updated with pattern
#' @export
#' @importFrom fs file_exists
#'
write_to_gitignore <- function(ignore_pattern, comment = NULL)
{
  write_ignorepattern_to_file(ignore_pattern, comment, file = ".gitignore")
}

#' Write ignore pattern to file
#'
#' @param ignore_pattern pattern that should be added to .Rbuildignore
#' @param comment optional comment to write to file before the ignore pattern
#' (default: NULL)
#' @param file path to file where to write
#' @keywords internal
#' @noRd
#' @importFrom fs file_exists
#'
write_ignorepattern_to_file <- function(ignore_pattern, comment = NULL, file)
{
  # If there is no file, write the pattern, prepended by the comment (if any)
  # to the file and return
  if (! fs::file_exists(file)) {
    writeLines(c(comment, ignore_pattern), file)
    return()
  }

  # File exists, read the file
  patterns <- readLines(file)

  # Return if the ignore pattern is already contained
  if (any(grepl(ignore_pattern, patterns, fixed = TRUE))) {
    return()
  }

  # Add comment (if any) and pattern to the existing patterns in the file
  writeLines(c(patterns, comment, ignore_pattern), file)
}
