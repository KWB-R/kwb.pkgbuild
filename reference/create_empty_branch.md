# Create Empty Branch From Github

Create Empty Branch From Github

## Usage

``` r
create_empty_branch(
  repo = NULL,
  branch = NULL,
  org = "KWB-R",
  set_githubuser = TRUE,
  git_exe = path_to_git(),
  dest_dir = tempdir(),
  execute = TRUE,
  dbg = TRUE,
  ...
)
```

## Arguments

- repo:

  name of existing Github repository (default: NULL)

- branch:

  name of branch to be created (default: NULL)

- org:

  repo owner (default: "KWB-R")

- set_githubuser:

  should the Github user be set before executing the branch creation
  (default: TRUE). In this case set_github_user() is run

- git_exe:

  path to GIT executable (default: kwb.pkgbuild:::path_to_git()), only
  required on "windows". On all other platforms it is assumed that "git"
  is sufficient!

- dest_dir:

  directory where the the repo should be checked out (default:
  tempdir())

- execute:

  should a batch file be run?

- dbg:

  print debug messages (default: TRUE)

- ...:

  additional arguments passed to set_github_user

## Value

create empty branch (defined in 'branch') and push to org/repo on Github
