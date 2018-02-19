#' Fetch citation
#'
#' \code{fetch_citation} returns a DHS API citation.
#' @importFrom magrittr %>%
#' @export
fetch_citation <- function() {
  jsonlite::fromJSON("https://api.dhsprogram.com/rest/dhs/info/citation") %>%
    .$Data %>%
    .$Value
}
