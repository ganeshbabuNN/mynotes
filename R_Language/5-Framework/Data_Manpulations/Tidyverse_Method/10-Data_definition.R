#introduction
#Creating Variables -> mutate()
#Modifying Existing Variables
#Renaming Variables-> rename()
#Selecting / Defining Structure -> select()
#Data Type Conversion
#Handling Missing Values
#Creating Flags (Binary Variables)
#Categorization / Binning
#Working with Strings
#Combining Columns
#Splitting Columns
#Using across() for Bulk Definitions
#Conditional Mutation by Group
#Joining to Define New Data
#Creating Derived Tables
#Recoding Values
#Row-wise Definitions
#Advanced: Custom Functions in Data Definition
#Pipeline for Real Data Definition
#transmute() – Define and Drop Original Columns
#Window Functions (Advanced Data Definition)
#Cumulative Definitions
#Logical Aggregation Variables
#ntile() – Bucketization (Quantile-based)
#Dynamic Column Creation (Programmatic dplyr)
#cur_data() / cur_group() (Advanced context)
#Row Numbering / IDs
#Nested Data (List Columns)
#Conditional Column Selection in across()
#Custom Naming with .names
#Using pick() (Modern dplyr)
#Handling Infinite Values
#Data Validation While Defining
#Creating Composite Keys
#Defining Flags with Multiple Columns
#Using if_any() / if_all()
#Group-wise Scaling
#case_match() (Newer alternative to recode)
#Using External Lookup Tables
#Feature Engineering (ML-Level Definitions)
#Chained Definitions (Layered Mutations)
#Using with() inside mutate (less common)
#Defensive Programming in Pipelines
#Creating Analysis-Ready Dataset (Final Layer)

#introduction
#Creating Variables -> mutate()

#introduction
#============
#Data definition = creating new variables, recoding, renaming, typing, structuring

library(tidyverse)
library(nycflights13)

#Creating Variables -> mutate()
#===============================
#This is the core of data definition

#Basic variable creation
flights2 <- flights |> 
  mutate(
    gain = arr_delay - dep_delay,
    speed = distance / air_time * 60
  )
flights2

#Conditional definitions
flights2 <- flights %>%
  mutate(
    delay_type = if_else(arr_delay > 0, "Delayed", "On Time")
  )
flights2

#Multi-condition logic -> case_when()
flights2 <- flights %>%
  mutate(
    delay_category = case_when(
      arr_delay <= 0 ~ "On Time",
      arr_delay <= 30 ~ "Minor Delay",
      arr_delay <= 60 ~ "Moderate Delay",
      TRUE ~ "Severe Delay"
    )
  )

#Modifying Existing Variables
#============================
#Transform values
flights %>%
  mutate(
    dep_delay = abs(dep_delay)
  )

#Normalize / scale
flights %>%
  mutate(
    delay_z = (arr_delay - mean(arr_delay, na.rm = TRUE)) /
              sd(arr_delay, na.rm = TRUE)
  )

#Renaming Variables-> rename()
#=============================
flights %>%
  rename(
    departure_delay = dep_delay,
    arrival_delay = arr_delay
  )

#Rename with pattern
flights %>%
  rename(
    departure_delay = dep_delay,
    arrival_delay = arr_delay
  )

#Selecting / Defining Structure -> select()
#========================================
flights %>%
  select(year, month, day, dep_delay, arr_delay)

#Drop variables
flights %>%
  select(-tailnum, -time_hour)

#Reordering Variables
flights %>%
  relocate(arr_delay, dep_delay, .before = air_time)

#Data Type Conversion
#====================
#Convert types
flights %>%
  mutate(
    carrier = as.factor(carrier),
    dep_delay = as.numeric(dep_delay)
  )

#Date-time creation
flights %>%
  mutate(
    flight_date = as.Date(paste(year, month, day, sep = "-"))
  )

#Handling Missing Values
#=======================
#Replace NA
flights %>%
  mutate(
    arr_delay = coalesce(arr_delay, 0)
  )

#Flag missing
flights %>%
  mutate(
    missing_delay = is.na(arr_delay)
  )

#Creating Flags (Binary Variables)
#=================================
flights %>%
  mutate(
    is_delayed = arr_delay > 15,
    long_flight = distance > 2000
  )

#Categorization / Binning
#========================
flights %>%
  mutate(
    distance_group = cut(
      distance,
      breaks = c(0, 1000, 2000, 3000),
      labels = c("Short", "Medium", "Long")
    )
  )

#Working with Strings
#===================
library(stringr)

flights %>%
  mutate(
    carrier_upper = str_to_upper(carrier),
    carrier_prefix = str_sub(carrier, 1, 1)
  )

#Combining Columns
#=================
flights %>%
  mutate(
    route = paste(origin, dest, sep = "-")
  )

#Splitting Columns
#=================
library(tidyr)

flights %>%
  separate(time_hour, into = c("date", "time"), sep = "T")

#Using across() for Bulk Definitions
#===================================
#Apply transformation to multiple columns
flights %>%
  mutate(
    across(c(dep_delay, arr_delay), ~replace_na(., 0))
  )

#Create multiple derived variables
flights %>%
  mutate(
    across(c(dep_delay, arr_delay),
           list(abs = abs, sqrt = sqrt),
           .names = "{.col}_{.fn}")
  )

#Conditional Mutation by Group
#=============================
flights %>%
  group_by(carrier) %>%
  mutate(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    delay_vs_avg = arr_delay - avg_delay
  )

#Joining to Define New Data
#==========================
flights %>%
  left_join(airlines, by = "carrier")
#Now you have carrier full name → better data definition.

#Creating Derived Tables
#=======================
delay_summary <- flights %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))

#Recoding Values
#===============
flights %>%
  mutate(
    carrier = recode(carrier,
                     "UA" = "United",
                     "AA" = "American")
  )

#Row-wise Definitions
#====================
flights %>%
  rowwise() %>%
  mutate(
    total_delay = sum(c(dep_delay, arr_delay), na.rm = TRUE)
  )

#Advanced: Custom Functions in Data Definition
#=============================================
delay_flag <- function(x) {
  case_when(
    x <= 0 ~ "On Time",
    x <= 60 ~ "Moderate",
    TRUE ~ "Severe"
  )
}

flights %>%
  mutate(delay_status = delay_flag(arr_delay))

#Pipeline for Real Data Definition
#=================================
#This is how real analysts define data:
flights_clean <- flights %>%
  mutate(
    delay = arr_delay > 0,
    speed = distance / air_time * 60
  ) %>%
  filter(!is.na(arr_delay)) %>%
  left_join(airlines, by = "carrier") %>%
  rename(airline = name)

#Key Concepts Summary
#--------------------
#Core verbs for data definition:
##mutate() -> create/modify variables
##transmute() -> keep only new variables
##rename() -> rename columns
##select() -> structure data
##relocate() -> reorder columns

#Supporting tools:
#----------------
##case_when(), if_else()
##across()
##coalesce(), replace_na()
##cut(), recode()

#transmute() – Define and Drop Original Columns
#=============================================
#Keeps only newly defined variables.
flights %>%
  transmute(
    gain = arr_delay - dep_delay,
    speed = distance / air_time * 60
  )
#Used when building clean feature datasets

#Window Functions (Advanced Data Definition)
#===========================================
#Create variables based on relative row context

#Ranking
flights %>%
  group_by(carrier) %>%
  mutate(
    delay_rank = min_rank(desc(arr_delay))
  )

#Lag / Lead (time-based definitions)
flights %>%
  arrange(time_hour) %>%
  mutate(
    prev_delay = lag(arr_delay),
    next_delay = lead(arr_delay)
  )
#Critical for:
#Time series
#Sequential modeling

#Cumulative Definitions
#======================
flights %>%
  arrange(time_hour) %>%
  mutate(
    cumulative_delay = cumsum(replace_na(arr_delay, 0))
  )

#Logical Aggregation Variables
#=============================
flights %>%
  group_by(carrier) %>%
  mutate(
    any_delay = any(arr_delay > 60, na.rm = TRUE),
    all_on_time = all(arr_delay <= 0, na.rm = TRUE)
  )

#ntile() – Bucketization (Quantile-based)
#========================
flights %>%
  mutate(
    delay_bucket = ntile(arr_delay, 4)
  )
#Used in:
#Risk segmentation
#Customer scoring
#ML preprocessing

#Dynamic Column Creation (Programmatic dplyr)
#============================================
cols <- c("dep_delay", "arr_delay")

flights %>%
  mutate(across(all_of(cols), ~ . / 60))
#Important for:
#Reusable pipelines
#Automation

#cur_data() / cur_group() (Advanced context)
#===========================================
flights %>%
  group_by(carrier) %>%
  mutate(
    group_size = n(),
    group_name = cur_group()
  )

#Row Numbering / IDs
#===================
flights %>%
  mutate(row_id = row_number())

#Grouped
flights %>%
  group_by(carrier) %>%
  mutate(row_id = row_number())

#Nested Data (List Columns)
#==========================
nested_data <- flights %>%
  group_by(carrier) %>%
  summarise(data = list(cur_data()))
#Used in:
#Model per group
#Advanced workflows

#Conditional Column Selection in across()
#=======================================
flights %>%
  mutate(
    across(where(is.numeric), scale)
  )

#Custom Naming with .names
#=========================
flights %>%
  mutate(
    across(dep_delay:arr_delay,
           mean,
           .names = "mean_{.col}")
  )

#Using pick() (Modern dplyr)
#==========================
flights %>%
  mutate(
    total_delay = rowSums(pick(dep_delay, arr_delay), na.rm = TRUE)
  )

#Handling Infinite Values
#========================
flights %>%
  mutate(
    speed = distance / air_time,
    speed = if_else(is.infinite(speed), NA_real_, speed)
  )

#Data Validation While Defining
#==============================
#Very important in real datasets
flights %>%
  mutate(
    valid_delay = if_else(arr_delay < -100 | arr_delay > 1000, NA_real_, arr_delay)
  )

#Creating Composite Keys
#=======================
flights %>%
  mutate(
    flight_id = paste(year, month, day, flight, sep = "_")
  )

#Defining Flags with Multiple Columns
#====================================
flights %>%
  mutate(
    major_issue = dep_delay > 60 | arr_delay > 60
  )

#Using if_any() / if_all()
#=========================
flights %>%
  mutate(
    any_delay = if_any(c(dep_delay, arr_delay), ~ . > 0),
    all_delayed = if_all(c(dep_delay, arr_delay), ~ . > 0)
  )

#Group-wise Scaling
#==================
flights %>%
  group_by(carrier) %>%
  mutate(
    scaled_delay = scale(arr_delay)
  )

#case_match() (Newer alternative to recode)
#==========================================
flights %>%
  mutate(
    carrier_name = case_match(
      carrier,
      "UA" ~ "United",
      "AA" ~ "American",
      .default = "Other"
    )
  )

#Using External Lookup Tables
#============================
carrier_lookup <- tibble(
  carrier = c("UA", "AA"),
  type = c("Full Service", "Legacy")
)

flights %>%
  left_join(carrier_lookup, by = "carrier")

#Feature Engineering (ML-Level Definitions)
#==========================================
flights %>%
  mutate(
    is_weekend = weekdays(time_hour) %in% c("Saturday", "Sunday"),
    night_flight = dep_time < 600 | dep_time > 2200
  )

#Chained Definitions (Layered Mutations)
#=======================================
flights %>%
  mutate(delay = arr_delay > 0) %>%
  mutate(delay_score = if_else(delay, arr_delay, 0))

#Using with() inside mutate (less common)
#========================================
flights %>%
  mutate(
    ratio = with(., distance / air_time)
  )

#Defensive Programming in Pipelines
#==================================
flights %>%
  mutate(
    air_time = if_else(air_time == 0, NA_real_, air_time),
    speed = distance / air_time
  )

#Creating Analysis-Ready Dataset (Final Layer)
#===============================
final_data <- flights %>%
  filter(!is.na(arr_delay)) %>%
  mutate(
    delay_flag = arr_delay > 15,
    speed = distance / air_time * 60
  ) %>%
  select(carrier, delay_flag, speed, distance)

#Final Truth (Very Important)
#----------------------------
#Data definition in real projects has 3 layers:
##Layer 1: Basic
##mutate, select, rename
#Layer 2: Analytical
#grouping, ranking, lag, buckets
#Layer 3: Production / ML
#validation
#feature engineering
#automation (across, programmatic dplyr)
#robustness


#Quiz
#====
  
#Assignment
#==========
AE<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/ae.csv")
DM<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/dm.csv")
VS<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/vs.csv")
EX<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/ex.csv")
LB<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/lb.csv")

s and discontinued study. Join AE + DS.

#Resources:
#=========