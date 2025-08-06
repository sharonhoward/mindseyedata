library(readr)
library(stringr)
library(dplyr)


# RHC public data (trimmed down variables)
rhc_csv <-
  read_csv(here::here("data-raw/rhc_20250806.csv"))

# RHC register years
rhc_years_csv <-
  read_csv(here::here("data-raw/rhc_years_20250806.csv"))

# DP life IDs
dp_ids_csv <-
  read_csv(here::here("data-raw/dp_rhc_ids_20250806.csv"))


rhc <-
  rhc_csv |>
  janitor::clean_names("snake") |>
  inner_join(rhc_years_csv, join_by(tna_reference))  |>
  inner_join(dp_ids_csv, join_by(dp_id)) |>
  select(dp_id, year= start_year, gender, year_birth, marital, height_inches, build, given, surname, dp_life_id, tna_reference) |>
  # clean up marital
  mutate(marital = str_to_lower(marital),
         marital = str_trim(str_remove_all(marital, "[:punct:]|[0-9]+"))) |>
  mutate(marital = na_if(marital, "")) |>
  mutate(marital = case_when(
    # small number of NA gender wd/wdr, but nearly all ocr/unmatched and wdr/wd look ok
    is.na(gender) & marital %in% c("wdr", "wd") ~ marital,
    # there are a few wd/wdr that don't match gender. fix them.
    # (checked and gender does seem to be correct in these cases)
    # also assume any marital containing "w" is meant to be wd/wdr
    gender=="female" & str_detect(marital, "^w") ~ "wd",
    gender %in% c("male", "indeterminate") & str_detect(marital, "^w") ~ "wdr",
    marital %in% c("s", "m") ~ marital,
    # anything else not NA looks like bad ocr and not interpretable
    !is.na(marital) ~ NA # keep illegible/bad ocr stuff distinct from NAs?. there are only 10! ok
  ))  |>
  # and clean up build
  mutate(build = str_to_lower(build),
         build = str_remove_all(build, "[:punct:]| +"),
         build = str_trim(build)) |>
  mutate(build = case_when(
    str_detect(build, "^(th.*[ks]|tc?k)") ~ "thickset",
    str_detect(build, "^(pro|prep)") ~ "prop",
    str_detect(build, "^sl[end]|slond|sdr") ~ "slender",
    str_detect(build, "^sto.*sh") ~ "stoutish",
    str_detect(build, "^sto") ~ "stout",
    str_detect(build, "^sli") ~ "slight",
    str_detect(build, "^med") ~"medium",
    str_detect(build, "stif") ~ "stiff",
    str_detect(build, "^rob") ~ "robust",
    str_detect(build, "^stro") ~ "strong",
    str_detect(build, "^spa") ~ "spare",
    str_detect(build, "^fat") ~ "fat",
    str_detect(build, "^(musc|msc)") ~ "muscular",
    str_detect(build, "^thi") ~ "thin",
    str_detect(build, "^bro") ~ "broad",
    str_detect(build, "^sma") ~ "small",
    build %in% c("bulky", "lanky", "square") ~ build
    # 90 or so random ocr too bad to bother
  ))



usethis::use_data(rhc, overwrite = TRUE)
