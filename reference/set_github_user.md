# Set Github User For GIT

Set Github User For GIT

## Usage

``` r
set_github_user(
  git_username = "kwb.pkgbuild::use_autopkgdown()",
  git_fullname = "kwb.pkgbuild::use_autopkgdown()",
  git_email = "kwbr-bot@kompetenz-wasser.de",
  git_exe = path_to_git(),
  execute = FALSE,
  execute_dir = tempdir(),
  dbg = TRUE
)
```

## Arguments

- git_username:

  Github username (default: "kwb.pkgbuild::use_autopkgdown()")

- git_fullname:

  Github fullname (default: "kwb.pkgbuild::use_autopkgdown()")

- git_email:

  (default: \`kwbr-bot@kompetenz-wasser.de\`), is then internally
  derived by calling whoami::fullname() and assuming that Github
  "kompetenz-wasser.de" used as email on Github

- git_exe:

  path git git executable (only used on Windows as it is not installed
  in the local "environment"). On all other plattforms it is assumed
  that a call with "git" works

- execute:

  should a batch file be run?

- execute_dir:

  path to directory where batch script should be run in case that
  execute == TRUE (default: tempdir())

- dbg:

  print debug messages (default: TRUE)

## Value

sets globally user.name and user.email in Git
