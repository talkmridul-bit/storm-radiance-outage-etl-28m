library(tidyverse)
library(readr)

data_raw<- read_csv(file.choose())
data_raw

glimpse(data_raw)

final_storm_analized_28M_record_data<- data_raw %>% distinct() %>% 
  mutate(
    valid_pixels = as.integer(valid_pixels),
    light_ratio = as.numeric(light_ratio)
  ) %>%
  filter(valid_pixels >  0 & light_ratio > 0 ) %>%
  group_by(event_id) %>% 
  summarise(
    Avg_Valid_Pixels = mean(valid_pixels),
    Avg_light_ratio = mean(light_ratio),
    Total_Records = n(),
    .groups = 'drop'
  ) %>% arrange(Total_Records)

final_storm_analized_28M_record_data

write.csv(final_storm_analized_28M_record_data,
          'Storm_28M_record_data.csv',
          row.names = FALSE)
getwd()
