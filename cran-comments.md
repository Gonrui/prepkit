writeLines(
  c(
    "## R CMD check results",
    "",
    "0 errors | 0 warnings | 0 notes",
    "",
    "## Comments",
    "",
    "This is a new release."
  ),
  "cran-comments.md"
)

file.exists("cran-comments.md")
