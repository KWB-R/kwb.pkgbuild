if (FALSE)
{
  token <- Sys.getenv("GITHUB_PAT")

  repo <- "wasserportal"
  #workflow <- "R-CMD-check.yaml"
  #workflow <- "pkgdown.yaml"

  # Get link to last page of runs  
  url_link <- url_runs(repo, workflow) %>%
    get_response(token) %>%
    get_link_to_last()
  
  url_link
  
  urls_last_runs <- url_link %>%
    get_response(token) %>%
    httr::content("parsed") %>%
    kwb.utils::selectElements("workflow_runs") %>% 
    sapply(kwb.utils::selectElements, "url")
  
  urls_last_runs
  
  delete_runs(urls_last_runs, token)
}

`%>%` <- magrittr::`%>%`

# url_runs ---------------------------------------------------------------------
url_runs <- function(repo, workflow)
{
  sprintf(
    "https://api.github.com/repos/kwb-r/%s/actions/workflows/%s/runs",
    repo,
    workflow
  )
}

# get_response -----------------------------------------------------------------
get_response <- function(url, token)
{
  httr::GET(url, headers = list(
    Authorization = paste("token", token)
  ))
}

# get_link_to_last -------------------------------------------------------------
get_link_to_last <- function(response)
{
  links <- response %>%
    httr::headers() %>%
    kwb.utils::selectElements("link") %>%
    strsplit(",") %>%
    `[[`(1L)
  
  link <- grep("rel=\"last\"", links, value = TRUE)
  
  gsub("^\\s*<|>;.*$", "", link)
}

# delete_runs ------------------------------------------------------------------
delete_runs <- function(urls, token)
{
  sapply(urls, function(url) {
    
    response <- kwb.utils::catAndRun(
      paste("DELETE", url),
      httr::DELETE(
        url, 
        httr::add_headers(
          Authorization = paste0("token ", token)
        )
      )
    )
    
    httr::status_code(response)
  })
}
