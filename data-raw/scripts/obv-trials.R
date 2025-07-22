library(tidyr)
library(dplyr)

obv_tsv <-
  readr::read_tsv(here::here("data-raw/obv_defendants_trials.tsv"), guess_max = 20000, na = c("", "NULL"))

# rename some columns to be a bit less opaque
# drop 1880 so it's 100 years and not 101!
obv_trials <-
  obv_tsv |>
  rename(session_date=sess_date, deft_speech=obv_def_spk, deft_speech_cat=speech,
         deft_q_count=deft_u_q, deft_a_count=deft_u_a, deft_d_count=deft_u_d, deft_os_count=deft_u_s,
         offence_cat=deft_offcat, offence_subcat=deft_offsub, verdict_cat=deft_vercat, verdict_subcat=deft_versub, sentence_cat=deft_puncat, sentence_subcat=deft_punsub) |>
  replace_na(list(trial_u_count=0, trial_speech_wc=0, trial_total_wc=0)) |>
  mutate(session_date = lubridate::parse_date_time(session_date, "ymd")) |>
  filter(year<1880)



usethis::use_data(obv_trials, overwrite = TRUE)
