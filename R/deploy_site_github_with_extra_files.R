# deploy_site_github_with_extra_files ------------------------------------------

#' deploy_site_github_with_extra_files
#'
#' @description for details see pkgdown::deploy_site_github(), only parameter
#' vignettes_file_pattern_to_copy added
#' @param pkg "."
#' @param vignettes_file_pattern_to_copy  file patern for copying files from
#' vignettes directory into deploy directory (default: "\\.json$")
#' @param tarball tarball Sys.getenv("PKG_TARBALL", "")
#' @param ssh_id ssh_id Sys.getenv("id_rsa", "")
#' @param repo_slug repo_slug Sys.getenv("TRAVIS_REPO_SLUG", "")
#' @param commit_message commit_message pkgdown:::construct_commit_message(pkg)
#' @param verbose verbose (default: TRUE)
#' @param ... additional arguments passed to deploy_local_with_extra_files()
#' @return deploy pkgdown site including additional files in "vignettes" source
#' folder to "gh-pages"
#' @export
#' @importFrom fs dir_create file_temp dir_delete file_chmod
#' @importFrom rematch2 re_match
#' @importFrom pkgdown build_site
#' @importFrom callr rcmd
#' @importFrom openssl base64_decode
deploy_site_github_with_extra_files <- function(
  pkg = ".",
  vignettes_file_pattern_to_copy = "\\.json$",
  tarball = Sys.getenv("PKG_TARBALL", ""),
  ssh_id = Sys.getenv("id_rsa", ""),
  repo_slug = Sys.getenv("TRAVIS_REPO_SLUG", ""),
  commit_message = pkgdown:::construct_commit_message(pkg),
  verbose = TRUE,
  ...
)
{
  stop_if_missing <- function(x, ...) if (! nzchar(x)) clean_stop(...)

  stop_if_missing(
    tarball, "No built tarball detected, please provide the location of one ",
    "with `tarball`"
  )

  stop_if_missing(
    ssh_id, "No deploy key found, please setup with ",
    "`travis::use_travis_deploy()`"
  )

  stop_if_missing(
    repo_slug, "No repo detected, please supply one with `repo_slug`"
  )

  pkgdown:::rule("Deploying site", line = 2)

  pkgdown:::rule("Installing package", line = 1)

  callr::rcmd("INSTALL", tarball, show = verbose, fail_on_status = TRUE)

  ssh_id_file <- "~/.ssh/id_rsa"

  pkgdown:::rule("Setting up SSH id", line = 1)

  pkgdown:::cat_line("Copying private key to: ", ssh_id_file)

  pkgdown:::write_lines(rawToChar(openssl::base64_decode(ssh_id)), ssh_id_file)

  pkgdown:::cat_line("Setting private key permissions to 0600")

  fs::file_chmod(ssh_id_file, "0600")

  deploy_local_with_extra_files(
    pkg, vignettes_file_pattern_to_copy, repo_slug = repo_slug,
    commit_message = commit_message, ...
  )

  pkgdown:::rule("Deploy completed", line = 2)
}

# deploy_local_with_extra_files ------------------------------------------------

#' deploy_local_with_extra_files
#'
#' @description for details see pkgdown::deploy_local(), only parameter
#' vignettes_file_pattern_to_copy added
#' @param pkg "."
#' @param vignettes_file_pattern_to_copy  file patern for copying files from
#' vignettes directory into deploy directory (default: "\\.json$")
#' @param repo_slug repo_slug Sys.getenv("TRAVIS_REPO_SLUG", "")
#' @param commit_message commit_message pkgdown:::construct_commit_message(pkg)
#' @param ... additional arguments passed to  pkgdown::build_site()
#' @return deploy pkgdown site including additional files in "vignettes" source
#' folder to "gh-pages"
#' @export
#' @importFrom fs dir_create file_temp dir_delete dir_ls file_copy
#' @importFrom rematch2 re_match
#' @importFrom  pkgdown build_site as_pkgdown

deploy_local_with_extra_files <- function(
  pkg = ".",
  vignettes_file_pattern_to_copy = "\\.json$",
  repo_slug = NULL,
  commit_message = pkgdown:::construct_commit_message(pkg),
  ...
)
{
  dest_dir <- fs::dir_create(fs::file_temp())
  pkg <- "."
  on.exit(fs::dir_delete(dest_dir))
  pkg <- pkgdown::as_pkgdown(pkg)

  if (is.null(repo_slug)) {
    gh <- rematch2::re_match(pkg$github_url, pkgdown:::github_url_rx())
    repo_slug <- paste0(gh$owner, "/", gh$repo)
  }

  pkgdown:::github_clone(dest_dir, repo_slug)

  pkgdown::build_site(
    ".", override = list(destination = dest_dir), devel = FALSE,
    preview = FALSE, ...
  )

  copy_files_from_vignettes_dir_to_deploy_dir(
    source_dir = pkg$src_path,
    deploy_dir = dest_dir,
    pattern = vignettes_file_pattern_to_copy,
    overwrite = TRUE
  )

  pkgdown:::github_push(dest_dir, commit_message)

  invisible()
}

# copy_files_from_vignettes_dir_to_deploy_dir ----------------------------------

#' Copy files from Vignettes Dir to Deploy idir
#'
#' @param source_dir default: "."
#' @param deploy_dir default: "docs
#' @param pattern file pattern to export (default: "\\.json$")
#' @param overwrite should existing files be overwritten (default: TRUE)
#' @return files matching pattern copied to deploy_dir
#' @export
#' @importFrom fs dir_ls file_copy
copy_files_from_vignettes_dir_to_deploy_dir <- function(
  source_dir = ".", deploy_dir = "docs", pattern = "\\.json$", overwrite = TRUE
)
{
  from <- fs::dir_ls(file.path(source_dir, "vignettes"), regexp = pattern)

  to <- file.path(deploy_dir, basename(from))

  fs::file_copy(from, to, overwrite = overwrite)
}
