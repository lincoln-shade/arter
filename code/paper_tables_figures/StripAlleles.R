require(stringi)

StripAlleles <- function(x) {
  stri_replace_last_regex(x, ":[:alpha:]*:[:alpha:]*", "")
}