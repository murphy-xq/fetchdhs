#' Fetch survey listing
#'
#' \code{fetch_surveys} returns a dataframe consisting of all available DHS surveys.
#' @importFrom magrittr %>%
#' @export
fetch_surveys <- function() {
  jsonlite::fromJSON("https://api.dhsprogram.com/rest/dhs/surveys?returnFields=CountryName,DHS_CountryCode,SurveyType,SurveyYear,SurveyYearLabel,SurveyType,RegionName,SubregionName,PublicationDate,ReleaseDate") %>%
    .$Data %>%
    dplyr::rename_all(snakecase::to_snake_case) %>%
    dplyr::as_data_frame() %>%
    dplyr::select(country_name, dhs_country_code, survey_type, survey_year, survey_year_label,
                  region_name, subregion_name, publication_date, release_date)
}
