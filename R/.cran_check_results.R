paths_list <- list(

check_url = "https://cran.r-project.org/web/checks",
maintainer = "<check_url>/check_summary_by_maintainer.html",
package = "<check_url>/check_summary_by_package.html",
timings = "<check_url>/check_timings.html",
timings_1 = "<check_url>/check_timings_r-devel-linux-x86_64-debian-clang.html"
)

paths <- kwb.utils::resolveAll(paths_list)


system.time(pkgs_tbl_rvest <- xml2::read_html(paths$package) %>%
  rvest::html_node("table") %>%
  rvest::html_table())


system.time(pkgs_tbl_XML <- XML::htmlParse(paths$package) %>%
  XML::readHTMLTable(stringsAsFactors = FALSE, which = 2))
