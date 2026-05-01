#Intro
#Subquery with filter()
#Subquery using semi_join()
#Anti-Subquery
#Subquery inside mutate()
#Correlated Subqueries (Group-wise)
#Subquery using summarise()
#Nested Subqueries
#Subqueries with exists logic
#Window-style Subqueries
#Subquery vs Join
#Real-World Patterns
#Performance Tips
#Key Functions Summary
#When NOT to Use Subqueries
#Final Insight

#Intro
#======
#What is a Subquery in dplyr?
#In SQL:
#SELECT * FROM flights 
#WHERE carrier IN (SELECT carrier FROM airlines WHERE name = 'Delta')

#Typically done using:
##filter()
##mutate()
##summarise()
##joins (inner_join, semi_join, etc.)

#generally they are two type of Subquery
#inline Subquery
#corelated subquery.

#Setup
#=====
library(tidyverse)
library(nycflights13)

flights <- nycflights13::flights
airlines <- nycflights13::airlines
airports <- nycflights13::airports
weather <- nycflights13::weather

#Subquery with filter() (MOST COMMON)
#====================================
#Basic Subquery using %in%
#Flights operated by selected airlines
selected_carriers <- airlines %>%
  filter(name %in% c("Delta Air Lines Inc.", "United Air Lines Inc.")) %>%
  pull(carrier)

flights %>%
  filter(carrier %in% selected_carriers)
#Equivalent to SQL IN (subquery)

#Inline Subquery
#An inline query acts like temp table, its run this internally query only once.
flights %>%
  filter(carrier %in% (
    airlines %>%
      filter(name == "Delta Air Lines Inc.") %>%
      pull(carrier)
  ))

#Using Conditions from Another Table
#Flights from airports with altitude > 500
high_alt_airports <- airports %>%
  filter(alt > 500) %>%
  pull(faa)

flights %>%
  filter(dest %in% high_alt_airports)

#Subquery using semi_join() (BEST PRACTICE)
#==========================================
#Cleaner and faster than %in%
flights %>%
  semi_join(
    airlines %>% filter(name == "Delta Air Lines Inc."),
    by = "carrier"
  )
#Why semi_join()?
##Keeps only matching rows
##Does not duplicate columns
##More efficient

#Anti-Subquery (NOT IN equivalent)
#=================================
flights %>%
  anti_join(
    airlines %>% filter(name == "Delta Air Lines Inc."),
    by = "carrier"
  )
#Equivalent to SQL:
#WHERE carrier NOT IN (...)

#Subquery inside mutate()
#========================
#Global aggregation subquery
#Compare each flight delay to average delay
avg_delay <- flights %>%
  summarise(avg = mean(arr_delay, na.rm = TRUE)) %>%
  pull(avg)

flights %>%
  mutate(delay_vs_avg = arr_delay - avg_delay)

#Inline subquery
flights %>%
  mutate(
    delay_vs_avg = arr_delay - (
      flights %>%
        summarise(avg = mean(arr_delay, na.rm = TRUE)) %>%
        pull(avg)
    )
  )

#Correlated Subqueries (Group-wise)
#===================================
#Equivalent to SQL correlated subqueries
# A corelated subqery to a column from the outer query . the innery query relies on the current row being processed by the outer query
# Run repeateably 
#Using group_by()
flights %>%
  group_by(carrier) %>%
  mutate(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    diff = arr_delay - avg_delay
  )

#Filter using group condition
#Flights with delay > carrier average
flights %>%
  group_by(carrier) %>%
  filter(arr_delay > mean(arr_delay, na.rm = TRUE))

#Subquery using summarise()
#==========================
#Aggregation based on filtered data
flights %>%
  filter(dest %in% (
    airports %>% filter(tz == -8) %>% pull(faa)
  )) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))

#Nested Subqueries (Multi-level)
#==================
flights %>%
  filter(dest %in% (
    airports %>%
      filter(faa %in% (
        flights %>%
          filter(arr_delay > 60) %>%
          pull(dest)
      )) %>%
      pull(faa)
  ))

#Subqueries with exists logic
#============================
#Using semi_join()
flights %>%
  semi_join(weather, by = c("origin", "time_hour"))
#Equivalent to SQL EXISTS

#Window-style Subqueries
#=======================
#Ranking within groups
flights %>%
  group_by(dest) %>%
  mutate(rank = dense_rank(desc(arr_delay))) %>%
  filter(rank <= 3)

#Subquery vs Join
#=================
#Scenario->Use
#Filtering existence->semi_join()
#Excluding matches->anti_join()
#Adding columns->left_join()
#Simple lookup->%in%

#Real-World Patterns
#===================
#Top delayed destinations
top_dest <- flights %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_delay)) %>%
  slice_head(n = 10)

flights %>%
  filter(dest %in% top_dest$dest)

#Flights in worst weather
bad_weather <- weather %>%
  filter(visib < 5)

flights %>%
  semi_join(bad_weather, by = c("origin", "time_hour"))

#Best airlines (least delay)
best_airlines <- flights %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  filter(avg_delay < 5)

flights %>%
  semi_join(best_airlines, by = "carrier")

#Performance Tips
#================
#Prefer:
##semi_join() over %in%
##joins over nested subqueries
##precomputing values instead of inline repeated queries

#Avoid:
##eeply nested subqueries
##repeated summarise() inside mutate()

#Key Functions Summary
#=====================
#Function->Role
#filter()->Row filtering using subquery
#%in%->Membership check
#pull()->Extract vector from subquery
#semi_join()->EXISTS
#anti_join()->NOT EXISTS
#mutate()->Derived columns
#group_by()->Correlated logic
#summarise()->Aggregation

#When NOT to Use Subqueries
#==========================
#Avoid when:

#You need multiple columns ->use joins
#You need better performance -> use joins
#Logic becomes nested -> refactor

#Final Insight
#=============
#In dplyr, subqueries are not a primary concept

#Instead:
##Joins + pipes = cleaner, faster, more readable than SQL subqueries

#Quiz
#====
  
#Assignment
#==========
AE<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/ae.csv")
DM<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/dm.csv")
VS<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/vs.csv")
EX<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/ex.csv")
LB<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/lb.csv")

#Resources:
#=========
#

                                                        