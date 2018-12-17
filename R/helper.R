#' Write ignore pattern to file
#'
#' @param ignore_pattern pattern that should be added to .Rbuildignore
#' @param comment optional comment to write to file before the ignore pattern
#' @param file path to file where to writen
#' @keywords internal
#' @noRd
#' @importFrom fs file_exists
#'
write_ignorepattern_to_file <- function(ignore_pattern, comment = NULL, file) {
  if (fs::file_exists(file)) {
    ignored_files <- readLines(file)


    has_pattern <- any(grepl(
      x = ignored_files, pattern = ignore_pattern,
      fixed = TRUE
    ))

    if (!has_pattern) {
      if (!is.null(comment)) ignore_pattern <- c(comment, ignore_pattern)
      ignored_files <- append(x = ignored_files, values = ignore_pattern)
      writeLines(
        text = ignored_files,
        con = file
      )
    }
  } else {
    writeLines(
      text = ignore_pattern,
      con = file
    )
  }
}

#' Write to .Rbuildignore
#'
#' @param ignore_pattern pattern that should be added to .Rbuildignore
#' @param comment optional comment to write to file before the ignore pattern
#' @return .Rbuildignore created/updated with pattern
#' @export
#' @importFrom fs file_exists
#'
write_to_rbuildignore <- function(ignore_pattern, comment) {
  write_ignorepattern_to_file(ignore_pattern,
    comment,
    file = ".Rbuildignore"
  )
}

#' Write to .gitignore
#'
#' @param ignore_pattern pattern that should be added to .Rbuildignore
#' @param comment optional comment to write to file before the ignore pattern
#' @return .gitignore created/updated with pattern
#' @export
#' @importFrom fs file_exists
#'
write_to_gitignore <- function(ignore_pattern, comment) {
  write_ignorepattern_to_file(ignore_pattern,
    comment,
    file = ".gitignore"
  )
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
  if (is.null(pkgname)) {
    if (file.exists("DESCRIPTION")) {
      pkg <- read_description()
      pkg$name
    } else {
      stop("No pkgname defined and no 'DESCRIPTION' file for deriving
          package name found")
    }
  } else {
    pkgname
  }
}


#' Git Check if Windows
#'
#' @param git_exe path to Git executable on windows
#' @return git_exe provided (if os == "windows"), else: "git"
#' @keywords internal
#' @noRd
#'
git_check_if_windows <- function(git_exe) {
  if (.Platform$OS.type == "windows") {
    if (!file.exists(git_exe)) {
      stop(sprintf("GIT executable cannot be found: %s", git_exe))
    }
    git_exe <- git_exe
  } else {
    ### assume that "git" is globally defined
    git_exe <- "git"
  }
  git_exe
}


#' Set Github User For GIT
#'
#' @param git_username Github username (default: whoami::username())
#' @param git_email (default: NULL), is then internally derived by calling
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
#' @importFrom whoami username fullname
#' @importFrom stringr str_replace
set_github_user <- function(git_username = whoami::username(),
                            git_email = NULL,
                            git_exe = "C:/Program Files/Git/bin/git.exe",
                            execute = FALSE,
                            execute_dir = tempdir(),
                            dbg = TRUE) {
  if (is.null(git_email)) {
    git_email <- sprintf(
      "%s@kompetenz-wasser.de",
      tolower(stringr::str_replace(
        whoami::fullname(),
        "\\s+",
        "."
      ))
    )
  }


  git_exe <- git_check_if_windows(git_exe)


  cmd_gitconfig <- c(
    sprintf(
      '"%s" config --global user.name %s',
      git_exe,
      git_username
    ),
    sprintf(
      '"%s" config --global user.email %s',
      git_exe,
      git_email
    )
  )

  if (dbg) {
    print(sprintf("Setting GIT user:\n%s", cmd_gitconfig))
  }

  if (execute == FALSE) {
    cmd_gitconfig
  } else {
    gitconfig_bat <- sprintf("set_github_user_%s.bat", git_username)
    gitconfig_bat_path <- file.path(execute_dir, gitconfig_bat)
    writeLines(cmd_gitconfig, gitconfig_bat)
    if (dbg) print(sprintf("Running: %s", gitconfig_bat_path))
    system(command = gitconfig_bat_path)
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
create_empty_branch <- function(repo = NULL,
                                branch = NULL,
                                org = "KWB-R",
                                set_githubuser = TRUE,
                                git_exe = "C:/Program Files/Git/bin/git.exe",
                                dest_dir = tempdir(),
                                execute = TRUE,
                                dbg = TRUE,
                                ...) {

  if (is.null(repo)) {
    stop("Specify the name of the repo to be checked out with parameter 'repo'")
  }

  if (is.null(branch)) {
    stop("Specify the name of the branch to be created in parameter 'branch'")
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


  bat_name <- sprintf("create_empty_%s_branch.bat", branch)
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


#' Create Empty gh-pages branch
#'
#' @inheritParams create_empty_branch
#' @return create and push an empty gh-pages branch to org/repo
#' @export
create_empty_branch_ghpages <- function(repo = NULL,
                                        org = "KWB-R",
                                        set_githubuser = TRUE,
                                        git_exe = "C:/Program Files/Git/bin/git.exe",
                                        dest_dir = tempdir(),
                                        execute = TRUE,
                                        dbg = TRUE,
                                        ...) {
  create_empty_branch(repo,
    branch = "gh-pages",
    org,
    set_githubuser,
    git_exe,
    dest_dir,
    execute,
    dbg,
    ...
  )
}
