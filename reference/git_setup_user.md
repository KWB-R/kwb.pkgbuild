# Git Setup User (Name and Email)

Git Setup User (Name and Email)

## Usage

``` r
git_setup_user(
  github_username,
  github_email,
  scope = c("local", "global"),
  git_exe = path_to_git()
)
```

## Arguments

- github_username:

  username should be your GitHub username

- github_email:

  email should be identical to email you registered with at GitHub (e.g.
  your.name(at)kompetenz-wasser.de)

- scope:

  scope (default: c("local", "global"))

- git_exe:

  path to git executable on Windows (default: path_to_git())

## Value

runs "git" to setup the Git(Hub) user

## See also

\<https://support.rstudio.com/hc/en-us/community/posts/115001143667-Author-Change-with-Git-in-RStudio\>

## Examples

``` r
if (FALSE) { # \dontrun{
git_setup_user("mrustl", "michael.rustler@kompetenz-wasser.de")
} # }
```
