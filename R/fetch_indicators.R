#' Fetch indicator listing
#'
#' \code{fetch_indicators} returns a dataframe of all available DHS survey indicators, e.g. indicator id, definition, and denominator.
#' @seealso \code{\link{fetch_data}}
#' @importFrom magrittr %>%
#' @export
fetch_indicators <- function() {
  jsonlite::fromJSON("https://api.dhsprogram.com/rest/dhs/indicators?returnFields=TagIds,IndicatorId,Label,ShortName,Definition,Denominator,Level1,Level2,Level3") %>%
    .$Data %>%
    dplyr::rename_all(snakecase::to_snake_case) %>%
    dplyr::as_data_frame() %>%
    dplyr::arrange(indicator_id) %>%
    dplyr::select(tag_ids, indicator_id, label, short_name, definition, 
                  denominator, level_1, level_2, level_3)
}
