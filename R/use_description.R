#' use_description with KWB styling
#'
#' @param author author information in list format (default:
#' list(name = "Michael Rustler", orcid = "0000-0003-0647-7726",
#' url = "http://mrustl.de"))
#' @param pkg package description in list format (default:\cr
#' pkg = list(name = "kwb.lca",\cr
#' title = "R package supporting UMERTO LCA at KWB",\cr
#' desc = "Helper functions for data aggregation and visualisation of\cr
#' UMBERTO (https://www.ifu.com/umberto/) model output"))
#' @param version user defined version number (e.g. 0.1.0) or default version
#' number 0.0.0.9000 in case (version = NULL) of first release
#' @param license license (default: "MIT + file LICENSE")
#' @param copyright_holder_name name of copyright holder
#' (default: "Kompetenzzentrum Wasser Berlin gGmbH (KWB)")
#' @param funder funder/funding agengy of R package (default: NULL), e.g. project
#' name (e.g. AQUANES)
#' @return writes DESCRIPTION file using usethis::use_description() with KWB
#' style
#' @importFrom usethis use_description
#' @importFrom stringr str_split
#' @export
use_description <- function(author = list(name = "Michael Rustler",
 orcid = "0000-0003-0647-7726",
 url = "http://mrustl.de"),
 pkg = list(name = "kwb.lca",
 title = "R package supporting UMERTO LCA at KWB",
 desc = paste0("Helper functions for data aggregation and visualisation",
 " of UMBERTO (https://www.ifu.com/umberto/) model output.")),
 version = NULL,
 license = "MIT + file LICENSE",
copyright_holder_name = "Kompetenzzentrum Wasser Berlin gGmbH (KWB)",
                     funder = NULL) {

  if(is.null(version)) {
    version <- "0.0.0.9000"
    cat(sprintf("No version specified. Using default initial version %s\n", version))
  }
firstname_surname <- stringr::str_split(string = author$name,pattern = "\\s+")[[1]]
author_name <- firstname_surname[1]
author_surname <- firstname_surname[2]


author_email <- sprintf('%s.%s@kompetenz-wasser.de',
                        tolower(author_name),
                        tolower(author_surname))

if(is.null(author$orcid)) {
  author_comment <- "NULL"
} else {
  author_comment <- sprintf('c(ORCID = "%s")', author$orcid)
}

desc_author <- sprintf('person("%s", "%s", , "%s",
           role = c("aut", "cre"), comment = %s)',
                  author_name,
                  author_surname,
                  author_email,
                  author_comment)

desc_copyright_holder <- sprintf('person("%s", role = c("cph"))', copyright_holder_name)


authors_meta <- sprintf('%s,
           %s', desc_author, desc_copyright_holder)

if (!is.null(funder)) {
  desc_funder <- sprintf('person("%s", role = c("fnd"))',funder)
  authors_meta <-sprintf("%s,
            %s", authors_meta, desc_funder)
}

authors_meta <- sprintf("c(%s)", authors_meta)


options(
  usethis.name = author$name,
  usethis.description = list(
  Package = pkg$name,
  Title = pkg$title,
  Description = pkg$desc,
  `Authors@R` = authors_meta,
  License = license,
  Version = version,
  URL = sprintf("https://github.com/KWB-R/%s", pkg$name),
  BugReports = sprintf("https://github.com/KWB-R/%s/issues", pkg$name)
)
)

cat("Creating KWB DESCRIPTION file....\n")
usethis::use_description(fields = NULL)
cat("Creating DESCRIPTION file....done.\n")

}

