#' Set return fields for DHS API
#'
#' \code{set_return_fields} captures a set of return fields for use in \code{fetch_data}.
#' @param dhs_return_fields Input return fields to populate the retrieved dataframe from the DHS API. Please see \url{https://api.dhsprogram.com/rest/dhs/data/fields} for complete list of available fields.
#' @return Captures a vector of the specified return fields.
#' @seealso \code{\link{fetch_data}}
#' @examples
#' set_return_fields(c("Indicator", "IndicatorId","CountryName", "DHS_CountryCode",
#'                     "SurveyYear", "SurveyYearLabel", "SurveyType",
#'                     "CharacteristicCategory", "CharacteristicLabel", "ByVariableLabel",
#'                     "DenominatorWeighted", "DenominatorUnweighted",
#'                     "CILow", "CIHigh", "Value"))
#' @export
set_return_fields <- function(dhs_return_fields) {
  if (!missing(dhs_return_fields)) {
    options(return_fields = stringr::str_c(dhs_return_fields, collapse = ","))
  }
  invisible(getOption("return_fields"))
}
