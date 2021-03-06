# use_description --------------------------------------------------------------

#' Use DESCRIPTION with KWB styling
#'
#' @param author author information in list format (default:
#'   kwb.pkgbuild:::kwb_author("rustler"))
#' @param pkg package description in list format (default:
#'   kwb.pkgbuild:::kwb_package("kwb.umberto"))
#' @param version user defined version number (e.g. 0.1.0) or default version
#'   number 0.0.0.9000 in case (version = NULL) of first release
#' @param license license (default: "MIT + file LICENSE")
#' @param copyright_holder_name name of copyright holder (default:
#'   kwb.pkgbuild:::kwb_string())
#' @param funder funder/funding agency of R package (default: NULL), e.g.
#'   project name (e.g. AQUANES)
#' @return writes DESCRIPTION file using usethis::use_description() with KWB
#'   style
#' @importFrom usethis use_description
#' @importFrom stringr str_split
#' @importFrom tools toTitleCase
#' @export
use_description <- function(
  author = kwb_author("rustler"),
  pkg = kwb_package("kwb.umberto"),
  version = NULL,
  license = "MIT + file LICENSE",
  copyright_holder_name = kwb_string(),
  funder = NULL
)
{
  if (is.null(version)) {
    version <- "0.0.0.9000"
    cat(sprintf(
      "No version specified. Using default initial version %s\n", version
    ))
  }

  pkg$title <- tools::toTitleCase(pkg$title)

  full_name <- stringr::str_split(string = author$name,pattern = "\\s+")[[1]]
  author_name <- full_name[1]
  author_surname <- full_name[2]

  author_email <- sprintf(
    '%s.%s@kompetenz-wasser.de', tolower(author_name), tolower(author_surname)
  )

  author_comment <- if (is.null(author$orcid)) {
    "NULL"
  } else {
    sprintf('c(ORCID = "%s")', author$orcid)
  }

  desc_author <- sprintf(
    'person("%s", "%s", , "%s",\n      role = c("aut", "cre"), comment = %s)',
    author_name, author_surname, author_email, author_comment
  )

  desc_copyright_holder <- sprintf(
    'person("%s", role = c("cph"))', copyright_holder_name
  )

  authors_meta <- sprintf('%s,\n      %s', desc_author, desc_copyright_holder)

  if (! is.null(funder)) {
    desc_funder <- sprintf('person("%s", role = c("fnd"))', funder)
    authors_meta <-sprintf("%s,\n      %s", authors_meta, desc_funder)
  }

  authors_meta <- sprintf("c(%s)", authors_meta)

  url <- "https://github.com/KWB-R"

  options(
    usethis.name = author$name,
    usethis.description = list(
      Package = pkg$name,
      Title = pkg$title,
      Description = pkg$desc,
      `Authors@R` = authors_meta,
      License = license,
      Version = version,
      URL = sprintf("%s/%s", url, pkg$name),
      BugReports = sprintf("%s/%s/issues", url, pkg$name)
    )
  )

  kwb.utils::catAndRun("Creating KWB DESCRIPTION file", {
    usethis::use_description(fields = NULL)
  })
}
