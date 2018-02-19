#' Set DHS API key
#'
#' \code{set_api_key} captures the DHS API key for use in \code{fetch_data}.
#' @param dhs_api_key Input DHS API key as string. Please see \url{https://api.dhsprogram.com/#/introdevelop.html} for authentication details.
#' @return Returns the currently set \code{dhs_api_key}.
#' @seealso \code{\link{fetch_data}}
#' @examples
#' set_api_key("ABCDEF-123456")
#' @export
set_api_key <- function(dhs_api_key) {
  if (!missing(dhs_api_key)) {
    options(api_key = dhs_api_key)
  }
  invisible(getOption("api_key"))
}
