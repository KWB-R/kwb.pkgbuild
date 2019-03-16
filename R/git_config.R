
# git_config -------------------------------------------------------------------
#'
#' Git Configuration
#' @param key key (default: "--list")
#' @param value value (default: "")
#' @param scope scope (default: c("local", "global"))
#' @param git_exe path to git executable on Windows (default: path_to_git())
#' @noRd
#' @keywords internal
git_config <- function(key = "--list", value = "", scope = c("local", "global"),
                       git_exe = path_to_git())
{

  git <- git_check_if_windows(git_exe)
  sprintf('"%s" config --%s %s %s',
          git_check_if_windows(git_exe),
          scope, key, value)
}

#' Git Check Configuration
#'
#' @param git_exe path to git executable on Windows (default: path_to_git())
#' @return prints 'global' and 'local' Git configuration
#' @export
#' @examples
#' \dontrun{
#' git_check_config()
#' }
git_check_config <- function( git_exe = path_to_git())
{
  message("Checking 'global' Git(Hub) config:")
  writeLines(
    system(git_config(scope = "global", git_exe = git_exe), intern = TRUE)
  )

  message("Checking 'local' Git(Hub) config:")
  writeLines(
    system(git_config(scope = "local", git_exe = git_exe), intern = TRUE)
  )
}


#' Git Setup User (Name and Email)
#'
#' @param github_username username should be your GitHub username
#' @param github_email email should be identical to email you registered with at
#' GitHub (e.g. your.name(at)kompetenz-wasser.de)
#' @param scope scope (default: c("local", "global"))
#' @param git_exe path to git executable on Windows (default: path_to_git())
#' @return runs "git" to setup the Git(Hub) user
#' @export
#' @importFrom kwb.utils catAndRun
#' @examples
#' \dontrun{
#' git_setup_user("mrustl", "michael.rustler@@kompetenz-wasser.de")
#' }
#' @seealso <https://support.rstudio.com/hc/en-us/community/posts/115001143667-Author-Change-with-Git-in-RStudio>
git_setup_user <- function(
  github_username, github_email, scope = c("local", "global"),
  git_exe = path_to_git())
{
  cmds <- c(
    git_config(key = "user.name", value = github_username, scope, git_exe),
    git_config(key = "user.email", value = github_email, scope, git_exe)
  )

  kwb.utils::catAndRun("Setup Git(Hub) user", expr = sapply(cmds, system))
}
