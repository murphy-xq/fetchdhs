
<!-- README.md is generated from README.Rmd. Please edit that file -->
fetchdhs
========

A suite of convenience functions to retrieve tidy dataframes of survey data from the [DHS API](https://api.dhsprogram.com/)

Installation
------------

``` r
# install.packages("devtools")
devtools::install_github("murphy-xq/fetchdhs")
library(fetchdhs)
```

Basic example
-------------

Let's say you quickly need DHS survey data for:

-   immunization-related indicators
-   since 2000
-   for India and Nigeria

First, use `fetch_countries()` to locate the 2-letter DHS country codes for India and Nigeria needed for the api call

``` r
fetch_countries() %>% 
  filter(country_name %in% c("India", "Nigeria"))
#> # A tibble: 2 x 3
#>   iso_3_country_code dhs_country_code country_name
#>   <chr>              <chr>            <chr>       
#> 1 IND                IA               India       
#> 2 NGA                NG               Nigeria
```

Next, make use of [DHS API tags](https://api.dhsprogram.com/rest/dhs/tags?f=html) that categorize survey indicators by topic. In this example, we are looking for all immunization-related indicators using `fetch_tags()` and identify tag `32`

-   Note that only 1 tag may be specified per call

``` r
fetch_tags() %>% 
  filter(str_detect(tag_name,  "[Ii]mmunization"))
#> # A tibble: 1 x 4
#>   tag_name     tag_id tag_type tag_order
#>   <chr>         <int>    <int>     <int>
#> 1 Immunization     32        0       480
```

Finally, use `fetch_data()` to call the DHS API using the parameters just identified and receive a tidy dataframe as well as the api call:

``` r
fetch_data(countries = c("IA","NG"), tags = 32, years = 2000:2017)
#> 1 page to extract
#> Retrieving page 1
#> $df
#> # A tibble: 205 x 27
#>    data_id indicator         survey_id is_preferred value sdrid  precision
#>      <int> <chr>             <chr>            <int> <dbl> <chr>      <dbl>
#>  1  201888 BCG vaccination … IA2006DHS            1  78.1 CHVAC…      1.00
#>  2  201889 DPT 1 vaccinatio… IA2006DHS            1  76.0 CHVAC…      1.00
#>  3  201890 DPT 2 vaccinatio… IA2006DHS            1  66.7 CHVAC…      1.00
#>  4  201886 DPT 3 vaccinatio… IA2006DHS            1  55.3 CHVAC…      1.00
#>  5  201895 Polio 0 vaccinat… IA2006DHS            1  48.4 CHVAC…      1.00
#>  6  201887 Polio 1 vaccinat… IA2006DHS            1  93.1 CHVAC…      1.00
#>  7  201896 Polio 2 vaccinat… IA2006DHS            1  88.8 CHVAC…      1.00
#>  8  201893 Polio 3 vaccinat… IA2006DHS            1  78.2 CHVAC…      1.00
#>  9  201894 Measles vaccinat… IA2006DHS            1  58.8 CHVAC…      1.00
#> 10  201891 Received all 8 b… IA2006DHS            1  43.5 CHVAC…      1.00
#> # ... with 195 more rows, and 20 more variables: region_id <chr>,
#> #   survey_year_label <chr>, survey_type <chr>, survey_year <int>,
#> #   indicator_order <int>, dhs_country_code <chr>, ci_low <dbl>,
#> #   country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>,
#> #   characteristic_order <int>, characteristic_label <chr>,
#> #   by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>,
#> #   by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&returnFields=&apiKey=&perpage=1000"
```

Additional features
-------------------

#### Level of disaggregation

We have been using the default level of disaggregation which returns national-level data only. In order to pull subnational, background characteristic, or all available data, we need to specify the `breakdown_level` in `fetch_data()`

-   Note the increasing amount of records returned as we move from the default `breakdown_level == "national"` (205 records) to `breakdown_level == "all"` (3,270 records)

``` r
# national (default)
fetch_data(countries = c("IA","NG"), tags = 32, years = 2000:2017, breakdown_level = "national")
#> 1 page to extract
#> Retrieving page 1
#> $df
#> # A tibble: 205 x 27
#>    data_id indicator         survey_id is_preferred value sdrid  precision
#>      <int> <chr>             <chr>            <int> <dbl> <chr>      <dbl>
#>  1  201888 BCG vaccination … IA2006DHS            1  78.1 CHVAC…      1.00
#>  2  201889 DPT 1 vaccinatio… IA2006DHS            1  76.0 CHVAC…      1.00
#>  3  201890 DPT 2 vaccinatio… IA2006DHS            1  66.7 CHVAC…      1.00
#>  4  201886 DPT 3 vaccinatio… IA2006DHS            1  55.3 CHVAC…      1.00
#>  5  201895 Polio 0 vaccinat… IA2006DHS            1  48.4 CHVAC…      1.00
#>  6  201887 Polio 1 vaccinat… IA2006DHS            1  93.1 CHVAC…      1.00
#>  7  201896 Polio 2 vaccinat… IA2006DHS            1  88.8 CHVAC…      1.00
#>  8  201893 Polio 3 vaccinat… IA2006DHS            1  78.2 CHVAC…      1.00
#>  9  201894 Measles vaccinat… IA2006DHS            1  58.8 CHVAC…      1.00
#> 10  201891 Received all 8 b… IA2006DHS            1  43.5 CHVAC…      1.00
#> # ... with 195 more rows, and 20 more variables: region_id <chr>,
#> #   survey_year_label <chr>, survey_type <chr>, survey_year <int>,
#> #   indicator_order <int>, dhs_country_code <chr>, ci_low <dbl>,
#> #   country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>,
#> #   characteristic_order <int>, characteristic_label <chr>,
#> #   by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>,
#> #   by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&breakdown=national&returnFields=&apiKey=&perpage=1000"

# subnational
fetch_data(countries = c("IA","NG"), tags = 32, years = 2000:2017, breakdown_level = "subnational")
#> 2 pages to extract
#> Retrieving page 1
#> Retrieving page 2
#> $df
#> # A tibble: 1,260 x 27
#>    data_id indicator        survey_id is_preferred value sdrid   precision
#>      <int> <chr>            <chr>            <int> <dbl> <chr>       <dbl>
#>  1 2441926 BCG vaccination… IA2006DHS            1  87.0 CHVACC…      1.00
#>  2  239491 BCG vaccination… IA2006DHS            1  84.9 CHVACC…      1.00
#>  3 2523956 BCG vaccination… IA2006DHS            1  97.2 CHVACC…      1.00
#>  4 3327965 BCG vaccination… IA2006DHS            1  90.9 CHVACC…      1.00
#>  5 1511863 BCG vaccination… IA2006DHS            1  88.0 CHVACC…      1.00
#>  6  235914 BCG vaccination… IA2006DHS            1  68.5 CHVACC…      1.00
#>  7 2272599 BCG vaccination… IA2006DHS            1  81.4 CHVACC…      1.00
#>  8  239513 BCG vaccination… IA2006DHS            1  80.5 CHVACC…      1.00
#>  9 2750771 BCG vaccination… IA2006DHS            1  84.6 CHVACC…      1.00
#> 10  237253 BCG vaccination… IA2006DHS            1  61.8 CHVACC…      1.00
#> # ... with 1,250 more rows, and 20 more variables: region_id <chr>,
#> #   survey_year_label <chr>, survey_type <chr>, survey_year <int>,
#> #   indicator_order <int>, dhs_country_code <chr>, ci_low <dbl>,
#> #   country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>,
#> #   characteristic_order <int>, characteristic_label <chr>,
#> #   by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>,
#> #   by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&breakdown=subnational&returnFields=&apiKey=&perpage=1000"

# background
fetch_data(countries = c("IA","NG"), tags = 32, years = 2000:2017, breakdown_level = "background")
#> 4 pages to extract
#> Retrieving page 1
#> Retrieving page 2
#> Retrieving page 3
#> Retrieving page 4
#> $df
#> # A tibble: 3,065 x 27
#>    data_id indicator        survey_id is_preferred value sdrid   precision
#>      <int> <chr>            <chr>            <int> <dbl> <chr>       <dbl>
#>  1 4098060 BCG vaccination… IA2006DHS            1  36.5 CHVACS…      1.00
#>  2  749258 BCG vaccination… IA2006DHS            1  41.7 CHVACS…      1.00
#>  3 9713062 BCG vaccination… IA2006DHS            1  75.6 CHVACS…      1.00
#>  4 4098061 DPT 1 vaccinati… IA2006DHS            1  37.0 CHVACS…      1.00
#>  5  749270 DPT 1 vaccinati… IA2006DHS            1  39.0 CHVACS…      1.00
#>  6 9713063 DPT 1 vaccinati… IA2006DHS            1  72.8 CHVACS…      1.00
#>  7 4098080 DPT 2 vaccinati… IA2006DHS            1  34.9 CHVACS…      1.00
#>  8  749274 DPT 2 vaccinati… IA2006DHS            1  31.7 CHVACS…      1.00
#>  9 9713064 DPT 2 vaccinati… IA2006DHS            1  63.3 CHVACS…      1.00
#> 10 4098082 DPT 3 vaccinati… IA2006DHS            1  32.6 CHVACS…      1.00
#> # ... with 3,055 more rows, and 20 more variables: region_id <chr>,
#> #   survey_year_label <chr>, survey_type <chr>, survey_year <int>,
#> #   indicator_order <int>, dhs_country_code <chr>, ci_low <dbl>,
#> #   country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>,
#> #   characteristic_order <int>, characteristic_label <chr>,
#> #   by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>,
#> #   by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&breakdown=background&returnFields=&apiKey=&perpage=1000"

# all
fetch_data(countries = c("IA","NG"), tags = 32, years = 2000:2017, breakdown_level = "all")
#> 4 pages to extract
#> Retrieving page 1
#> Retrieving page 2
#> Retrieving page 3
#> Retrieving page 4
#> $df
#> # A tibble: 3,270 x 27
#>     data_id indicator        survey_id is_preferred value sdrid  precision
#>       <int> <chr>            <chr>            <int> <dbl> <chr>      <dbl>
#>  1  4289997 BCG vaccination… IA2006DHS            1  36.5 CHVAC…      1.00
#>  2   810389 BCG vaccination… IA2006DHS            1  41.7 CHVAC…      1.00
#>  3  4511541 BCG vaccination… IA2006DHS            1  78.1 CHVAC…      1.00
#>  4 10160250 BCG vaccination… IA2006DHS            1  75.6 CHVAC…      1.00
#>  5  4289998 DPT 1 vaccinati… IA2006DHS            1  37.0 CHVAC…      1.00
#>  6   810401 DPT 1 vaccinati… IA2006DHS            1  39.0 CHVAC…      1.00
#>  7  4511542 DPT 1 vaccinati… IA2006DHS            1  76.0 CHVAC…      1.00
#>  8 10160251 DPT 1 vaccinati… IA2006DHS            1  72.8 CHVAC…      1.00
#>  9  4290017 DPT 2 vaccinati… IA2006DHS            1  34.9 CHVAC…      1.00
#> 10   810405 DPT 2 vaccinati… IA2006DHS            1  31.7 CHVAC…      1.00
#> # ... with 3,260 more rows, and 20 more variables: region_id <chr>,
#> #   survey_year_label <chr>, survey_type <chr>, survey_year <int>,
#> #   indicator_order <int>, dhs_country_code <chr>, ci_low <dbl>,
#> #   country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>,
#> #   characteristic_order <int>, characteristic_label <chr>,
#> #   by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>,
#> #   by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&breakdown=all&returnFields=&apiKey=&perpage=1000"
```

#### Return fields

[Return fields](https://api.dhsprogram.com/rest/dhs/data/fields) are the various dimensions of survey data that can returned. Using `set_return_fields()`, we can input any desired fields so that a custom, consistent dataframe is returned

``` r
set_return_fields(c("Indicator", "CountryName", "SurveyYear", "SurveyType", "Value"))

fetch_data(countries = c("IA","NG"), tags = 32, years = 2000:2017)
#> 1 page to extract
#> Retrieving page 1
#> $df
#> # A tibble: 205 x 5
#>    indicator                    survey_type survey_year value country_name
#>    <chr>                        <chr>             <int> <dbl> <chr>       
#>  1 BCG vaccination received     DHS                2006  78.1 India       
#>  2 DPT 1 vaccination received   DHS                2006  76.0 India       
#>  3 DPT 2 vaccination received   DHS                2006  66.7 India       
#>  4 DPT 3 vaccination received   DHS                2006  55.3 India       
#>  5 Polio 0 vaccination received DHS                2006  48.4 India       
#>  6 Polio 1 vaccination received DHS                2006  93.1 India       
#>  7 Polio 2 vaccination received DHS                2006  88.8 India       
#>  8 Polio 3 vaccination received DHS                2006  78.2 India       
#>  9 Measles vaccination received DHS                2006  58.8 India       
#> 10 Received all 8 basic vaccin… DHS                2006  43.5 India       
#> # ... with 195 more rows
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&returnFields=Indicator%2CCountryName%2CSurveyYear%2CSurveyType%2CValue&apiKey=&perpage=1000"
```

#### Add geospatial data

We can also include polygon coordinates with our call with `add_geometry`

``` r
fetch_data(countries = c("IA","NG"), tags = 32, years = 2000:2017, add_geometry = TRUE)
#> 1 page to extract
#> Retrieving page 1
#> $df
#> # A tibble: 4,756 x 6
#>    indicator  survey_type survey_year  value country_name coordinates     
#>    <chr>      <chr>             <int>  <dbl> <chr>        <chr>           
#>  1 BCG vacci… DHS                2003 4.83e¹ Nigeria      POLYGON ((8.283…
#>  2 DPT 1 vac… DHS                2003 4.26e¹ Nigeria      POLYGON ((8.283…
#>  3 DPT 2 vac… DHS                2003 3.17e¹ Nigeria      POLYGON ((8.283…
#>  4 DPT 3 vac… DHS                2003 2.14e¹ Nigeria      POLYGON ((8.283…
#>  5 Polio 0 v… DHS                2003 2.78e¹ Nigeria      POLYGON ((8.283…
#>  6 Polio 1 v… DHS                2003 6.72e¹ Nigeria      POLYGON ((8.283…
#>  7 Percentag… DHS                2013 2.04e¹ Nigeria      POLYGON ((8.283…
#>  8 Number of… DHS                2013 2.27e⁴ Nigeria      POLYGON ((8.283…
#>  9 Number of… DHS                2013 2.24e⁴ Nigeria      POLYGON ((8.283…
#> 10 Polio1 va… DHS                2013 7.09e¹ Nigeria      POLYGON ((8.283…
#> # ... with 4,746 more rows
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&returnGeometry=TRUE&returnFields=Indicator%2CCountryName%2CSurveyYear%2CSurveyType%2CValue&apiKey=&perpage=1000"
```

#### API Key

Authenticated users can query more records per page -- 5,000 versus 1,000 maximum records per page. Please see here for [authentication details](https://api.dhsprogram.com/#/introdevelop.html). Users can input their api key with `set_api_key()` for inclusion in any subsequent `fetch_data()` calls.

``` r
set_api_key("YOURKEY-GOESHERE")
```
