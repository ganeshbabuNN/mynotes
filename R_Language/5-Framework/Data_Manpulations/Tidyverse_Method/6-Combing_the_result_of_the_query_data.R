#Intro
#Row-Wise COmbining -> bind_rows()
#Column-wise Combining -> bind_cols()
#Combining via JOINS
#Combine raw + summary data
#Conditional Combining
#Combining Multiple Queries in Pipeline
#Combining Group-wise Results
#Set operations - Combining with rows 
#Combining Lists of DataFrames
#Advanced Pattern (Real Analytics)
#Combining with Window Functions
#Handling NA While Combining
#Performance Tips
#Real-World Workflow
#Non-Equi Joins (Advanced Matching Logic)
#Rolling / Closest Match Joins
#Semi Join & Anti Join (Filtering via Combine)
#Nest + Unnest (Combining Hierarchical Queries)
#Combining with rowwise()
#Pivot + Combine (Reshape + Merge)
#Window + Join Combo (Very Powerful)
#Self Joins (Compare Within Same Table)
#Incremental Combining (Streaming Style)
#Conditional Joins using case_when() + Join
#Many-to-Many Join Handling
#Combining with Validation Checks
#Using across() for Multi-column Combine
#Combining with Custom Functions
#Combining with Multiple Joins (Pipeline Design)
#Conflict Resolution in Combine
#Combining Logical Conditions Across Tables
#Combining Outputs into Reports
#Combining for Machine Learning Pipelines


library(tidyverse)
library(nycflights13)

flights
view(flights)

#Intro
#======
#In real data analysis, you often:
##Run multiple queries
##Get different result tables
##Then combine them into one meaningful datase

#common patterns
#Scenario --> Method
#Stack Rows --> bind_rows()
#combine columns --> bind_cols()
#Merge Datasets --> *_join()
#conditional combine --> coalesce(),case_when()
#combine Summaries --> summarise()+ joins
#combine grouped outputs --> group_modify()

#Row-Wise COmbining -> bind_rows()
#=================================
#use when datasets have same Columns
jan_flights <- flights %>% filter(month == 1)
feb_flights <- flights %>% filter(month == 2)

combined <- bind_rows(jan_flights, feb_flights)
combined

#Column-wise Combining -> bind_cols()
#===================================
#Used when datasets have same number of rows
df1 <- flights %>% select(flight, origin)
df2 <- flights %>% select(dest, air_time)

combined <- bind_cols(df1, df2)
combined
#Risk:
#No key matching → purely positional

#Combining via JOINS (Most Important)
#====================================
#This is core real-world combining

#Inner Join
#Only matching rows
flights %>%
  inner_join(airlines, by = "carrier")

#Left Join (Most Used)
#Keep all flights, add airline info
flights %>%
  left_join(airlines, by = "carrier")

#Right Join
flights %>%
  right_join(airlines, by = "carrier")

#Full Join
flights %>%
  full_join(airlines, by = "carrier")

#Everything from both tables

#Multi-key Join
#---------------
weather %>%
  inner_join(flights, by = c("origin", "time_hour"))

#Different Column Names
#-----------------------
df1 %>% inner_join(df2, by = c("carrier" = "airline_code"))

#Handling Duplicate Columns
#--------------------------
inner_join(df1, df2, by = "id", suffix = c("_flight", "_airline"))

#Combine raw + summary data
#============================
#Combining Aggregated Results
#Compare average delays by airline
avg_delay <- flights %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))

flights %>%
  left_join(avg_delay, by = "carrier")


#Conditional Combining
#=====================
#coalesce() (merge columns)
flights %>%
  mutate(delay = coalesce(arr_delay, dep_delay)) |> 
  select(flight,arr_delay,dep_delay,delay) |> filter(is.na(arr_delay))
#Take first non-NA value

#case_when()
flights %>%
  mutate(delay_type = case_when(
    arr_delay > 60 ~ "Heavy",
    arr_delay > 15 ~ "Moderate",
    TRUE ~ "On Time"
  ))

#Combining Multiple Queries in Pipeline
#======================================
#Multi-step combination
#Filter → Aggregate → Combine
flights %>%
  filter(month <= 3) %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  left_join(airlines, by = "carrier")

#Combining Group-wise Results
#============================
#group_modify()
flights %>%
  group_by(carrier) %>%
  group_modify(~ summarise(.x, avg = mean(arr_delay, na.rm = TRUE)))

#Set operations - Combining with rows 
#====================================
#Set operations treat data frames like mathematical sets of rows

#Set operations
#union() - Combine unique rows
#union_all()- Combine all rows (keep duplicates)
#intersect() -- Common rows
#setdiff() - Rows in A but not in B
#sysmdiff() - Rows in either A or B but not both

#Important Rule
## same column names
## same data types

a <- tibble(
  id=c(1,2,3,4),
  name=c("ganesh","Ravi","Sita","Anu")
)

b<- tibble(
  id=c(3,4,5,6),
  name=c("Sita","Anu","Kiran","John")
)

print(a)
print(b)

#union- combine unique rows
union(a,b)
#Behavior:
#Removes duplicates
#Similar to SQL UNION

#union_all() --> keep rows
union_all(a,b)
#Faster than union()
#Keeps duplicate rows

#interact()-common rows
intersect(a,b)
#Rare in flights (because months differ)
#Useful when checking:
#Duplicate datasets
#Overlapping records

#setdiff--> A minus B
setdiff(a,b) #present A but not in B
setdiff(b,a) #B minus A
#Rows in January but NOT in February

#symdiff()- exlusve rows
symdiff(a,b)
union(a,b)
#Rows present in only one dataset
#removes common rows, keep only unique ones

#Real-World Use Cases
#--------------------
#Data Validation
#Detect missing records
setdiff(df1, df2)

#Duplicate Detection
duplicates <- df %>%
  bind_rows(df) %>%
  intersect(df)

#Incremental Data Load
#Only new records
new_data <- setdiff(current_data, old_data)

#Reconciliation (Very Important in SDTM)
missing_records <- setdiff(source_data, target_data)

#Combining with bind_rows() vs union()
#Feature->bind_rows()->	union()
#Duplicates->	Kept->	Removed
#Speed->Fast->	Slower
#Use case->	Raw combine->	Clean combine

#Column Order Issue
# WRONG
union(df1, df2)
#If column order differs → incorrect results
df2 <- df2 %>% select(names(df1))
union(df1, df2)

#Handling NA in Set Ops
#NA == NA is treated as equal in set operations
#So rows with NA can match

#Partial Set Operations
#If you want to compare only some columns:
intersect(
  jan %>% select(flight, carrier),
  feb %>% select(flight, carrier)
)

#Set Operations + Joins
#----------------------
flights %>%
  semi_join(airlines, by = "carrier") %>%
  intersect(flights)

#Performance Insight
#-------------------
#union_all()->fastest
#union() ->slower (removes duplicates)
#intersect() / setdiff() -> medium

#Common Mistakes
##Different column names
##Different data types
##Expecting partial matching (it is full row match)
##Using union() instead of bind_rows()

#Final Mental Model
#bind_rows() -->stack everything  
#union()     -->stack unique  
#intersect()-->keep common  
#setdiff()  --> find missing  
#symdiff()  --> find mismatch

#Combining Lists of DataFrames
#=============================
jan_flights <- flights %>% filter(month == 1)
feb_flights <- flights %>% filter(month == 2)
mar_flights <- flights %>% filter(month == 3)
list_df <- list(jan_flights, feb_flights, mar_flights)
bind_rows(list_df)

#Advanced Pattern (Real Analytics)
#=================================
#Combine delays + weather impact
flights %>%
  left_join(weather, by = c("origin", "time_hour")) %>%
  group_by(origin) %>%
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    avg_wind = mean(wind_speed, na.rm = TRUE)
  )

#Combining with Window Functions
#===============================
#Combines row-level + group-level info
flights %>%
  group_by(carrier) %>%
  mutate(rank_delay = rank(desc(arr_delay)))

#Handling NA While Combining
#===========================
flights %>%
  left_join(airlines, by = "carrier") %>%
  replace_na(list(name = "Unknown Airline"))

#Performance Tips
#=================
#Use select() before joins -> reduce size
#Use indexed keys (in databases)
#Avoid bind_cols() unless safe
#Prefer left_join() in pipelines

#Real-World Workflow
#===================
flights %>%
  filter(!is.na(arr_delay)) %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  left_join(airlines, by = "carrier") %>%
  arrange(desc(avg_delay))
#This combines:
#Filtering
#Aggregation
#Join
#Final output

#Common Mistakes
#---------------
##Wrong join key
##Duplicate rows after join
##Using bind_cols() instead of join
##Ignoring NA handling
##Not checking row counts

#Quick Syntax Summary
#--------------------
#Task	Function
#Stack rows-->	bind_rows()
#Stack columns-->	bind_cols()
#Merge tables-->	*_join()
#Combine columns-->	coalesce()
#Conditional combine-->	case_when()
#Set operations-->	union(), intersect()

#Non-Equi Joins (Advanced Matching Logic)
#========================================
#Join based on conditions (not exact equality)
flights %>%
  left_join(weather, 
            by = join_by(origin, time_hour >= time_hour))
#Use cases:
##Closest timestamp matching
##Range joins (clinical data, finance)

#Rolling / Closest Match Joins
#==============================
flights %>%
  left_join(weather, 
            by = join_by(origin, closest(time_hour)))
#Matches nearest weather record

#Semi Join & Anti Join (Filtering via Combine)
#=============================================
#Semi Join (exists in other table)
#Keeps only matching rows (no columns added)
flights %>%
  semi_join(airlines, by = "carrier")

#Anti Join (not exists)
flights %>%
  anti_join(airlines, by = "carrier")
#Detect data issues

#Cross Join (Cartesian Product)
flights %>%
  cross_join(airlines)
#Every combination
#Dangerous: huge data explosion

#Nest + Unnest (Combining Hierarchical Queries)
#==============================================
library(tidyr)

nested <- flights %>%
  group_by(carrier) %>%
  nest()

nested %>%
  unnest(cols = data)
#Combine grouped datasets into list-columns

#Combining with rowwise()
#========================
flights %>%
  rowwise() %>%
  mutate(total_delay = sum(c_across(dep_delay:arr_delay), na.rm = TRUE))
#Combine columns per row dynamically

#Pivot + Combine (Reshape + Merge)
#=================================
library(tidyr)

flights %>%
  group_by(month, carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  pivot_wider(names_from = carrier, values_from = avg_delay)
#Combine grouped results into wide format

#Window + Join Combo (Very Powerful)
#===================================
ranked <- flights %>%
  group_by(carrier) %>%
  mutate(rank = min_rank(desc(arr_delay)))

flights %>%
  left_join(ranked %>% select(flight, rank), by = "flight")
#Combine ranking logic with original data

#Self Joins (Compare Within Same Table)
#======================================
flights %>%
  inner_join(flights, by = "carrier", suffix = c("_1", "_2"))
#Compare:
#Same airline flights
#Time differences

#Incremental Combining (Streaming Style)
#=======================================
result <- flights %>% filter(month == 1)

for (m in 2:3) {
  temp <- flights %>% filter(month == m)
  result <- bind_rows(result, temp)
}
#Useful for:
##Large datasets
##Batch processing

#Conditional Joins using case_when() + Join
#==========================================
flights %>%
  mutate(category = case_when(
    arr_delay > 60 ~ "High",
    TRUE ~ "Low"
  )) %>%
  left_join(summary_table, by = "category")
#Combine logic + lookup table

#Many-to-Many Join Handling
#==========================
#Critical real-world issue
flights %>%
  inner_join(weather, by = "origin")
#May duplicate rows
flights %>%
  distinct(origin, .keep_all = TRUE) %>%
  inner_join(weather, by = "origin")

#Combining with Validation Checks
#================================
result <- flights %>%
  left_join(airlines, by = "carrier")

stopifnot(nrow(result) == nrow(flights))
#Ensures no unintended duplication

#Using across() for Multi-column Combine
#=======================================
#Combine transformation across multiple columns
flights %>%
  mutate(across(ends_with("delay"), ~ replace_na(.x, 0)))

#Combining with Custom Functions
#===============================
combine_delay <- function(df) {
  df %>%
    summarise(avg = mean(arr_delay, na.rm = TRUE))
}

flights %>%
  group_by(carrier) %>%
  group_modify(~ combine_delay(.x))

#Combining with Multiple Joins (Pipeline Design)
#===============================================
flights %>%
  left_join(airlines, by = "carrier") %>%
  left_join(airports, by = c("origin" = "faa")) %>%
  left_join(weather, by = c("origin", "time_hour"))
#Real-world data enrichment pipeline

#Conflict Resolution in Combine
#==============================
#Priority-based combining
mutate(
  final_delay = coalesce(arr_delay, dep_delay, 0)
)

#Combining Logical Conditions Across Tables
#==========================================
#Multi-table condition filtering
flights %>%
  left_join(weather, by = c("origin", "time_hour")) %>%
  filter(arr_delay > 30 & wind_speed > 10)

#Combining Outputs into Reports
#==============================
list(
  summary = flights %>% summarise(avg = mean(arr_delay, na.rm = TRUE)),
  by_carrier = flights %>% group_by(carrier) %>% summarise(avg = mean(arr_delay, na.rm = TRUE))
)

#Combining for Machine Learning Pipelines
#========================================
model_data <- flights %>%
  left_join(weather, by = c("origin", "time_hour")) %>%
  select(arr_delay, dep_delay, wind_speed, temp) %>%
  drop_na()
model_data

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
#

                                                        