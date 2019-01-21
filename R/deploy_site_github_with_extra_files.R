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
#' @importFrom fs dir_create file_temp dir_delete dir_ls file_copy file_chmod
#' @importFrom rematch2 re_match
#' @importFrom pkgdown build_site
#' @importFrom callr rcmd
#' @importFrom openssl base64_decode
deploy_site_github_with_extra_files <- function(pkg = ".",
                                                vignettes_file_pattern_to_copy = "\\.json$",
                                                tarball = Sys.getenv("PKG_TARBALL", ""),
                                                ssh_id = Sys.getenv("id_rsa", ""), repo_slug = Sys.getenv(
                                                  "TRAVIS_REPO_SLUG",
                                                  ""
                                                ),
                                                commit_message = pkgdown:::construct_commit_message(pkg),
                                                verbose = TRUE, ...) {
  if (!nzchar(tarball)) {
    stop("No built tarball detected, please provide the location of one with `tarball`",
         call. = FALSE
    )
  }
  if (!nzchar(ssh_id)) {
    stop("No deploy key found, please setup with `travis::use_travis_deploy()`",
         call. = FALSE
    )
  }
  if (!nzchar(repo_slug)) {
    stop("No repo detected, please supply one with `repo_slug`",
         call. = FALSE
    )
  }
  pkgdown:::rule("Deploying site", line = 2)
  pkgdown:::rule("Installing package", line = 1)
  callr::rcmd("INSTALL", tarball, show = verbose, fail_on_status = TRUE)
  ssh_id_file <- "~/.ssh/id_rsa"
  pkgdown:::rule("Setting up SSH id", line = 1)
  pkgdown:::cat_line("Copying private key to: ", ssh_id_file)
  pkgdown:::write_lines(rawToChar(openssl::base64_decode(ssh_id)), ssh_id_file)
  pkgdown:::cat_line("Setting private key permissions to 0600")
  fs::file_chmod(ssh_id_file, "0600")

  deploy_local_with_extra_files(pkg, vignettes_file_pattern_to_copy,
                                repo_slug = repo_slug, commit_message = commit_message,
                                ...
  )
  pkgdown:::rule("Deploy completed", line = 2)
}


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
#' @importFrom  pkgdown build_site

deploy_local_with_extra_files <- function(pkg = ".",
                                          vignettes_file_pattern_to_copy = "\\.json$",
                                          repo_slug = NULL,
                                          commit_message = pkgdown:::construct_commit_message(pkg),
                                          ...) {
  dest_dir <- fs::dir_create(fs::file_temp())
  pkg <- "."
  on.exit(fs::dir_delete(dest_dir))
  pkg <- pkgdown:::as_pkgdown(pkg)

  copy_files_from_vignettes_dir_to_deploy_dir <- function() {
    vig_dir <- file.path(pkg$src_path, "vignettes")
    src_filepaths <- fs::dir_ls(vig_dir,
                                regexp = vignettes_file_pattern_to_copy
    )
    dest_filepaths <- file.path(dest_dir, basename(src_filepaths))
    fs::file_copy(
      path = src_filepaths,
      new_path = dest_filepaths,
      overwrite = TRUE
    )
  }


  if (is.null(repo_slug)) {
    gh <- rematch2::re_match(pkg$github_url, pkgdown:::github_url_rx())
    repo_slug <- paste0(gh$owner, "/", gh$repo)
  }
  pkgdown:::github_clone(dest_dir, repo_slug)
  pkgdown::build_site(".",
                      override = list(destination = dest_dir),
                      document = FALSE, preview = FALSE, ...
  )
  copy_files_from_vignettes_dir_to_deploy_dir()

  pkgdown:::github_push(dest_dir, commit_message)
  invisible()
}
