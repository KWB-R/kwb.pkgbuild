
# git_config -------------------------------------------------------------------
#'
#' Git Configuration
#' @param key key (default: "--list")
#' @param value value (default: "")
#' @param scope scope (default: c("local", "global"))
#' @noRd
#' @keywords internal
git_config <- function(key = "--list", value = "", scope = c("local", "global"))
{
  sprintf("git config --%s %s %s", scope, key, value)
}

#' Git Check Configuration
#'
#' @return prints 'global' and 'local' Git configuration
#' @export
#' @examples
#' \dontrun{
#' git_check_config()
#' }
git_check_config <- function()
{
  message("Checking 'global' Git(Hub) config:")
  shell(git_config(scope = "global"))

  message("Checking 'local' Git(Hub) config:")
  shell(git_config(scope = "local"))
}


#' Git Setup User (Name and Email)
#'
#' @param github_username username should be your GitHub username
#' @param github_email email should be identical to email you registered with at
#' GitHub (e.g. your.name(at)kompetenz-wasser.de)
#' @param scope scope (default: c("local", "global"))
#' @return runs "git" to setup the Git(Hub) user
#' @export
#' @importFrom kwb.utils catAndRun
#' @examples
#' \dontrun{
#' git_setup_user("mrustl", "michael.rustler@@kompetenz-wasser.de")
#' }
#' @seealso <https://support.rstudio.com/hc/en-us/community/posts/115001143667-Author-Change-with-Git-in-RStudio>
git_setup_user <- function(github_username,
                           github_email,
                           scope = c("local", "global"))
{


cmds <- c(git_config(key = "user.name", value = github_username, scope),
          git_config(key = "user.email", value = github_email, scope)
          )

kwb.utils::catAndRun("Setup Git(Hub) user",
                     expr = sapply(cmds, shell))
}

