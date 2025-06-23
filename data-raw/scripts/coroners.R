library(readr)
library(lubridate)
library(stringr)
library(dplyr)

# tsv originated in MySQL database, "NULL" -> NA.
# some dates are invalid for R, so don't let readr convert them.
coroners_tsv <-
  read_tsv(here::here("data-raw/wa_coroners_inquests_v1-1.tsv"),
                  na="NULL", col_types = cols(doc_date = col_character()))

# fix doc dates - a few end -00 -> -01
# then add doc year and doc month
# simplify verdict - merge suicides
# filter out:
# unknown/mixed gender and type multi
# unknown verdict (not the same as 'undetermined')
# a date pre 1760, possibly a typo

coroners <-
  coroners_tsv |>
  mutate(gender = case_when(
    gender == "f" ~ "female",
    gender == "m" ~ "male",
    .default = gender),
    doc_date = as_date(str_replace(doc_date, "00$", "01")),
    doc_year = year(doc_date),
    doc_month = month(doc_date, label = TRUE),
    verdict = if_else(str_detect(verdict, "suicide"), "suicide", verdict)
  ) |>
  relocate(doc_year, doc_month, .after = doc_date) |>
  filter(doc_year > 1759,
         str_detect(gender, "male"),
         !str_detect(deceased_additional_info, "multi"),
         verdict !="-") |>
  tibble::rowid_to_column()


usethis::use_data(coroners, overwrite = TRUE)
