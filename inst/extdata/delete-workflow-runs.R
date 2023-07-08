if (FALSE)
{
  run_info <- get_info_on_last_workflow_runs(
    repo = "status",
    per_page = 100L,
    "name"
  )

  nrow(run_info)

  range(run_info$run_started_at)

  delete_runs(urls = run_info$url)
}

`%>%` <- magrittr::`%>%`

# get_info_on_last_workflow_runs -----------------------------------------------
get_info_on_last_workflow_runs <- function(repo, per_page = 30L, ...)
{
  result <- get_workflow_runs(repo)

  page <- last_page(result$total_count, per_page)

  result <- get_workflow_runs(repo, per_page = per_page, page = page)

  x <- result$workflow_runs

  stopifnot(length(x) <= per_page)

  do.call(rbind, lapply(x, function(xx) {
    as.data.frame(kwb.utils::selectElements(xx, c(
      "url",
      "run_started_at",
      "status",
      ...
    )))
  }))
}

# get_workflow_runs ------------------------------------------------------------
get_workflow_runs <- function(repo, per_page = 30L, page = 1L)
{
  endpoints <- list(
    runs = "<api>/repos/<owner>/<repo>/actions/runs?<runs_pars>",
    runs_pars = "per_page=<per_page>&page=<page>",
    api = "https://api.github.com",
    owner = "KWB-R"
  )

  # List workflow runs for a repository
  response <- get_response(
    url = kwb.utils::resolve(
      "runs",
      endpoints,
      repo = repo,
      per_page = per_page,
      page = page
    )
  )

  httr::content(response)
}

# get_response -----------------------------------------------------------------
get_response <- function(url, token = github_token(), ...)
{
  httr::GET(url, headers = create_header(token, ...))
}

# github_token -----------------------------------------------------------------
github_token <- function()
{
  Sys.getenv("GITHUB_PAT")
}

# create_header ----------------------------------------------------------------
create_header <- function(token, ...)
{
  list(
    Authorization = paste("token", token),
    ...
  )
}

# last_page --------------------------------------------------------------------
last_page <- function(n_runs, per_page)
{
  ((n_runs - 1L) %/% per_page) + 1L
}

# delete_runs ------------------------------------------------------------------
delete_runs <- function(urls, token = github_token())
{
  invisible(sapply(seq_along(urls), function(i) {

    url <- urls[i]

    kwb.utils::catAndRun(
      sprintf("Deleting %d/%d: %s ", i, length(urls), url),
      expr = {
        config <- do.call(httr::add_headers, create_header(token))
        response <- httr::DELETE(url, config)
        if (httr::status_code(response) != 204L) {
          print(response)
          stop("DELETE failed.")
        }
      }
    )
  }))
}
