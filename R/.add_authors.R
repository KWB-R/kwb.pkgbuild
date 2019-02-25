library(magrittr)

#' Helper Function: Create Author Metadata From ORCIDs
#' @param orcids named character vector with ORCIDs and names correspondig to
#' to "given_name family name" (defaults: kwb.orcid::get_kwb_orcids())
#' @importFrom kwb.orcid get_kwb_orcids
#' @importFrom stringr str_trim str_split
#' @importFrom magrittr %>%
#' @return data frame with required metadata for R package DESCRIPTION as
#' required by desc::desc_add_author()
#' @export
create_author_metadata_from_orcid <- function(
  orcids = kwb.orcid::get_kwb_orcids()) {

orc_ids <- orcids[order(orcids)]
orc_names <- names(orcids)

orc_names_matrix <- orc_names %>%
  stringr::str_trim() %>%
  stringr::str_split(pattern = "\\s+", simplify = TRUE, n = 2)


data.frame(given = orc_names_matrix[,1],
           family = orc_names_matrix[,2],
           email = sprintf("%s.%s@kompetenz-wasser.de",
                          tolower(orc_names_matrix[,1]),
                          tolower(orc_names_matrix[,2])),
           orcid = orc_ids,
           stringsAsFactors = FALSE,
           row.names = NULL
           )
}

#' Convert Author Metadata To List
#'
#' @param author_metadata_df data.frame as retrieved by
#' create_author_metadata_from_orcid()
#' @return transposed data.frame to list with "family_given" names for list
#' subsetting
#' @export
#' @importFrom purrr transpose
convert_author_metadata_tolist <- function(
  author_metadata_df = create_author_metadata_from_orcid()) {

list_names <- sprintf("%s_%s",
                      author_metadata_df$family,
                      author_metadata_df$given)


setNames(purrr::transpose(author_metadata_df),
         list_names)
}




#' Use Authors
#'
#' @param df data.frame (as retrieved by create_author_metadata_from_orcid()
#' or list (as retrieved by convert_author_metadata_tolist()) with metadata
#' for one author
#' @param role role (default: "ctb" -> contributor)
#' @param path path to folder containing DESCRIPTION (default: getwd())
#' @return adds author(s) with 'role' to DESCRIPTION
#' @export
#' @importFrom data.table rbindlist
#' @examples
#' \dontrun{
#' authors_df <- create_author_metadata_from_orcid()
#' condition <- authors_df$family %in% c("Rustler","Sonnenberg")
#' sel_authors <- authors_df[condition,]
#' ## add author(s) with default role "ctb" (contributor)
#' add_authors(sel_authors)
#' ### or provide a list
#' authors_list <- convert_author_metadata_tolist(authors_df)
#' sel_author <- authors_list$Rustler_Michael
#' add_authors(sel_author)
#' }
add_authors <- function(author_meta, role = "ctb", path = getwd()) {


  if(length(unlist(author_meta))) {
    df <- as.data.frame(author_meta)
  } else if (is.list(author_meta)) {
    df  <- author_meta %>%
      data.table::rbindlist() %>%
      as.data.frame()
  }


  if(!"role" %in% names(df)) {
    df$role = role
  }


  for(i in seq_len(nrow(df))) {
    sel_author_meta <- df[i,]

    if(sel_author_meta$orcid!="") {
      sel_author_meta$comment <- c("comment" = sel_author_meta$orcid)
    } else {
      sel_auth_meta$comment <- ""
    }
    print(sprintf("Adding '%s, %s' (ORCID: %s, Email: %s) with role '%s' to DESCRIPTION",
                  sel_author_meta$family,
                  sel_author_meta$given,
                  sel_author_meta$orcid,
                  sel_author_meta$email,
                  sel_author_meta$role))
    desc::desc_add_author(given = sel_author_meta$given,
                          family = sel_author_meta$family,
                          email = sel_author_meta$email,
                          role = sel_author_meta$role,
                          comment = c("comment" = sel_author_meta$orcid),
                          file = file.path(path, "DESCRIPTION"))
  }
}



