#introductions
#IMPORTING DATA
#DATA VALIDATION AFTER IMPORT
#USING dplyr AFTER IMPORT
#EXPORTING DATA
#PIPELINE WORKFLOW (REAL PROJECT STYLE)
#PERFORMANCE & BEST PRACTICES
#COMMON REAL-WORLD SCENARIOS
#COMMON MISTAKES
#COMPLETE ECOSYSTEM VIEW
#FINAL SUMMARY

#Introductions
#=============



#IMPORTING DATA
#==============
#CSV (Most Common)
flights_csv <- read_csv("flights.csv")

#Key Concepts
#Automatic column type detection
#Fast reading
#Handles large files efficiently

# Control column types
flights_csv <- read_csv("flights.csv",
                        col_types = cols(
                          year = col_integer(),
                          dep_delay = col_double()
                        ))

#TSV / Delimited Files
read_tsv("flights.tsv")
read_delim("flights.txt", delim = "|")

#Excel Files
library(readxl)

flights_excel <- read_excel("flights.xlsx", sheet = 1)
#Advanced
read_excel("flights.xlsx", range = "A1:F100")

#R Native Formats
# RDS (single object)
saveRDS(flights, "flights.rds")
flights_rds <- readRDS("flights.rds")

# RData (multiple objects)
save(flights, file = "flights.RData")
load("flights.RData")

#JSON
library(jsonlite)

flights_json <- fromJSON("flights.json")

#Databases (SQL)
library(DBI)
con <- dbConnect(RSQLite::SQLite(), "flights.db")

flights_db <- tbl(con, "flights")
#Important:
#tbl() creates a lazy table
#dplyr verbs run in SQL (not in memory)

flights_db %>%
  filter(dep_delay > 60) %>%
  collect()

#Big Data (Parquet / Arrow)
library(arrow)

write_parquet(flights, "flights.parquet")
flights_parquet <- read_parquet("flights.parquet")
#Benefits:
#Faster than CSV
#Compressed
#Used in data engineering pipelines

#DATA VALIDATION AFTER IMPORT
#============================
glimpse(flights_csv)
summary(flights_csv)
#Common Issues
##Wrong column types
##Missing values
##Encoding problems

# Fix types
flights_csv <- flights_csv %>%
  mutate(dep_delay = as.numeric(dep_delay))

#USING dplyr AFTER IMPORT
#========================
clean_data <- flights_csv %>%
  filter(!is.na(dep_delay)) %>%
  mutate(delay_hours = dep_delay / 60) %>%
  group_by(origin) %>%
  summarise(avg_delay = mean(dep_delay))

#This is where dplyr shines:
#filter()
#mutate()
#group_by()
#summarise()

#EXPORTING DATA
#==============
#CSV
write_csv(clean_data, "clean_flights.csv")

#Excel
library(writexl)
write_xlsx(clean_data, "clean_flights.xlsx")

#RDS (Best for R workflows)
saveRDS(clean_data, "clean_flights.rds")

#Database Export
dbWriteTable(con, "clean_flights", clean_data, overwrite = TRUE)

#Parquet (Big Data)
write_parquet(clean_data, "clean_flights.parquet")

#JSON
library(jsonlite)
write_json(clean_data, "clean_flights.json")

#PIPELINE WORKFLOW (REAL PROJECT STYLE)
#======================================
library(dplyr)
library(readr)

final_output <- read_csv("flights.csv") %>%
  filter(dep_delay > 30) %>%
  mutate(delay_hours = dep_delay / 60) %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_delay))

write_csv(final_output, "final_report.csv")
#This is the industry-standard pipeline
#Import -> Transform -> Export

#PERFORMANCE & BEST PRACTICES
#============================'
#Use readr instead of base R
read_csv()  # faster than read.csv()

#Use Parquet for large data
arrow::read_parquet()

#Use lazy DB queries
tbl(con, "flights")

#Always validate
glimpse()

#COMMON REAL-WORLD SCENARIOS
#===========================
#Scenario 1: Multiple Files
files <- list.files("data/", full.names = TRUE)

data <- files %>%
  lapply(read_csv) %>%
  bind_rows()

#Scenario 2: Incremental Data Loading
old <- read_csv("old_data.csv")
new <- read_csv("new_data.csv")

combined <- bind_rows(old, new)

#Scenario 3: Export Summary Reports
flights %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE)) %>%
  write_csv("destination_report.csv")

#COMMON MISTAKES
#===============
#Wrong: Thinking dplyr imports data
#Right: It transforms data

#Wrong:Forgetting collect() in DB
#Right: Always bring data into memory when needed

#Wrong: Writing large CSV repeatedly
#Right: Use Parquet or database

#COMPLETE ECOSYSTEM VIEW
#=======================
#Task->Tool
#Import CSV->	readr
#Import Excel->	readxl
#Transform->dplyr
#Export->	readr / writexl
#Big Data->	arrow
#Databases->DBI + dplyr

#FINAL SUMMARY
#-------------
#dplyr = data manipulation engine
#readr/readxl = import tools
#writexl/arrow = export tools
#Together → complete data pipeline

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

                                                        