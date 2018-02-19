#' Fetch tag listing
#'
#' \code{fetch_tags} returns a dataframe detailing DHS survey tags. Tags are useful when seeking to extract data by thematic area, e.g. immunization, pneumonia, or HIV.
#' @seealso \code{\link{fetch_data}}
#' @importFrom magrittr %>%
#' @export
fetch_tags <- function() {
  jsonlite::fromJSON("https://api.dhsprogram.com/rest/dhs/tags?") %>%
    .$Data %>%
    dplyr::arrange(TagID) %>%
    dplyr::rename_all(snakecase::to_snake_case) %>%
    dplyr::as_data_frame() %>%
    dplyr::select(tag_name, tag_id, tag_type, tag_order)
}
