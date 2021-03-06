% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch_data.R
\name{fetch_data}
\alias{fetch_data}
\title{Retrieve DHS API data}
\usage{
fetch_data(countries = NULL, years = NULL, indicators = NULL,
  tag = NULL, breakdown_level = NULL, add_geometry = NULL)
}
\arguments{
\item{countries}{Specify countries by DHS country code. Use \code{fetch_countries} for listing of DHS country codes.}

\item{years}{Specify survey year(s)}

\item{indicators}{Specify indicators by indicator_id. Use \code{fetch_indicators} for indicator details including indicator_ids.}

\item{tag}{Specify tag. Use \code{fetch_tags} for details. NOTE: only 1 tag can be specified per call.}

\item{breakdown_level}{Specify level of data disaggregation. Options include "national" (default), "subnational", "background", and "all".}

\item{add_geometry}{Set to "true" for inclusion of polygon coordinates.}
}
\value{
A list containing the API call and dataframe of the results.
}
\description{
\code{fetch_data} retrieves DHS API data and returns a dataframe with arguments to specify countries, years, indicators, tag, and level of disaggregation.
}
\details{
Set DHS API key with \code{\link{set_api_key}} and return fields with \code{\link{set_return_fields}}.
}
\examples{
# Return all immunization tagged data for Ghana and Kenya from 2010 to 2016
fetch_data(countries = c("GH", "KE"), years = 2010:2016, tag = 32, breakdown_level = "all")

# Return all national-level data for "Assistance during delivery from a skilled provider" and
"Treatment of diarrhea: Taken to a health facility"
fetch_data(indicators = c("RH_DELA_C_SKP", "CH_DIAT_C_ADV"), breakdown_level = "national")

# Return all 2016 data with geometry for the tag "SDGs"
fetch_data(years = 2016, tag = 80, add_geometry = "true")
}
\seealso{
\code{\link{fetch_countries}}, \code{\link{fetch_indicators}}, \code{\link{fetch_tags}}
}
