library(readr)


# slightly trimmed version of Skin and Bone public data
sab_dp_injuries <-
  read_csv(here::here("data-raw/SAB_dp_injuries.csv"))


usethis::use_data(sab_dp_injuries, overwrite = TRUE)

