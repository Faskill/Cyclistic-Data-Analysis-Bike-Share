install.packages("bigrquery")
install.packages("tidyverse")
install.packages("wk")
install.packages("lubridate")

library(bigrquery)
library(tidyverse)
library(wk)
library(lubridate)

con <- dbConnect(
  bigrquery::bigquery(),
  project = "cyclistic-case-study-349908",
  dataset = "cyclistic",
  billing = "cyclistic-case-study-349908"
)

trips = tbl(con,"trips")
glimpse(trips)


member_summary <- 
  trips %>%
  group_by(member_casual) %>%
  summarise(
    average_length=mean(length_min, na.rm = TRUE),
    min_length=min(length_min, na.rm = TRUE),
    max_length=max(length_min, na.rm = TRUE),
    average_distance=mean(distance_m, na.rm = TRUE),
    max_distance=max(distance_m, na.rm = TRUE),
    min_distance=min(distance_m, na.rm = TRUE))%>% 
  collect() 

#Downloading Length information from Bigquery and creating Month_Year Column
#The collect() is required to pull data from Bigquery and store it locally
length_info <-
  trips %>% 
  select(member_casual,started_at,length_min,rideable_type) %>% 
  collect() %>% 
  mutate(month_year = factor(format(started_at, "%y-%m"), levels = 
           c("May-21","Jun-21","Jul-21","Aug-21","Sep-21","Oct-21","Nov-21","Dec-21","Jan-22","Feb-22","Mar-22","Apr-22")))

# Creating Length Per Month graph
length_info %>% 
  filter(length_min<1440) %>% 
  group_by(month_year,member_casual) %>% 
  summarise(average_length = mean(length_min)) %>% 
  ggplot() + geom_col(aes(x=month_year,y=average_length,fill=member_casual),position = 'dodge') + 
  labs(fill="Member Type", x="Month", y="Ride Length")

# Comparing Length to bike_type
length_info %>% 
  filter(length_min<1440) %>% 
  group_by(rideable_type,member_casual) %>% 
  summarise(average_length = mean(length_min)) %>% 
  ggplot() + geom_col(aes(x=rideable_type,y=average_length,fill=member_casual),position = 'dodge') + 
  labs(fill="Member Type", x="Bike Type", y="Ride Length")

distance_info <-
  trips %>% 
  select(member_casual,started_at,distance_m,rideable_type) %>% 
  collect() %>% 
  mutate(month_year = factor(format(started_at, "%y-%m"), levels = 
                               c("May-21","Jun-21","Jul-21","Aug-21","Sep-21","Oct-21","Nov-21","Dec-21","Jan-22","Feb-22","Mar-22","Apr-22")))
