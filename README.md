
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/murphy-xq/fetchdhs.svg?branch=master)](https://travis-ci.org/murphy-xq/fetchdhs)

# fetchdhs

The [Demographic and Health Surveys (DHS)
Program](https://www.dhsprogram.com/) has conducted more than 400
surveys in over 90 countries since 1984. It remains a critical resource
in global health research and analytics as it provides nationally
representative data on fertility, family planning, maternal and child
health, gender, HIV/AIDS, malaria, and nutrition. The objective of this
package is to enable R users to plug into the [DHS
API](https://api.dhsprogram.com/) and retrieve tidy survey data.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("murphy-xq/fetchdhs")
```

## Basic example

Let’s say you quickly need DHS survey data for:

  - immunization-related indicators
  - since 2000
  - for India and Nigeria

First, use `fetch_countries()` to locate the 2-letter DHS country codes
for India and Nigeria needed for the api call

``` r
fetch_countries() %>% 
  filter(country_name %in% c("India", "Nigeria"))
#> # A tibble: 2 x 3
#>   iso_3_country_code dhs_country_code country_name
#>   <chr>              <chr>            <chr>       
#> 1 IND                IA               India       
#> 2 NGA                NG               Nigeria
```

Next, make use of [DHS API
tags](https://api.dhsprogram.com/rest/dhs/tags?f=html) that categorize
survey indicators by topic. In this example, we are looking for all
immunization-related indicators using `fetch_tags()` and identify tag
`32`

``` r
fetch_tags() %>% 
  filter(str_detect(tag_name,  "[Ii]mmunization"))
#> # A tibble: 1 x 4
#>   tag_name     tag_id tag_type tag_order
#>   <chr>         <int>    <int>     <int>
#> 1 Immunization     32        0       480
```

Finally, use `fetch_data()` to call the DHS API using the parameters
just identified and receive a tidy dataframe as well as the api call:

  - Note only 1 tag may be specified

<!-- end list -->

``` r
fetch_data(countries = c("IA","NG"), tag = 32, years = 2000:2017)
#> 1 page to extract
#> Retrieving page 1
#> $df
#> # A tibble: 205 x 27
#>    data_id indicator survey_id is_preferred value sdrid precision region_id survey_year_lab… survey_type
#>      <int> <chr>     <chr>            <int> <dbl> <chr>     <dbl> <chr>     <chr>            <chr>      
#>  1  312038 BCG vacc… IA2006DHS            1  78.1 CHVA…         1 <NA>      2005-06          DHS        
#>  2  312039 DPT 1 va… IA2006DHS            1  76   CHVA…         1 <NA>      2005-06          DHS        
#>  3  312040 DPT 2 va… IA2006DHS            1  66.7 CHVA…         1 <NA>      2005-06          DHS        
#>  4  312036 DPT 3 va… IA2006DHS            1  55.3 CHVA…         1 <NA>      2005-06          DHS        
#>  5  312037 Polio 0 … IA2006DHS            1  48.4 CHVA…         1 <NA>      2005-06          DHS        
#>  6  312041 Polio 1 … IA2006DHS            1  93.1 CHVA…         1 <NA>      2005-06          DHS        
#>  7  312046 Polio 2 … IA2006DHS            1  88.8 CHVA…         1 <NA>      2005-06          DHS        
#>  8  312044 Polio 3 … IA2006DHS            1  78.2 CHVA…         1 <NA>      2005-06          DHS        
#>  9  312045 Measles … IA2006DHS            1  58.8 CHVA…         1 <NA>      2005-06          DHS        
#> 10  312042 Received… IA2006DHS            1  43.5 CHVA…         1 <NA>      2005-06          DHS        
#> # … with 195 more rows, and 17 more variables: survey_year <int>, indicator_order <int>,
#> #   dhs_country_code <chr>, ci_low <dbl>, country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>, characteristic_order <int>,
#> #   characteristic_label <chr>, by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>, by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&returnFields=&apiKey=&perpage=1000"
```

For specific indicators, we can peek at a dataframe of all available
indicators to identify which `indicator_id` codes should be included
with `fetch_data()`. Let’s try pulling only DPT3 and Measles indicators:

``` r
fetch_indicators() %>% 
  filter(str_detect(definition, "Measles|DPT3"))
#> # A tibble: 8 x 9
#>   tag_ids indicator_id  label      short_name definition             denominator   level_1 level_2     level_3
#>   <chr>   <chr>         <chr>      <chr>      <chr>                  <chr>         <chr>   <chr>       <chr>  
#> 1 32, 7   CH_VAC1_C_DP3 DPT3 vacc… DPT3       Percentage of childre… "Children ag… Child … Vaccinatio… Childr…
#> 2 ""      CH_VAC1_C_MS2 Measles 2… Measles 2  Percentage of childre… "Children ag… Child … Vaccinatio… Childr…
#> 3 32, 7   CH_VAC1_C_MSL Measles v… Measles    Percentage of childre… "Children ag… Child … Vaccinatio… Childr…
#> 4 32, 77  CH_VACC_C_DP3 DPT3 vacc… DPT3       Percentage of childre… "Children ag… Child … Vaccinatio… Childr…
#> 5 ""      CH_VACC_C_MS2 Measles 2… Measles 2  Percentage of childre… "Children ag… Child … Vaccinatio… Childr…
#> 6 32, 77  CH_VACC_C_MSL Measles v… Measles    Percentage of childre… "Children ag… Child … Vaccinatio… Childr…
#> 7 ""      CH_VACS_C_MS2 Measles 2… Measles 2  Percentage of childre… "Children ag… Child … Vaccinatio… Childr…
#> 8 32, 1   CH_VACS_C_MSL Measles v… Measles    Percentage of childre… "Children ag… Child … Vaccinatio… Childr…
```

Upon investigating the DPT3 and Measles indicators and their associated
[attributes](https://api.dhsprogram.com/rest/dhs/indicators/fields), we
see that we need to use `CH_VACC_C_DP3` and
`CH_VACC_C_MSL`:

``` r
fetch_data(countries = c("IA","NG"), indicators = c("CH_VACC_C_DP3", "CH_VACC_C_MSL"), years = 2000:2017)
#> 1 page to extract
#> Retrieving page 1
#> $df
#> # A tibble: 10 x 27
#>    data_id indicator survey_id is_preferred value sdrid precision region_id survey_year_lab… survey_type
#>      <int> <chr>     <chr>            <int> <dbl> <chr>     <dbl> <chr>     <chr>            <chr>      
#>  1  408719 DPT3 vac… IA2006DHS            1  55.3 CHVA…         1 <NA>      2005-06          DHS        
#>  2  408720 Measles … IA2006DHS            1  58.8 CHVA…         1 <NA>      2005-06          DHS        
#>  3   38699 DPT3 vac… IA2015DHS            1  78.4 CHVA…         1 <NA>      2015-16          DHS        
#>  4   38700 Measles … IA2015DHS            1  81.1 CHVA…         1 <NA>      2015-16          DHS        
#>  5   41756 DPT3 vac… NG2003DHS            1  21.4 CHVA…         1 <NA>      2003             DHS        
#>  6   41757 Measles … NG2003DHS            1  35.9 CHVA…         1 <NA>      2003             DHS        
#>  7   42179 DPT3 vac… NG2008DHS            1  35.4 CHVA…         1 <NA>      2008             DHS        
#>  8   42193 Measles … NG2008DHS            1  41.4 CHVA…         1 <NA>      2008             DHS        
#>  9   42381 DPT3 vac… NG2013DHS            1  38.2 CHVA…         1 <NA>      2013             DHS        
#> 10   42386 Measles … NG2013DHS            1  42.1 CHVA…         1 <NA>      2013             DHS        
#> # … with 17 more variables: survey_year <int>, indicator_order <int>, dhs_country_code <chr>, ci_low <dbl>,
#> #   country_name <chr>, indicator_type <chr>, characteristic_id <dbl>, characteristic_category <chr>,
#> #   indicator_id <chr>, characteristic_order <int>, characteristic_label <chr>, by_variable_label <chr>,
#> #   denominator_unweighted <dbl>, denominator_weighted <dbl>, ci_high <dbl>, is_total <int>,
#> #   by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&indicatorIds=CH_VACC_C_DP3%2CCH_VACC_C_MSL&returnFields=&apiKey=&perpage=1000"
```

## Additional features

#### Level of disaggregation

We have been using the default level of disaggregation which returns
national-level data only. In order to pull subnational, background
characteristic, or all available data, we need to specify the
`breakdown_level` in `fetch_data()`

  - Note the increasing amount of records returned as we move from the
    default `breakdown_level == "national"` (205 records) to
    `breakdown_level == "all"` (3,270 records)

<!-- end list -->

``` r
# national (default)
fetch_data(countries = c("IA","NG"), tag = 32, years = 2000:2017, breakdown_level = "national")
#> 1 page to extract
#> Retrieving page 1
#> $df
#> # A tibble: 205 x 27
#>    data_id indicator survey_id is_preferred value sdrid precision region_id survey_year_lab… survey_type
#>      <int> <chr>     <chr>            <int> <dbl> <chr>     <dbl> <chr>     <chr>            <chr>      
#>  1  312038 BCG vacc… IA2006DHS            1  78.1 CHVA…         1 <NA>      2005-06          DHS        
#>  2  312039 DPT 1 va… IA2006DHS            1  76   CHVA…         1 <NA>      2005-06          DHS        
#>  3  312040 DPT 2 va… IA2006DHS            1  66.7 CHVA…         1 <NA>      2005-06          DHS        
#>  4  312036 DPT 3 va… IA2006DHS            1  55.3 CHVA…         1 <NA>      2005-06          DHS        
#>  5  312037 Polio 0 … IA2006DHS            1  48.4 CHVA…         1 <NA>      2005-06          DHS        
#>  6  312041 Polio 1 … IA2006DHS            1  93.1 CHVA…         1 <NA>      2005-06          DHS        
#>  7  312046 Polio 2 … IA2006DHS            1  88.8 CHVA…         1 <NA>      2005-06          DHS        
#>  8  312044 Polio 3 … IA2006DHS            1  78.2 CHVA…         1 <NA>      2005-06          DHS        
#>  9  312045 Measles … IA2006DHS            1  58.8 CHVA…         1 <NA>      2005-06          DHS        
#> 10  312042 Received… IA2006DHS            1  43.5 CHVA…         1 <NA>      2005-06          DHS        
#> # … with 195 more rows, and 17 more variables: survey_year <int>, indicator_order <int>,
#> #   dhs_country_code <chr>, ci_low <dbl>, country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>, characteristic_order <int>,
#> #   characteristic_label <chr>, by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>, by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&breakdown=national&returnFields=&apiKey=&perpage=1000"

# subnational
fetch_data(countries = c("IA","NG"), tag = 32, years = 2000:2017, breakdown_level = "subnational")
#> 2 pages to extract
#> Retrieving page 1
#> Retrieving page 2
#> $df
#> # A tibble: 1,778 x 27
#>    data_id indicator survey_id is_preferred value sdrid precision region_id survey_year_lab… survey_type
#>      <int> <chr>     <chr>            <int> <dbl> <chr>     <dbl> <chr>     <chr>            <chr>      
#>  1 3522188 BCG vacc… IA2006DHS            1  87   CHVA…         1 IADHS200… 2005-06          DHS        
#>  2 3794153 BCG vacc… IA2006DHS            1  84.9 CHVA…         1 IADHS200… 2005-06          DHS        
#>  3 3510428 BCG vacc… IA2006DHS            1  97.2 CHVA…         1 IADHS200… 2005-06          DHS        
#>  4 1067426 BCG vacc… IA2006DHS            1  90.9 CHVA…         1 IADHS200… 2005-06          DHS        
#>  5 2283439 BCG vacc… IA2006DHS            1  88   CHVA…         1 IADHS200… 2005-06          DHS        
#>  6 1067432 BCG vacc… IA2006DHS            1  68.5 CHVA…         1 IADHS200… 2005-06          DHS        
#>  7  162335 BCG vacc… IA2006DHS            1  81.4 CHVA…         1 IADHS200… 2005-06          DHS        
#>  8 1060658 BCG vacc… IA2006DHS            1  80.5 CHVA…         1 IADHS200… 2005-06          DHS        
#>  9  550794 BCG vacc… IA2006DHS            1  84.6 CHVA…         1 IADHS200… 2005-06          DHS        
#> 10 1065384 BCG vacc… IA2006DHS            1  61.8 CHVA…         1 IADHS200… 2005-06          DHS        
#> # … with 1,768 more rows, and 17 more variables: survey_year <int>, indicator_order <int>,
#> #   dhs_country_code <chr>, ci_low <dbl>, country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>, characteristic_order <int>,
#> #   characteristic_label <chr>, by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>, by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&breakdown=subnational&returnFields=&apiKey=&perpage=1000"

# background
fetch_data(countries = c("IA","NG"), tag = 32, years = 2000:2017, breakdown_level = "background")
#> 4 pages to extract
#> Retrieving page 1
#> Retrieving page 2
#> Retrieving page 3
#> Retrieving page 4
#> $df
#> # A tibble: 3,583 x 27
#>    data_id indicator survey_id is_preferred value sdrid precision region_id survey_year_lab… survey_type
#>      <int> <chr>     <chr>            <int> <dbl> <chr>     <dbl> <chr>     <chr>            <chr>      
#>  1  4.25e6 BCG vacc… IA2006DHS            1  36.5 CHVA…         1 <NA>      2005-06          DHS        
#>  2  9.84e5 BCG vacc… IA2006DHS            1  41.7 CHVA…         1 <NA>      2005-06          DHS        
#>  3  1.04e7 BCG vacc… IA2006DHS            1  75.6 CHVA…         1 <NA>      2005-06          DHS        
#>  4  4.25e6 DPT 1 va… IA2006DHS            1  37   CHVA…         1 <NA>      2005-06          DHS        
#>  5  9.84e5 DPT 1 va… IA2006DHS            1  39   CHVA…         1 <NA>      2005-06          DHS        
#>  6  1.04e7 DPT 1 va… IA2006DHS            1  72.8 CHVA…         1 <NA>      2005-06          DHS        
#>  7  4.25e6 DPT 2 va… IA2006DHS            1  34.9 CHVA…         1 <NA>      2005-06          DHS        
#>  8  9.84e5 DPT 2 va… IA2006DHS            1  31.7 CHVA…         1 <NA>      2005-06          DHS        
#>  9  1.04e7 DPT 2 va… IA2006DHS            1  63.3 CHVA…         1 <NA>      2005-06          DHS        
#> 10  4.25e6 DPT 3 va… IA2006DHS            1  32.6 CHVA…         1 <NA>      2005-06          DHS        
#> # … with 3,573 more rows, and 17 more variables: survey_year <int>, indicator_order <int>,
#> #   dhs_country_code <chr>, ci_low <dbl>, country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>, characteristic_order <int>,
#> #   characteristic_label <chr>, by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>, by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&breakdown=background&returnFields=&apiKey=&perpage=1000"

# all
fetch_data(countries = c("IA","NG"), tag = 32, years = 2000:2017, breakdown_level = "all")
#> 4 pages to extract
#> Retrieving page 1
#> Retrieving page 2
#> Retrieving page 3
#> Retrieving page 4
#> $df
#> # A tibble: 3,788 x 27
#>    data_id indicator survey_id is_preferred value sdrid precision region_id survey_year_lab… survey_type
#>      <int> <chr>     <chr>            <int> <dbl> <chr>     <dbl> <chr>     <chr>            <chr>      
#>  1  4.46e6 BCG vacc… IA2006DHS            1  36.5 CHVA…         1 <NA>      2005-06          DHS        
#>  2  1.02e6 BCG vacc… IA2006DHS            1  41.7 CHVA…         1 <NA>      2005-06          DHS        
#>  3  6.80e6 BCG vacc… IA2006DHS            1  78.1 CHVA…         1 <NA>      2005-06          DHS        
#>  4  1.09e7 BCG vacc… IA2006DHS            1  75.6 CHVA…         1 <NA>      2005-06          DHS        
#>  5  4.46e6 DPT 1 va… IA2006DHS            1  37   CHVA…         1 <NA>      2005-06          DHS        
#>  6  1.02e6 DPT 1 va… IA2006DHS            1  39   CHVA…         1 <NA>      2005-06          DHS        
#>  7  6.80e6 DPT 1 va… IA2006DHS            1  76   CHVA…         1 <NA>      2005-06          DHS        
#>  8  1.09e7 DPT 1 va… IA2006DHS            1  72.8 CHVA…         1 <NA>      2005-06          DHS        
#>  9  4.46e6 DPT 2 va… IA2006DHS            1  34.9 CHVA…         1 <NA>      2005-06          DHS        
#> 10  1.02e6 DPT 2 va… IA2006DHS            1  31.7 CHVA…         1 <NA>      2005-06          DHS        
#> # … with 3,778 more rows, and 17 more variables: survey_year <int>, indicator_order <int>,
#> #   dhs_country_code <chr>, ci_low <dbl>, country_name <chr>, indicator_type <chr>, characteristic_id <dbl>,
#> #   characteristic_category <chr>, indicator_id <chr>, characteristic_order <int>,
#> #   characteristic_label <chr>, by_variable_label <chr>, denominator_unweighted <dbl>,
#> #   denominator_weighted <dbl>, ci_high <dbl>, is_total <int>, by_variable_id <int>
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&breakdown=all&returnFields=&apiKey=&perpage=1000"
```

#### Return fields

[Return fields](https://api.dhsprogram.com/rest/dhs/data/fields) are the
various dimensions of survey data that can be returned.
`set_return_fields()` allows the user to specify which fields should
comprise the dataframe returned from the
api

``` r
set_return_fields(c("Indicator", "CountryName", "SurveyYear", "SurveyType", "Value"))

fetch_data(countries = c("IA","NG"), tag = 32, years = 2000:2017)
#> 1 page to extract
#> Retrieving page 1
#> $df
#> # A tibble: 205 x 5
#>    indicator                         survey_type survey_year value country_name
#>    <chr>                             <chr>             <int> <dbl> <chr>       
#>  1 BCG vaccination received          DHS                2006  78.1 India       
#>  2 DPT 1 vaccination received        DHS                2006  76   India       
#>  3 DPT 2 vaccination received        DHS                2006  66.7 India       
#>  4 DPT 3 vaccination received        DHS                2006  55.3 India       
#>  5 Polio 0 vaccination received      DHS                2006  48.4 India       
#>  6 Polio 1 vaccination received      DHS                2006  93.1 India       
#>  7 Polio 2 vaccination received      DHS                2006  88.8 India       
#>  8 Polio 3 vaccination received      DHS                2006  78.2 India       
#>  9 Measles vaccination received      DHS                2006  58.8 India       
#> 10 Received all 8 basic vaccinations DHS                2006  43.5 India       
#> # … with 195 more rows
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&returnFields=Indicator%2CCountryName%2CSurveyYear%2CSurveyType%2CValue&apiKey=&perpage=1000"
```

#### Add geospatial data

We can also include polygon coordinates with our call with
`add_geometry`

``` r
fetch_data(countries = c("IA","NG"), tag = 32, years = 2000:2017, add_geometry = TRUE)
#> 1 page to extract
#> Retrieving page 1
#> $df
#> # A tibble: 205 x 6
#>    indicator               survey_type survey_year   value country_name coordinates                           
#>    <chr>                   <chr>             <int>   <dbl> <chr>        <chr>                                 
#>  1 BCG vaccination receiv… DHS                2006  7.81e1 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#>  2 DPT 1 vaccination rece… DHS                2006  7.60e1 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#>  3 DPT 2 vaccination rece… DHS                2006  6.67e1 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#>  4 DPT 3 vaccination rece… DHS                2006  5.53e1 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#>  5 Polio 0 vaccination re… DHS                2006  4.84e1 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#>  6 Polio 1 vaccination re… DHS                2006  9.31e1 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#>  7 Received no vaccinatio… DHS                2015  9.50e0 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#>  8 Percentage showing a v… DHS                2015  5.03e1 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#>  9 Number of children one… DHS                2015  1.93e5 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#> 10 Number of children one… DHS                2015  1.99e5 India        POLYGON ((93.7463 6.9598, 93.7408 6.9…
#> # … with 195 more rows
#> 
#> $url
#> [1] "http://api.dhsprogram.com/rest/dhs/data?countryIds=IA%2CNG&surveyYear=2000%2C2001%2C2002%2C2003%2C2004%2C2005%2C2006%2C2007%2C2008%2C2009%2C2010%2C2011%2C2012%2C2013%2C2014%2C2015%2C2016%2C2017&tagIds=32&returnGeometry=TRUE&returnFields=Indicator%2CCountryName%2CSurveyYear%2CSurveyType%2CValue&apiKey=&perpage=1000"
```

#### API Key

Authenticated users can query more records per page – 5,000 versus 1,000
maximum records per page. Please see
[here](https://api.dhsprogram.com/#/introdevelop.html) for
authentication details.

Users can input their api key with `set_api_key()` for inclusion in any
subsequent `fetch_data()` calls.

``` r
set_api_key("YOURKEY-GOESHERE")
```
