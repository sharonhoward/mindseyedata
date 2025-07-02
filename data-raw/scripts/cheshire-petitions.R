library(dplyr)

tpop_qs_petitions_xlsx <-
  readxl::read_excel(here::here("data-raw/tpop_petitions_petitioners_v1_202208.xlsx"), sheet = "QS_petitions")

cheshire_petitions <-
  tpop_qs_petitions_xlsx |>
  filter(county =="Cheshire") |>
  select(petition_id, year, topic, subtopic, petition_type, named_petrs, petition_gender, response=response_cat, petitioner, abstract, reference, repository)

usethis::use_data(cheshire_petitions, overwrite = TRUE)
