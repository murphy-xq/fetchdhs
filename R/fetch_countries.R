#' Fetch country listing
#'
#' \code{fetch_countries} returns a dataframe of all countries with available DHS survey data and their associated DHS and ISO codes.
#' @seealso \code{\link{fetch_data}}
#' @importFrom magrittr %>%
#' @export
fetch_countries <- function() {
  jsonlite::fromJSON("https://api.dhsprogram.com/rest/dhs/countries?returnFields=CountryName,DHS_CountryCode,iso3_CountryCode") %>%
    .$Data %>%
    dplyr::rename_all(snakecase::to_snake_case) %>%
    dplyr::as_data_frame()
}
