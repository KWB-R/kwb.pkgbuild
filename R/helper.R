# get_pkgname ------------------------------------------------------------------

#' Helper Function: Get Package Name
#'
#' @param pkgname either package name or NULL. In this
#' case the DESCRIPTION file in the current working
#' directory is read and is package name ues (default: NULL)
#'
#' @return package name
#' @export

get_pkgname <- function(pkgname = NULL)
{
  # Return the package name if it was given
  if (! is.null(pkgname)) {
    return(pkgname)
  }

  if (! file.exists("DESCRIPTION")) clean_stop(
    "No pkgname defined and no 'DESCRIPTION' file for deriving package name ",
    "found"
  )

  read_description()$name
}

# git_check_if_windows ---------------------------------------------------------

#' Git Check if Windows
#'
#' @param git_exe path to Git executable on windows
#' @return git_exe provided (if os == "windows"), else: "git"
#' @keywords internal
#' @noRd
#'
git_check_if_windows <- function(git_exe)
{
  # For non-Windows systems, assume that "git" is installed and on the PATH
  if (.Platform$OS.type != "windows") {
    return("git")
  }

  # .Platform$OS.type == "windows"
  if (! file.exists(git_exe)) clean_stop(
    "GIT executable cannot be found: ", git_exe
  )

  git_exe
}

# set_github_user --------------------------------------------------------------

#' Set Github User For GIT
#'
#' @param git_username Github username (default:
#'   "kwb.pkgbuild::use_autopkgdown()")
#' @param git_fullname Github fullname (default:
#'   "kwb.pkgbuild::use_autopkgdown()")
#' @param git_email (default: `kwbr-bot@kompetenz-wasser.de`), is then
#'   internally derived by calling whoami::fullname() and assuming that Github
#'   "kompetenz-wasser.de" used as email on Github
#' @param git_exe path git git executable (only used on Windows as it is not
#'   installed in the local "environment"). On all other plattforms it is
#'   assumed that a call with "git" works
#' @param execute should a batch file be run?
#' @param execute_dir path to directory where batch script should be run in case
#'   that execute == TRUE (default: tempdir())
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
)
{
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

# write_git_batch_and_execute --------------------------------------------------

#' @noRd
#' @keywords internal
write_git_batch_and_execute <- function(
  cmd,
  set_githubuser = TRUE,
  bat_name = sprintf("%s.bat", basename(tempfile())),
  dest_dir,
  git_exe,
  execute = TRUE,
  dbg = TRUE,
  ...
)
{
  if (set_githubuser) {
    cmd <- c(set_github_user(git_exe = git_exe, dbg = dbg, ...), cmd)
  }

  file <- file.path(dest_dir, bat_name)

  kwb.utils::catAndRun(dbg = dbg, sprintf("Writing batch file: %s", file), {
    writeLines(cmd, file)
  })

  if (! execute) {
    return()
  }

  kwb.utils::catAndRun(dbg = dbg, sprintf("Running batch file: %s", file), {
    expr = system(file)
  })
}
