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
write_ignorepattern_to_file <- function(ignore_pattern, comment = NULL, file) {

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

#' Write to .Rbuildignore
#'
#' @param ignore_pattern pattern that should be added to .Rbuildignore
#' @param comment optional comment to write to file before the ignore pattern
#' (default: NULL)
#' @return .Rbuildignore created/updated with pattern
#' @export
#' @importFrom fs file_exists
#'
write_to_rbuildignore <- function(ignore_pattern, comment = NULL) {

  write_ignorepattern_to_file(ignore_pattern, comment, file = ".Rbuildignore")
}

#' Write to .gitignore
#'
#' @param ignore_pattern pattern that should be added to .Rbuildignore
#' @param comment optional comment to write to file before the ignore pattern
#' #' (default: NULL)
#' @return .gitignore created/updated with pattern
#' @export
#' @importFrom fs file_exists
#'
write_to_gitignore <- function(ignore_pattern, comment = NULL) {

  write_ignorepattern_to_file(ignore_pattern, comment, file = ".gitignore")
}

#' Helper Function: Get Package Name
#'
#' @param pkgname either package name or NULL. In this
#' case the DESCRIPTION file in the current working
#' directory is read and is package name ues (default: NULL)
#'
#' @return package name
#' @export

get_pkgname <- function(pkgname = NULL) {

  # Return the package name if it was given
  if (! is.null(pkgname)) {
    return(pkgname)
  }

  if (! file.exists("DESCRIPTION")) stop(
    "No pkgname defined and no 'DESCRIPTION' file for deriving package name ",
    "found", call. = FALSE
  )

  read_description()$name
}

#' Git Check if Windows
#'
#' @param git_exe path to Git executable on windows
#' @return git_exe provided (if os == "windows"), else: "git"
#' @keywords internal
#' @noRd
#'
git_check_if_windows <- function(git_exe) {

  # For non-Windows systems, assume that "git" is installed and on the PATH
  if (.Platform$OS.type != "windows") {

    return("git")
  }

  # .Platform$OS.type == "windows"
  if (! file.exists(git_exe)) {
    stop("GIT executable cannot be found: ", git_exe)
  }

  git_exe
}

#' Set Github User For GIT
#'
#' @param git_username Github username (default: "kwb.pkgbuild::use_autopkgdown()")
#' @param git_fullname Github fullname (default: "kwb.pkgbuild::use_autopkgdown()")
#' @param git_email (default: `kwbr-bot@kompetenz-wasser.de`), is then internally derived by calling
#' whoami::fullname() and assuming that Github "kompetenz-wasser.de" used as
#' email on Github
#' @param git_exe path git git executable (only used on Windows as it is not
#' installed in the local "environment"). On all other plattforms it is assumed
#' that a call with "git" works
#' @param execute should a batch file be run?
#' @param execute_dir path to directory where batch script should be run in case
#' that execute == TRUE (default: tempdir())
#' @param dbg print debug messages (default: TRUE)
#' @return sets globally user.name and user.email in Git
#' @export
#' @importFrom stringr str_replace
set_github_user <- function(
  git_username = "kwb.pkgbuild::use_autopkgdown()",
  git_fullname = "kwb.pkgbuild::use_autopkgdown()",
  git_email = "kwbr-bot@kompetenz-wasser.de",
  git_exe = "C:/Program Files/Git/bin/git.exe",
  execute = FALSE,
  execute_dir = tempdir(),
  dbg = TRUE
) {

  if (is.null(git_email)) {

    # Replace space with dot
    dot_name <- stringr::str_replace(git_fullname, "\\s+", ".")

    # Compose KWB e-mail address
    git_email <- paste0(tolower(dot_name), "@kompetenz-wasser.de")
  }

  git_exe <- git_check_if_windows(git_exe)

  set_global_config_command <- function(name, value) sprintf(
    '"%s" config --global %s %s', git_exe, name, value
  )

  cmd_gitconfig <- c(
    set_global_config_command("user.name", git_username),
    set_global_config_command("user.email", git_email)
  )

  kwb.utils::catIf(dbg, paste0("Setting GIT user:\n", cmd_gitconfig))

  # Do not execute but only return the command string if execute is FALSE
  if (! execute) {
    return(cmd_gitconfig)
  }

  filename <- sprintf("set_github_user_%s.bat", git_username)
  file <- file.path(execute_dir, filename)

  writeLines(cmd_gitconfig, file)

  kwb.utils::catAndRun(dbg = dbg, paste("Running:", file), {
    system(command = file)
  })
}

#' @noRd
#' @keywords internal
write_git_batch_and_execute <- function(cmd,
                                        set_githubuser = TRUE,
                                        bat_name = sprintf("%s.bat",
                                                           basename(tempfile())),
                                        dest_dir,
                                        git_exe,
                                        execute = TRUE,
                                        dbg = TRUE, ...) {
  if (set_githubuser) {
    git_usermeta <- set_github_user(git_exe = git_exe, dbg = dbg, ...)

    cmd <- c(git_usermeta,  cmd)
  }


  bat_path <- file.path(dest_dir, bat_name)

  if(dbg) {
    print(sprintf("Writing batch file: %s", bat_path))
  }
  writeLines(cmd, bat_path)
  if(execute) {
    if(dbg) {
      print(sprintf("Running batch file: %s", bat_path))
      system(bat_path)
    }
  }
}

#' Create Empty Branch From Github
#'
#' @param repo name of existing Github repository (default: NULL)
#' @param branch name of branch to be created (default: NULL)
#' @param org repo owner (default: "KWB-R")
#' @param set_githubuser should the Github user be set before executing the
#' branch creation (default: TRUE). In this case set_github_user() is run
#' @param git_exe path to GIT executable (default:
#' "C:/Program Files/Git/bin/git.exe"), only required on "windows". On all other
#' platforms it is assumed that "git" is sufficient!
#' @param dest_dir directory where the the repo should be checked out (default:
#' tempdir())
#' @param execute should a batch file be run?
#' @param dbg print debug messages (default: TRUE)
#' @param ... additional arguments passed to set_github_user
#' @return create empty branch (defined in 'branch') and push to org/repo on
#' Github
#' @export
#' @importFrom  fs dir_create
create_empty_branch <- function(
  repo = NULL,
  branch = NULL,
  org = "KWB-R",
  set_githubuser = TRUE,
  git_exe = "C:/Program Files/Git/bin/git.exe",
  dest_dir = tempdir(),
  execute = TRUE,
  dbg = TRUE,
  ...
) {

  if (is.null(repo)) {
    stop(
      "Specify the name of the repo to be checked out with parameter 'repo'",
      call. = FALSE
    )
  }

  if (is.null(branch)) {
    stop(
      "Specify the name of the branch to be created in parameter 'branch'",
      call. = FALSE
    )
  }

  git_exe <- git_check_if_windows(git_exe)

  fs::dir_create(dest_dir)

  cmd <- c(
    sprintf('cd "%s"', dest_dir),
    sprintf('"%s" clone https://github.com/%s/%s', git_exe, org, repo),
    sprintf('cd "%s"', repo),
    sprintf('"%s" checkout --orphan %s', git_exe, branch),
    sprintf('"%s" rm -rf .', git_exe),
    sprintf('"%s" commit --allow-empty -m "Initial gh-pages commit"', git_exe),
    sprintf('"%s" push origin %s', git_exe, branch),
    sprintf('"%s" checkout master', git_exe)
  )

  if (set_githubuser) {
    git_usermeta <- set_github_user(git_exe = git_exe, dbg = dbg, ...)
    cmd <- c(git_usermeta, cmd)
  }

  file <- file.path(dest_dir, sprintf("create_empty_%s_branch.bat", branch))

  kwb.utils::catAndRun(dbg = dbg, paste("Writing batch file:", file), {
    writeLines(cmd, file)
  })

  if (execute) {
    kwb.utils::catAndRun(dbg = dbg, paste("Running batch file:", file), {
      system(file)
    })
  }

  git_exe <- git_check_if_windows(git_exe)


  fs::dir_create(dest_dir)


  cmd_checkout <- c(
    sprintf('cd "%s"', dest_dir),
    sprintf('"%s" clone https://github.com/%s/%s', git_exe, org, repo),
    sprintf('"%s" checkout -b %s', git_exe, branch))

  write_git_batch_and_execute(cmd_checkout, set_githubuser,
                              bat_name = sprintf("add_%s_branch.bat",
                                                 branch),
                              dest_dir,
                              git_exe,
                              execute,
                              dbg,
                              ...)

  checkout_path <- file.path(dest_dir, repo)
  use_gitlab_ci_ghpages(dest_dir = checkout_path)

  cmd_push <- c(
    sprintf('cd "%s"', checkout_path),
    sprintf('"%s" add %s', git_exe, ".gitlab-ci.yml"),
    sprintf('"%s" commit -m "Add backup deploy config for GitLab"', git_exe),
    sprintf('"%s" push origin %s', git_exe, branch))

  write_git_batch_and_execute(cmd_push, set_githubuser,
                              bat_name = sprintf("add_%s_branch.bat",
                                                 branch),
                              dest_dir,
                              git_exe,
                              execute,
                              dbg,
                              ...)



}

#' Create Empty gh-pages branch
#'
#' @inheritParams create_empty_branch
#' @return create and push an empty gh-pages branch to org/repo
#' @export
create_empty_branch_ghpages <- function(
  repo = NULL,
  org = "KWB-R",
  set_githubuser = TRUE,
  git_exe = "C:/Program Files/Git/bin/git.exe",
  dest_dir = tempdir(),
  execute = TRUE,
  dbg = TRUE,
  ...
) {

  create_empty_branch(
    repo, branch = "gh-pages", org, set_githubuser, git_exe, dest_dir, execute,
    dbg,...
  )
}
