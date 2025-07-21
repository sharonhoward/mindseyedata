library(dplyr)

tpop_qs_petitioners_xlsx <-
  readxl::read_excel(here::here("data-raw/tpop_petitions_petitioners_v1_202208.xlsx"), sheet = "QS_petitioners")

cheshire_petitioners <-
  tpop_qs_petitioners_xlsx |>
  filter(county=="Cheshire") |>
  mutate(signature = case_when(
    is.na(sig_type) ~ "none",
    sig_type=="m" ~ "mark",
    .default = "autograph"
  )) |>
  mutate(name_type = case_match(
    name_type,
    "petr" ~ "petitioner",
    "behalf" ~ "petitioner",
    "sub" ~ "subscriber"
  )) |>
  select(petition_id, petitioner_id, name, name_type, signature, gender, residence, status)



usethis::use_data(cheshire_petitioners, overwrite = TRUE)
