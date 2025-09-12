library(readr)


# slightly trimmed version of Skin and Bone public data
sab_hp_injuries <-
  read_csv(here::here("data-raw/SAB_hp_injuries.csv"))


usethis::use_data(sab_hp_injuries, overwrite = TRUE)

