#Introductions
#Handling the CSV file
#Handling the Excel file
#Handling the TSV file
#Handling Txt Files using base R
#Handling the delimiter file
#Handling with Fixed Width Files (FWF)
#Handling the RDS files
#Handling the .RData files
#Handling the fst files
#Handling the JSON files
#Handling the XML files
#Handling YAML Files in R
#Handling parquet Files(Big Data)
#Handling Feather Files(Big Data)
#Handling Arrow Files(Big Data)
#Handling with mySQL Database
#Validating Data after import 

#Introductions
#=============


#Handling the CSV file
#======================
library(readxl)
library(writexl)
library(dplyr)
library(nycflights13)

#Writing a CSV
#--------------
#Syntax
write_csv(x, file, na = "NA", append = FALSE,
          col_names = !append,
          quote = c("needed", "all", "none"),
          escape = c("double", "backslash"),
          eol = "\n",
          num_threads = readr_threads(),
          progress = show_progress(),
          path = deprecated(),
          quote_escape = deprecated())

#1. x Parameter
#The data frame or tibble to export.
#Export Full Flights Dataset
write_csv(flights, "flights.csv")
#Export Filtered Data
late_flights <- flights %>%
  filter(arr_delay > 60)
write_csv(late_flights, "late_flights.csv")

#2. file Parameter
#Specifies CSV output path.
#Custom Path
write_csv(flights,file = "C:\\Users\\ganes\\Downloads\\R_test\\flights.csv")
#Temporary File
temp_file <- tempfile(fileext = ".csv")
write_csv(flights, temp_file)
temp_file

#3. na Parameter
#Controls how missing values are written.
colSums(is.na(flights))
#Replace Missing Values with Blank
#Missing values become empty cells.
write_csv(flights,"flights_blank_na.csv",na = "")
#Custom Missing Value Text
write_csv(flights,"flights_missing.csv",na = "Missing")

#4.append Parameter
#Adds rows to existing CSV file.
#Append More Flights
jan_flights <- flights %>%
  filter(month == 1)
feb_flights <- flights %>%
  filter(month == 2)
write_csv(jan_flights,"monthly_flights.csv")
write_csv(feb_flights,"monthly_flights.csv",append = TRUE)
#February rows are added below January rows.

#5. col_names Parameter
#Controls whether column names are written.
#Meaning:
#First write -> headers included
#Append ->  headers excluded automatically
#Include Headers
write_csv(flights,"with_headers.csv",col_names = TRUE)
#Exclude Headers
write_csv(flights,"without_headers.csv",col_names = FALSE)

#6. quote Parameter
#Controls quoting behavior.
#Options:
#"needed" (default)
#"all"
#"none"

#Quote Only When Needed
write_csv(flights,"quote_needed.csv",quote = "needed")
#Quote Everything
write_csv(flights,"quote_all.csv",quote = "all")
#No Quotes
write_csv(flights,"quote_none.csv",quote = "none")
#Useful for systems that reject quotes.

#7. escape
#Controls escaping style.
#Options:
#"double" (default)
#"backslash"

#Double Quote Escaping
airports_1 <-airports |> slice(1:5) |> mutate(
    remarks = c(
      'Pilot said "Delayed due to weather"',
      'Passenger said "Very good flight"',
      'Path: C:\\Flights\\Logs',
      'Quote and slash: "Error\\Warning"',
      'Normal text'
    )
  )

write_csv(airports_1,"double_escape.csv",escape = "double")
# Text as : "He said ""hello"" "
#Backslash Escaping
write_csv(airports_1,"backslash_escape.csv",escape = "backslash")
#"He said \"hello\""

#8. eol Parameter
#Controls end-of-line character.
#Windows Line Endings
write_csv(flights,"windows.csv",eol = "\r\n")
#Useful for older Windows systems.

#9.num_threads Parameter
#Controls parallel writing threads.
readr_threads()
#Use Single Thread
write_csv(flights,"single_thread.csv",num_threads = 1)
#Use Multiple Threads
write_csv(flights,"multi_thread.csv",num_threads = 4)
#Faster for huge datasets.

#10. progress Parameter
#Show progress bar during export.
show_progress()
#Disable Progress Bar
write_csv(flights,"no_progress.csv",progress = FALSE) # this are seen in UI

#11. path (Deprecated)
#Old argument replaced by file.

#12. quote_escape (Deprecated)
#Old version of escape.

#Real Data analysis
#Export Delayed Flights Report
delay_report <- flights %>%
  filter(arr_delay > 120) %>%
  select(
    year, month, day,
    carrier, flight,
    origin, dest,
    arr_delay
  )
write_csv(delay_report,"delay_report.csv")

#Export Carrier Summary
carrier_summary <- flights %>%
  group_by(carrier) %>%
  summarise(
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    total_flights = n()
  )

write_csv(carrier_summary,
          "carrier_summary.csv")

#Export Cleaned Dataset
clean_flights <- flights %>%
  filter(
    !is.na(dep_delay),
    !is.na(arr_delay)
  ) %>%
  distinct()
write_csv(clean_flights,"clean_flights.csv")

#Daily Automated Export
daily_file <- paste0(
  "flights_",
  Sys.Date(),
  ".csv"
)
write_csv(flights,daily_file)

#Export Top 100 Longest Flights
monthly_summary <- flights %>%
  group_by(month) %>%
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    total_flights = n()
  )

write_csv(monthly_summary,
          "monthly_summary.csv")

#Export Grouped Results
monthly_summary <- flights %>%
  group_by(month) %>%
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    total_flights = n()
  )

write_csv(monthly_summary,
          "monthly_summary.csv")

#Common Workflow
flights %>%
  filter(dep_delay > 60) %>%
  group_by(carrier) %>%
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE)
  ) %>%
  write_csv("carrier_delay.csv")

#Reading the csv file
#---------------

#Load Libraries
library(readxl)
library(writexl)
library(dplyr)
library(nycflights13)

#Basic Syntax
read_csv(
  file,
  col_names = TRUE,
  col_types = NULL,
  col_select = NULL,
  id = NULL,
  locale = default_locale(),
  na = c("", "NA"),
  quoted_na = TRUE,
  quote = "\"",
  comment = "",
  trim_ws = TRUE,
  skip = 0,
  n_max = Inf,
  guess_max = min(1000, n_max),
  progress = show_progress(),
  name_repair = "unique",
  num_threads = readr_threads(),
  show_col_types = TRUE,
  skip_empty_rows = TRUE,
  lazy = should_read_lazy()
)

setwd("C:\\Users\\ganes\\Downloads\\R_test\\testing")
#First Create CSV File for Testing
write_csv(flights, "flights.csv")

#1. file
#--------
#CSV file path, URL, or connection.
#Read Flights CSV
flights_data <- read_csv("flights.csv")
#Read From URL
read_csv("https://raw.githubusercontent.com/ganeshbabuNN/mydatasets/refs/heads/master/pandas-Datasets/nycflights13/flight.csv")

#2. col_names
#------------
#Controls column names.
#File Has Headers
read_csv("flights.csv",col_names = TRUE)
#No Headers
read_csv("flights.csv",col_names = FALSE)
#Custom Names
read_csv(
  "flights.csv",
  col_names = c(
    "yr",
    "mn",
    "dy",
    "dep_time"
  )
)

#3. col_types
#------------
#Manually define column data types.
#Common Type Codes
#Code	Type
#c	character
#i	integer
#d	double
#l	logical
#D	date
#T	datetime
#t	time
#_	skip column

#Specify Types
read_csv(
  "flights.csv",
  col_types = cols(
    year = col_integer(),
    carrier = col_character(),
    dep_delay = col_double()
  )
)
#Compact Type String
read_csv(
  "flights.csv",
  col_types = "iiic"
) |> glimpse()
#Skip Columns
#hides the columns
read_csv(
  "flights.csv",
  col_types = cols(
    tailnum = col_skip()
  )
)

#4. col_select
#--------------
#Read only selected columns.
#Very important for big data.

#Read Selected Columns
read_csv(
  "flights.csv",
  col_select = c(
    year,
    month,
    carrier,
    arr_delay
  )
)
#Tidyselect Style
read_csv(
  "flights.csv",
  col_select = starts_with("dep")
)

#5. id
#------
#Adds source filename column.
#Useful when reading multiple files.
read_csv(
  "flights.csv",
  id = "source_file"
)

#for multiple files
write_csv(airports,"airports.csv")
write_csv(airlines,"airlines.csv")
files <- c("airports.csv", "airlines.csv","flights.csv")
combined_data <- read_csv(files, id = "filename")

#6. locale
#---------
#Controls locale settings.
#Important for:
#dates
#decimals
#encoding

#European Decimal
read_csv(
  "flights.csv",
  locale = locale(decimal_mark = ",")
)

#UTF-8 Encoding
read_csv(
  "flights.csv",
  locale = locale(encoding = "UTF-8")
)

#7. na
#-----
#Defines missing value strings. c("", "NA")
#Custom Missing Values
read_csv(
  "flights.csv",
  na = c("", "NA", "NULL", "Missing")
)

#8. quoted_na
#------------
#Treat "NA" inside quotes as missing.
read_csv(
  "flights.csv",
  quoted_na = FALSE
)

#9. quote
#--------
#Quote character.
#Single Quote CSV
read_csv(
  "flights.csv",
  quote = "'"
)

#10. comment
#-----------
#Ignore comment lines.
read_csv(
  "flights.csv",
  comment = "#"
)

#11. trim_ws
#-----------
#Trim whitespace.
a <-c("  dd f"," dd ")
trimws(a)

read_csv(
  "flights.csv",
  trim_ws = FALSE
)

#12. skip
#--------
#Skip rows at beginning.
#Skip Metadata
read_csv(
  "flights.csv",
  skip = 2
)

#13. n_max
#---------
#Maximum rows to read.
#Read First 100 Rows
read_csv(
  "flights.csv",
  n_max = 100
)

#14. guess_max
#-------------
#Rows used for type guessing.
#Better Type Guessing
read_csv(
  "flights.csv",
  guess_max = 10000
)
#Useful when types appear later in file.

#15. progress
#------------
#Show progress bar.
read_csv(
  "flights.csv",
  progress = FALSE
)

#16. name_repair
#---------------
#Fix duplicate/invalid names.
#Options:
#"unique"
#"minimal"
#"check_unique"
#"universal"

read_csv(
  "flights.csv",
  name_repair = "universal"
)

read_csv(
  "flights.csv",
  name_repair = "unique"
)

#test.CSV
#name,name,id,age
#ganesh,swe,1,34
#ganesh1,sara,3,43

#name_repair
#unique-Make sure names are unique and not empty.
#minimal-No name repair or checks, beyond basic existence of names
#check_unique-No name repair, but check they are unique
#unique_quiet-Repair with the unique strategy, quietly
#universal-#Make the names unique and syntactic
#universal_quiet -Repair with the universal strategy, quietly.
read_csv("test.csv",name_repair = "unique")#Make sure names are unique and not empty.
read_csv("test.csv",name_repair = "minimal") #No name repair or checks, beyond basic existence of names
read_csv("test.csv",name_repair = "check_unique") #No name repair, but check they are unique
read_csv("test.csv",name_repair = "unique_quiet") #Repair with the unique strategy, quietly
read_csv("test.csv",name_repair = "universal") #Make the names unique and syntactic
read_csv("test.csv",name_repair = "universal_quiet") #Repair with the universal strategy, quietly.

#Use "unique" if you just want to fix duplicate names quickly.
#Use "universal" if you are importing messy data with spaces, symbols, or numeric starts.
#Use "minimal" only if you are 100% sure you will rename the columns yourself in the very next line of code

#If you use unique_quiet or universal_quiet, R performs the exact same repair as above but hides the message in the console. 
#This is great for clean logs once you know your code works.

#17. num_threads
#---------------
#Parallel reading threads.
read_csv(
  "flights.csv",
  num_threads = 4
)

#18. show_col_types
#------------------
read_csv(
  "flights.csv",
  show_col_types = FALSE
)

#19. skip_empty_rows
#-------------------
#Ignore empty rows.
read_csv(
  "flights.csv",
  skip_empty_rows = FALSE
)

#20. lazy
#--------
#Lazy reading for performance.
should_read_lazy()
read_csv(
  "flights.csv",
  lazy = TRUE
)

#Real Data Analysis Examples
#---------------------------
#Read Selected Columns Only
flight_subset <- read_csv(
  "flights.csv",
  col_select = c(
    carrier,
    origin,
    dest,
    arr_delay
  )
)

#Read First 1000 Rows
sample_data <- read_csv(
  "flights.csv",
  n_max = 1000
)

#Manual Type Definitions
flight_data <- read_csv(
  "flights.csv",
  col_types = cols(
    year = col_integer(),
    month = col_integer(),
    carrier = col_character(),
    dep_delay = col_double()
  )
)

#Read Large File Efficiently
large_data <- read_csv(
  "flights.csv",
  col_select = c(
    year,
    carrier,
    dep_delay
  ),
  num_threads = 8,
  progress = TRUE
)

#Read CSV with Comments
flight_data <- read_csv(
  "flights.csv",
  comment = "#"
)

#Read With Custom Missing Values
flight_data <- read_csv(
  "flights.csv",
  na = c(
    "",
    "NA",
    "Missing",
    "NULL"
  )
)

#diff between the read_csv() and read_csv2()
#Featur -->read_csv()-->read_csv2()
#Field Separator-->Comma (,)-->Semicolon (;)
#Decimal Point-->Period (.)-->Comma (,)
#Common Regions-->US, UK, Australia, India-->Germany, France, Brazil, Italy

#Best Practices
#----------------
#Type Guessing Can Fail
#Use  col_types for production systems.

#Better for Large Files
#Especially with: col_select,num_threads,lazy

#Use col_select for Large Data -Reduces memory usage dramatically.
#Explicitly Define Types -Avoid incorrect guessing.
#Use UTF-8 Encoding -  locale = locale(encoding = "UTF-8")

read_csv("flights.csv")
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

#Pros
##Human readable
##Universal support
##Easy debugging
##Works everywhere

#Cons
##Slow for large data
##Large file size
##No schema/types preserved
##No compression efficiency

#Used For
##Simple exchange
##Exports/imports
##Small to medium datasets

#Handling the Excel file
#=======================
library(readxl)
library(writexl)
library(dplyr)
library(nycflights13)

#Writing the Excel file
#----------------------
library(writexl)

#syntax:
write_xlsx(x, path = tempfile(fileext = ".xlsx"), col_names = TRUE,
           format_headers = TRUE, use_zip64 = FALSE)

#1. x parameter(main data)
##This is the data frame or list of data frames to export.
##Single Data Frame
setwd("C:\\Users\\ganes\\Downloads\\R_test")
write_xlsx(flights,"nycflights23.xlsx")

#Filtered Flights
delayed_flights <- flights %>%
  filter(arr_delay > 120)
write_xlsx(delayed_flights, "delayed_flights.xlsx")

#Multiple Sheets
flight_list <- list(
  Flights = flights,
  Airlines = airlines,
  Airports = airports,
  Planes=planes,
  Weather=weather
)
write_xlsx(flight_list, "nycflights23.xlsx")
#Excel workbook contains:
#Flights
#Airlines
#Airports
#as separate sheets.

#2. path Parameter
##Defines output Excel file location.
##Custom Path
write_xlsx(flights, path = "C:\\Users\\ganes\\Downloads\\R_test\\flights.xlsx")
##Temporary File
temp_file <- tempfile(fileext = ".xlsx")
write_xlsx(flights, temp_file)
temp_file
#Useful for testing.

##3. col_names parameter
#Controls whether column names are written.
#Include Column Names
write_xlsx(airports, "with_headers.xlsx",col_names = TRUE)
#Remove Column Names
write_xlsx(airports, "without_headers.xlsx",col_names = FALSE)
##Excel starts directly with values.

##4. format_headers parameter
#Formats headers in bold and centered.
#Works only when col_names = TRUE.
write_xlsx(airports, "formatted_headers.xlsx",format_headers = TRUE)
#Headers appear:
#Bold
#Centered

#Plain Headers
write_xlsx(airports, "plain_headers.xlsx",format_headers = FALSE)
#Headers appear as normal text.

##5. use_zip64 Parameter
#Large Dataset Export
big_flights <- bind_rows(
  airports,
  airports,
  airports,
  airports
)
write_xlsx(big_flights,"huge_flights.xlsx",use_zip64 = TRUE)
#Useful for enterprise-scale exports

##Real World Examples
#Example 1 — Export Top Delayed Flights
top_delays <- flights %>%
  arrange(desc(arr_delay)) %>%
  select(year, month, day,
         carrier, flight,
         origin, dest,
         arr_delay) %>%
  slice_head(n = 100)
write_xlsx(top_delays,"top_delays.xlsx")

#Example 2 — Export Monthly Reports
jan_flights <- flights %>% filter(month == 1)
feb_flights <- flights %>% filter(month == 2)
mar_flights <- flights %>% filter(month == 3)

monthly_reports <- list(
  January = jan_flights,
  February = feb_flights,
  March = mar_flights
)
write_xlsx(monthly_reports,"monthly_reports.xlsx")

#Example 3 — Export Summary Tables
carrier_summary <- flights %>%
  group_by(carrier) %>%
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    total_flights = n()
  )
dest_summary <- flights %>%
  group_by(dest) %>%
  summarise(
    avg_distance = mean(distance),
    total_flights = n()
  )
summary_report <- list(
  Carrier_Summary = carrier_summary,
  Destination_Summary = dest_summary
)
write_xlsx(summary_report,"summary_report.xlsx")

#Example 4 — Dynamic File Names
today_file <- paste0(
  "flights_report_",
  Sys.Date(),
  ".xlsx"
)
write_xlsx(flights, today_file)

#Example 5 — Export Selected Columns
flight_export <- flights %>%
  select(
    year, month, day,
    carrier, flight,
    origin, dest,
    dep_delay, arr_delay
  )
write_xlsx(flight_export,"selected_columns.xlsx")

#Example 6 — Export Cleaned Data
clean_flights <- flights %>%
  filter(!is.na(arr_delay),
         !is.na(dep_delay)) %>%
  distinct()
write_xlsx(clean_flights,"clean_flights.xlsx")

#Important Notes
#1. write_xlsx() Cannot
# Add formulas
# Add charts
# Add colors/styles
# Freeze panes
# Add filters
#For advanced formatting use:
# openxlsx
# xlsx

#Reading the Excel file
#----------------------
library(readxl)
library(writexl)
library(dplyr)
library(nycflights13)

setwd("C:\\Users\\ganes\\Downloads\\R_test\\testing")

#First Create Excel Files for Testing
flight_list <- list(
  Flights = flights,
  Airlines = airlines,
  Airports = airports,
  Planes=planes,
  Weather=weather
)
write_xlsx(flight_list, "flights_data.xlsx")

#Basic Syntax
read_excel(
  path,
  sheet = NULL,
  range = NULL,
  col_names = TRUE,
  col_types = NULL,
  na = "",
  trim_ws = TRUE,
  skip = 0,
  n_max = Inf,
  guess_max = min(1000, n_max),
  progress = readxl_progress(),
  .name_repair = "unique"
)

#1. path
#-------
#Excel file path.
#Read Flights Workbook
flight_data <- read_excel(
  "flights_data.xlsx"
)
#Reads first sheet by default.

#2. sheet
#--------
#Specifies worksheet.
#Can use:
#sheet name
#sheet index
#Read by Sheet Name
flight_data <- read_excel(
  "flights_data.xlsx",
  sheet = "Flights"
)

airport_data <- read_excel(
  "flights_data.xlsx",
  sheet = "Airports"
)
airport_data

#Read by Sheet Number
flight_data <- read_excel(
  "flights_data.xlsx",
  sheet = 1
)

#Read Airlines Sheet
airline_data <- read_excel(
  "flights_data.xlsx",
  sheet = "Airlines"
)

#3. range
#--------
#Read only specific cell range.
#Read Small Range
small_data <- read_excel(
  "flights_data.xlsx",
  range = "A1:F20"
)

#Specific Columns Only
subset_data <- read_excel(
  "flights_data.xlsx",
  range = "A:D"
)

##using the range aspect
read_excel("flights_data.xlsx",range = "A1:D100")
#using dplyr way
read_excel("flights_data.xlsx") %>%select(1:4)
#Use Cell Limits Properly
read_excel(
  "flights_data.xlsx",
  range = cell_cols("A:D")
)

#Only Rows 1–50 using cell_rows()
read_excel(
  "flights_data.xlsx",
  range = cell_rows(1:50)
)


#Columns A1:20 using cell_limits
read_excel(
  "flights_data.xlsx",
  range = cell_limits(
    c(1, 1),
    c(20, 4)
  )
)

#Specific Rows
rows_data <- read_excel(
  "flights_data.xlsx",
  range = "A10:G25"
)

#4. col_names
#------------
#Controls header handling.
#File Has Headers
read_excel(
  "flights_data.xlsx",
  col_names = TRUE
)

#No Headers
read_excel(
  "flights_data.xlsx",
  col_names = FALSE
)

#Custom Column Names
#since it understand total has 19 columns, Need to suffice with remaining one.
read_excel("flights_data.xlsx",col_names=c(
  "yr","mn","dy","dep_time",rep("Extra",15)
))

#This works because now only 4 columns are being read.
#Provide All 19 Names
read_excel(
  "flights_data.xlsx",
  col_names = c(
    "yr","mn","dy","dep_time"
  )
)
#Read normally, then rename.
read_excel("flights_data.xlsx") %>%
  rename(
    yr = year,
    mn = month,
    dy = day
  )

#3. col_types
#------------
#Manually define column types.
#Type	Meaning
#"skip"	Ignore column
#"guess"	Auto detect
#"logical"	TRUE/FALSE
#"numeric"	Numbers
#"date"	Dates
#"text"	Character
#"list"	List column

#Manual Types
read_excel(
  "flights_data.xlsx",
  col_types = c(
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "text"
  )
)

#Read Only Needed Columns (Recommended)
read_excel(
  "flights_data.xlsx",
  range = cell_cols("A:I"),
  col_types = c(
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "text"
  )
)

#Use "guess" for Remaining Columns
#Very practical approach.
read_excel(
  "flights_data.xlsx",
  col_types = c(
    "numeric",
    "numeric",
    "numeric",
    rep("guess", 16)
  )
)

#Define All 19 Column Types
read_excel(
  "flights_data.xlsx",
  col_types = c(
    "numeric",  # year
    "numeric",  # month
    "numeric",  # day
    "numeric",  # dep_time
    "numeric",  # sched_dep_time
    "numeric",  # dep_delay
    "numeric",  # arr_time
    "numeric",  # sched_arr_time
    "numeric",  # arr_delay
    "text",     # carrier
    "numeric",  # flight
    "text",     # tailnum
    "text",     # origin
    "text",     # dest
    "numeric",  # air_time
    "numeric",  # distance
    "numeric",  # hour
    "numeric",  # minute
    "date"      # time_hour
  )
)

#Skip Columns
read_excel(
  "flights_data.xlsx",
  col_types = c(
    "numeric",
    "skip",
    "skip",
    "text"
  )
)

#rep()
#Instead of writing all 19 manually:
read_excel(
  "flights_data.xlsx",
  col_types = c(
    rep("numeric", 8),
    "text",
    rep("guess", 10)
  )
)

#Skip Columns Using "skip"
read_excel(
  "flights_data.xlsx",
  col_types = c(
    "numeric",
    "numeric",
    "numeric",
    rep("skip", 16)
  )
)

#6. na
#-----
#Defines missing value strings.
#Custom Missing Values
#Reads only first 3 columns.
read_excel(
  "flights_data.xlsx",
  na = c(
    "",
    "NA",
    "Missing",
    "NULL"
  )
)

#7. trim_ws
#----------
#Trim whitespace.
read_excel(
  "flights_data.xlsx",
  trim_ws = FALSE
)

#8. skip
#-------
#Skip rows before reading.
#Useful for metadata/header notes
#Skip Top Rows
read_excel(
  "flights_data.xlsx",
  skip = 2
)

#9. n_max
#--------
#Maximum rows to read.
#Read First 100 Rows
read_excel(
  "flights_data.xlsx",
  n_max = 100
)

#10. guess_max
#-------------
#Rows used for type guessing.
#Better Type Detection
#guess_max tells read_excel() or read_csv(): How many rows should I inspect before deciding the column data type?

read_excel(
  "flights_data.xlsx",
  guess_max = 10000 #Look at first 10000 rows before deciding types
)

#11. progress
#------------
#Show progress spinner.
read_excel(
  "flights_data.xlsx",
  progress = FALSE
)

#12.name_repair
#---------------
#Repairs invalid/duplicate names.
#Options:
#"unique"
#"minimal"
#"check_unique"
#"universal"

read_excel(
  "flights_data.xlsx",
  .name_repair = "universal"
)



#test.CSV
#name,name,id,age
#ganesh,swe,1,34
#ganesh1,sara,3,43

#name_repair
#unique-Make sure names are unique and not empty.
#minimal-No name repair or checks, beyond basic existence of names
#check_unique-No name repair, but check they are unique
#unique_quiet-Repair with the unique strategy, quietly
#universal-#Make the names unique and syntactic
#universal_quiet -Repair with the universal strategy, quietly.
read_excel("test.csv",name_repair = "unique")#Make sure names are unique and not empty.
read_excel("test.csv",name_repair = "minimal") #No name repair or checks, beyond basic existence of names
read_excel("test.csv",name_repair = "check_unique") #No name repair, but check they are unique
read_excel("test.csv",name_repair = "unique_quiet") #Repair with the unique strategy, quietly
read_excel("test.csv",name_repair = "universal") #Make the names unique and syntactic
read_excel("test.csv",name_repair = "universal_quiet") #Repair with the universal strategy, quietly.

#Real Data Analysis Examples
#---------------------------
#Read Selected Flight Columns
read_excel(
  "flights_data.xlsx",
  range = cell_cols("A:D")
)

#Read First 500 Rows
read_excel(
  "flights_data.xlsx",
  n_max = 500
)

#Skip Metadata Rows
read_excel(
  "flights_data.xlsx",
  skip = 2
)

#Read Only Airlines Sheet
read_excel(
  "flights_data.xlsx",
  sheet = "Airlines"
)

#Manual Type Control
read_excel(
  "flights_data.xlsx",
  col_types = c(
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "text"
  ),
  guess_max = 5000
)

#Read Specific Range for Dashboard
read_excel(
  "flights_data.xlsx",
  range = "A1:E50"
)

#Important Concepts
#read_excel() Automatically Detects File Type
#read_excel() Returns Tibble
#Reading Multiple Sheets
excel_sheets("flights_data.xlsx")
#Loop Through All Sheets
sheets <- excel_sheets("flights_data.xlsx")

all_data <- lapply(
  sheets,
  function(x) read_excel(
    "flights_data.xlsx",
    sheet = x
  )
)

#Common Errors
#Sheet Does Not Exist
read_excel(
  "flights_data.xlsx",
  sheet = "WrongSheet"
)
#Check available sheets:
excel_sheets("flights_data.xlsx")
#File Not Found
getwd()
list.files()

read_excel(
  "flights_data.xlsx",
  guess_max = 3
)


#Handling the TSV file
#=====================
#TSV(Tab separated value)
#default to \t tab
write_tsv(flights, "flights.tsv")
read_tsv("flights.tsv")

## different compressions method gz,bz2,xz
write_tsv(flights, "flights.tsv.gz")
write_tsv(flights, "flights.tsv.bz2")
write_tsv(flights, "flights.tsv.xz")
##read the compressed files.
read_tsv("flights.tsv.gz")

#Handling Txt Files using base R
#================================
#Very common.

#Write TXT File (Space Separated)
#----------------
#Export as Plain Text
write.table(
  flights,
  file = "flights_space.txt",
  sep = "|",
  row.names = FALSE
)
#Read the TXT File
flights_space <- read.table(
  "flights_space.txt",
  sep = "|",
  header = TRUE  
)
head(flights_space)

#Write TXT File (Tab Separated)
#----------------
#Export as TXT with Tabs
write.table(
  flights,
  file = "flights_pipe.txt",
  sep = "\t",
  row.names = FALSE
)
#Read Tab TXT File
flights_tab<-read.table("flights_pipe.txt",sep = "|")
head(flights_tab)

#Write TXT File (Comma Separated TXT)
#----------------
#Even .txt can store CSV-style data.
write.table(
  flights,
  file = "flights_comma.txt",
  sep = ",",
  row.names = FALSE
)
#Read It
flights_comma <- read.csv("flights_comma.txt")
head(flights_comma)

#Append Data to Existing TXT File
#----------------
write.table(
  head(flights, 10),
  "append_example.txt",
  sep = "\t",
  row.names = FALSE
)

write.table(
  tail(flights, 10),
  "append_example.txt",
  sep = "\t",
  row.names = FALSE,
  append = TRUE,
  col.names = FALSE
)

#Handle Missing Values
#----------------
write.table(
  flights,
  "missing_example.txt",
  sep = "\t",
  na = "MISSING",
  row.names = FALSE
)
#Read
missing_data <- read.delim(
  "missing_example.txt",
  na.strings = "MISSING"
)
head(missing_data)

#Read TXT Without Header
#----------------
#Write Without Column Names
write.table(
  flights,
  "no_header.txt",
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
#Read Without Header
no_header_data <- read.delim(
  "no_header.txt",
  header = FALSE
)
head(no_header_data)

#Compress TXT File
#----------------
write.table(
  flights,
  gzfile("flights.txt.gz"),
  sep = "\t",
  row.names = FALSE
)
#Read Compressed TXT
compressed_data <- read.delim(
  gzfile("flights.txt.gz")
)
head(compressed_data)

#Real Data Analysis Example
#----------------
##Save Delayed Flights as TXT
delayed_flights <- flights %>%
  filter(arr_delay > 60)

write.table(
  delayed_flights,
  "delayed_flights.txt",
  sep = "\t",
  row.names = FALSE
)
#Read and Analyze
delay_data <- read.delim("delayed_flights.txt")
delay_data %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))

#Handling the delimiter file using readr
#===========================
#default to "" separate using *_delim()
write_delim(flights, "flights.txt")
read_delim("flights.txt")

#delim="|" parameter
write_delim(flights, "flights.txt",delim = "|") #pip limited
read_delim("flights.txt")

#delim=";" parameter
write_delim(flights, "flights1.txt",delim = ";") #semicolon limited
read_delim("flights1.txt")

#very fast -best for huge files
#Excellent for big datasets.
library(data.table)
fread("flights.tsv")

#Handling with Fixed Width Files (FWF)
#=====================================
#Very common in banking, telecom, government systems.
library(readr)
library(dplyr)
library(nycflights13)

#Create a Small Sample Dataset
#-----------------------------
#FWF works best with controlled widths.
fwf_data <- flights %>%
  select(year, month, day, carrier, flight, dep_delay) %>%
  slice(1:10)

fwf_data

#Understand Column Widths
#------------------------
#Suppose we define:
#Column	Width
#year	6
#month	4
#day	4
#carrier	8
#flight	8
#dep_delay	8

#Write Fixed Width File
#------------------------
#R does not have a direct write_fwf() in base R.
#We manually format rows using sprintf().
fwf_lines <- sprintf(
  "%-6s%-4s%-4s%-8s%-8s%-8s",
  fwf_data$year,
  fwf_data$month,
  fwf_data$day,
  fwf_data$carrier,
  fwf_data$flight,
  fwf_data$dep_delay
)
writeLines(fwf_lines, "flights_fwf.txt")

#View the FWF File
#------------------
readLines("flights_fwf.txt", n = 5)

#. Advantages of FWF
#--------------------
##Compact structure
##Faster for legacy systems
##No delimiter conflicts
##Predictable layout

#Disadvantages of FWF
#--------------------
##Harder to edit manually
##Requires exact widths
##Space wastage
##Complex maintenance

#Best Packages for FWF in R
#--------------------
#Package	Purpose
#readr	Modern FWF reading
#utils	Base R reading
#LaF	Large FWF files
#ff	Memory-efficient files

#Handling the RDS files
#======================

#Writing the RDS file using saveRDS()
#-----------------------------------
#Basic Syntax
saveRDS(
  object,
  file = "",
  ascii = FALSE,
  version = NULL,
  compress = TRUE,
  refhook = NULL
)

#To read the file back:
readRDS()

#1. object Parameter
#The R object to save.
#Can be:
#data frame
#tibble
#list
#vector
#model
#function
#matrix
#custom object

#Save Flights Dataset
saveRDS(flights, "flights.rds")
#Read Back
loaded_flights <- readRDS("flights.rds")

#2. file Parameter
#Output .rds file path.
#Custom Path
saveRDS(flights,file = "C:\\Users\\ganes\\Downloads\\R_test\\data\\flights_backup.rds")
#Temporary File
temp_file <- tempfile(fileext = ".rds")
saveRDS(flights, temp_file)
temp_file

#3. ascii Parameter
#Controls binary vs text storage.
#Meaning:
#Binary format
#Smaller
#Faster

#Binary Save (Recommended)
saveRDS(flights,"binary_flights.rds",ascii = FALSE)
#ASCII/Text Format
saveRDS(flights,"ascii_flights.rds",ascii = TRUE)
#Useful for:
##debugging
##portability
##inspecting content
#But files become larger and slower.

#4. version
#Controls serialization format version.
#Save Compatible with Older R
saveRDS(flights,"old_version.rds",version = 2)
#Useful when sharing with older R installations.

#5. compress Parameter
#Controls compression.
#Options:
#TRUE
#FALSE
#"gzip"
#"bzip2"
#"xz"
#Default:
#Usually means gzip compression.
#Default Compression
saveRDS(flights,"compressed.rds",compress = TRUE)
#No Compression
saveRDS(flights,"no_compress.rds",compress = FALSE)
#Faster writing but larger file.
#Gzip Compression
saveRDS(flights,"gzip_flights.rds",compress = "gzip")
#Bzip2 Compression
saveRDS(flights,"bzip2_flights.rds",compress = "bzip2")
#Better compression but slower.
#XZ Compression
saveRDS(flights,"xz_flights.rds",compress = "xz")

#Smallest file size, slowest.
#Compression Comparison
#Compression->Speed->File->Size
#FALSE->Fastest->Largest
#gzip->Fast->Small
#bzip2->Medium->Smaller
#xz->Slowest->Smallest

#6. refhook Parameter
#Advanced parameter for custom serialization.
#Rarely used.
#Mostly for:
#reference objects
#environments
#external pointers

#Real Data Analysis Examples
##Example 1 — Save Cleaned Flights
clean_flights <- flights %>%
  filter(
    !is.na(arr_delay),
    !is.na(dep_delay)
  ) %>%
  distinct()
saveRDS(clean_flights,"clean_flights.rds")

#Example 2 — Save Aggregated Report
carrier_summary <- flights %>%
  group_by(carrier) %>%
  summarise(
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    total_flights = n()
  )
saveRDS(carrier_summary,"carrier_summary.rds")

#Example 3 — Save Machine Learning Dataset
ml_data <- flights %>%
  select(
    dep_delay,
    arr_delay,
    air_time,
    distance
  ) %>%
  drop_na()
saveRDS(ml_data,"ml_training_data.rds")

#Example 4 — Save Multiple Objects in List
analysis_objects <- list(
  flights_data = flights,
  airlines_data = airlines,
  airports_data = airports
)
saveRDS(
  analysis_objects,
  "analysis_bundle.rds"
)

#Example 5 — Save Daily Backup
backup_name <- paste0("flights_backup_",Sys.Date(),".rds")
saveRDS(flights,backup_name)

#Example 6 — Save Model
model <- lm(arr_delay ~ dep_delay + distance,data = flights)
saveRDS(model,"delay_model.rds")

#Read Model Back
saved_model <- readRDS("delay_model.rds")
summary(saved_model)

#Common Workflow
processed_flights <- flights %>%
  filter(arr_delay > 0) %>%
  group_by(carrier) %>%
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE)
  )
saveRDS(
  processed_flights,
  "processed_flights.rds"
)
# Later
processed_flights <- readRDS("processed_flights.rds")

#Best Practices
#Use .rds for
#processed datasets
#ML models
#reusable analysis
#intermediate pipeline outputs

#Reading the RDS file
#--------------------
read_rds("flights.rds")
#When you readRDS(), the file doesn’t "know" its own name. You must assign it to a variable.
#Benefit: This is much safer for programming and allows you to load the same data multiple times under different names.

#Handling the .RData files
#=========================
#Save Single objec
save(flights, file = "flights.RData")
#Readin the .RData files
load("flights.RData")
ls() #list all the available objects in the memory
#When you load() an .RData file, it restores the objects exactly as they were named when
#Risk: If you already have a variable named df_results in your environment, load() will overwrite it silently.

#Save two objects
save(df_results, model_final, file = "project.RData")
# Save two objects
save(df_results, model_final, file = "project.RData")
# Load them back
load("project.RData") 
# Both 'df_results' and 'model_final' appear in your environment automatically.


#Pros
##Saves exact R object
##Preserves attributes/classes
##Very easy
#Cons
##R-only
##Not interoperable
##Poor for distributed systems
#Used For
##R projects
##Model saving
##Cached objects

#Scope Multiple vs. Single Objects:
##.RData (Workspace): Designed to save multiple objects at once (your entire workspace or a selected list of variables).
##.rds (Single Object): Designed to save one specific R object (a data frame, a list, a model, etc.

#Comparison Table
#----------------
#Feature->.RData->.rds
#Primary Function->Saving workspaces/multiple objects->Saving a single R object
#Function to Save->	save() or save.image()->	saveRDS()
#Function to Load->	load()->	readRDS()
#Assignment	Automatic-> (uses original names)->	Manual (assigned by user)
#Transparency->	Harder to see what's inside without loading->	Explicit; you know exactly what is being assigned
#Usage in Packages->	Common for internal data->	Recommended for saving models/results

#Handling the fst files
#======================
install.packages("fst")
library(fst)
#Very Popular for High-Speed R Analytics

#writing the fst
write_fst(flights, "flights.fst")

#reading the fst
read_fst("flights.fst")

#Pros
##Extremely fast
##Good compression
##Parallel read/write
#Cons
##Mostly R ecosystem
##Less universal than Parquet
#Used For
##Fast local analytics
##R performance workflows

#Handling the JSON files
#=======================
install.packages("jsonlite")
library(jsonlite)
jsonlite::write_json(flights,"flights.json")
read_json("flights.json")
#reads in the proper output.
fromJSON("flights.json")

#Handling the XML files
#======================
#https://www.youtube.com/watch?v=1JblVElt5K0

install.packages("xml2")
library(xml2)
library(nycflights13)
library(dplyr)
#Create Small Flights Dataset
#-----------------------------
flights_small <- flights |> 
  select(year, month, day, carrier, flight, origin, dest) |> 
  slice(1:5)

flights_small

#Write XML File
#--------------
#Create XML Structure
root <- xml_new_root("flights")
# Add Flight Records
for(i in 1:nrow(flights_small)) {
  flight_node <- xml_add_child(root, "flight")
  xml_add_child(flight_node, "year",
                flights_small$year[i])
  xml_add_child(flight_node, "month",
                flights_small$month[i])
  xml_add_child(flight_node, "day",
                flights_small$day[i])
  xml_add_child(flight_node, "carrier",
                flights_small$carrier[i])
  xml_add_child(flight_node, "flight_number",
                flights_small$flight[i])
  xml_add_child(flight_node, "origin",
                flights_small$origin[i])
  xml_add_child(flight_node, "destination",
                flights_small$dest[i])
}

#Save XML File
#--------------
write_xml(root, "flights.xml")

#XML File Content
#-----------------
#Generated XML looks like:
#<flights>
#  <flight>
#    <year>2013</year>
#    <month>1</month>
#    <day>1</day>
#    <carrier>UA</carrier>
#    <flight_number>1545</flight_number>
#    <origin>EWR</origin>
#    <destination>IAH</destination>
#  </flight>
#</flights>

#Read XML File
#-------------
xml_data <- read_xml("flights.xml")

#convert to the dataframe
as_tibble(xml_list) |> unnest_wider(flights) |> unnest_longer(everything())

#View XML Structure
#------------------
xml_data
xml_structure(xml_data) #metadata

#Extract All Flight Nodes
#------------------------
flights_nodes <- xml_find_all(xml_data, "//flight")
flights_nodes

#Read XML into Data Frame
#------------------------
flights_parsed <- data.frame(

  year = xml_text(
    xml_find_all(flights_nodes, "./year")
  ),

  month = xml_text(
    xml_find_all(flights_nodes, "./month")
  ),

  day = xml_text(
    xml_find_all(flights_nodes, "./day")
  ),

  carrier = xml_text(
    xml_find_all(flights_nodes, "./carrier")
  ),

  flight_number = xml_text(
    xml_find_all(flights_nodes, "./flight_number")
  ),

  origin = xml_text(
    xml_find_all(flights_nodes, "./origin")
  ),

  destination = xml_text(
    xml_find_all(flights_nodes, "./destination")
  )

)

flights_parsed

#Convert Data Types
#------------------------
flights_parsed <- flights_parsed %>%
  mutate(
    year = as.integer(year),
    month = as.integer(month),
    day = as.integer(day),
    flight_number = as.integer(flight_number)
  )

str(flights_parsed)

#XML Attributes Example
#------------------------
#<flight carrier="UA" origin="EWR"/> 
#Create attributes:
flight_node <- xml_add_child(root, "flight")
xml_set_attr(flight_node, "carrier", "UA")
xml_set_attr(flight_node, "origin", "EWR")
#Read attributes:
xml_attr(flight_node, "carrier")

#XPath Examples
#--------------
#Find all carriers
xml_find_all(xml_data, "//carrier")
#Get text
xml_text(
  xml_find_all(xml_data, "//carrier")
)
#XML vs JSON
#Feature-->	XML-->	JSON
#Structure-->Tag-based-->	Key-value
#Verbosity-->	Large-->	Compact
#Readability-->	Medium-->	High
#APIs Today-->	Less common-->	Most common
#Supports Attributes-->	Yes-->	No

#Modern Recommendation
#For modern systems:
#JSON is more common
#XML still important for enterprise integrations

#Handling YAML Files in R
#========================
#AML stands for:
#YAML Ain't Markup Language
#It is a human-readable data serialization format commonly used for:
##Configuration files
##Machine learning pipelines
##APIs
##DevOps
##Metadata storage
##Unlike CSV or JSON, YAML focuses on readability.

#1. Install and Load Packages
#----------------------------
install.packages("yaml")
install.packages("nycflights13")
install.packages("dplyr")

library(yaml)
library(nycflights13)
library(dplyr)

#2. Create a Small Flights Dataset
#---------------------------------
#YAML is usually used for small-to-medium structured data.
flight_yaml <- flights %>%
  select(
    year,
    month,
    day,
    carrier,
    flight,
    origin,
    dest,
    dep_delay
  ) %>%
  slice(1:5)

flight_yaml

#3. Convert Data Frame to List
#----------------------------
flight_list <- split(
  flight_yaml,
  seq(nrow(flight_yaml))
)
flight_list

#4. Write YAML File
#------------------
#Use write_yaml().
write_yaml(
  flight_list,
  "flights.yaml"
)

#5. View YAML File
#-----------------
cat(readLines("flights.yaml"), sep = "\n")

#6. Read YAML File
#-----------------
#Use read_yaml().
yaml_data <- read_yaml("flights.yaml")
yaml_data

#7. Convert YAML Back to Data Frame
#-------------------------------
yaml_df <- bind_rows(yaml_data)
yaml_df

#8. Structure of YAML Data
#-------------------------
str(yaml_df)

#9. Writing Nested YAML Structures
#----------------------------------
#YAML supports nested structures very well.
nested_yaml <- list(
  metadata = list(
    dataset = "nycflights13",
    created_by = "R",
    total_rows = nrow(flight_yaml)
  ),  
  flights = split(
    flight_yaml,
    seq(nrow(flight_yaml))
  )
)
write_yaml(
  nested_yaml,
  "nested_flights.yaml"
)

#10. Read Nested YAML
#--------------------
nested_read <- read_yaml(
  "nested_flights.yaml"
)
nested_read

#Access metadata:
nested_read$metadata
#Access flights:
bind_rows(nested_read$flights)

#11. YAML with Custom Configuration
#----------------------------------
config_yaml <- list(  
  filters = list(
    carriers = c("UA", "AA", "DL"),
    min_delay = 30
  ),  
  output = list(
    file_type = "csv",
    save_path = "results/"
  )
)
write_yaml(
  config_yaml,
  "config.yaml"
)

#Read config:
config <- read_yaml("config.yaml")
config
#Use dynamically:
filtered_flights <- flights %>%
  filter(
    carrier %in% config$filters$carriers,
    dep_delay >= config$filters$min_delay
  )
filtered_flights

#12. Multiple Documents in YAML
#------------------------------
#YAML supports multiple documents separated by ---.
#Create manually:
yaml_text <- "
---
dataset: flights
rows: 100

---
dataset: airlines
rows: 16
"

writeLines(yaml_text, "multi.yaml")
#Read
readLines("multi.yaml")

#13. Handling Missing Values
#---------------------------
flight_yaml2 <- flight_yaml

flight_yaml2$dep_delay[2] <- NA

write_yaml(
  split(flight_yaml2, seq(nrow(flight_yaml2))),
  "missing.yaml"
)

#Read
missing_data <- read_yaml("missing.yaml")
bind_rows(missing_data)

#14. Convert Entire Dataset to YAML
#----------------------------------
#Warning:
#YAML becomes very large for big datasets.
small_flights <- flights %>%
  slice(1:100)

write_yaml(
  split(small_flights, seq(nrow(small_flights))),
  "large_flights.yaml"
)

#15. YAML vs JSON vs CSV
#------------------------
#Feature->YAML->JSON->CSV
#Human-readable->	Excellent->Medium->	Medium
#Nested data->	Excellent->	Excellent->Poor
#File size->	Large->	Medium->Small
#Configuration files->Excellent->Good->Poor
#Tabula data->	Medium->	Medium->	Excellent

#18. Base Concepts Behind YAML
#-----------------------------
#YAML uses:
#Symbol	Meaning
#:	Key-value pair
#-	List item
#Indentation	Hierarchy
#---	New documen

#Handling parquet Files(Big Data)
#================================
install.packages(c("arrow", "dplyr", "nycflights13"))
library(arrow)
library(dplyr)
library(nycflights13)

#Writing parquet file
#--------------------
write_parquet(flights, "clean_flights.parquet")
#reading the parquet file
read_parquet("high_compress.parquet") |> select(year,month)

#11. coerce_timestamps
#Convert timestamp precision.
#Options:
#"ms"
#"us"
#Millisecond Timestamps 
write_parquet(flights,"ms_timestamp.parquet",coerce_timestamps = "ms")

#12. allow_truncated_timestamps parameter
#Allows timestamp precision loss.
write_parquet(flights,"truncate_ts.parquet",coerce_timestamps = "ms",allow_truncated_timestamps = TRUE)

#6. compression_level
#Controls compression strength.
#Mostly useful for:
#gzip
#zstd
#brotli

#5.compression
#Compression algorithm.
#Options:
#"snappy" (default)
#"gzip"
#"brotli"
#"zstd"
#"lz4"
#"uncompressed"
write_parquet(flights,"snappy.parquet",compression = "snappy")
write_parquet(flights,"gzip.parquet",compression = "gzip")
write_parquet(flights,"zstd.parquet",compression = "zstd")
write_parquet(flights,"uncompressed.parquet",compression = "uncompressed")
#Compression Comparison
#Compression->Speed->File->Size
#snappy->Fast->Medium
#gzip->Medium->Small
#zstd->Fast->Very Small
#brotli->	Slow->	Smallest
#uncompressed->	Fastest->	Largest

#6.compression_level Parameter
#Controls compression strength.
#Mostly useful for:
#gzip
#zstd
#brotli
#Higher Compression
write_parquet(flights,"high_compress.parquet",compression = "gzip",compression_level = 9)
#Higher level:
#smaller file
#slower write

#Reading parquet file
#--------------------
read_parquet("clean_flights.parquet") |> select(month,year,day)

#Pros
##Columnar storage
##Faster than CSV
##Compressed
##Used in data engineering pipelines
##Very fast analytics
##Excellent compression
##Reads only needed columns
##Works with Spark, Hive, DuckDB, Python, cloud lakes
#Cons
##Not human readable
##Slightly complex ecosystem
#Used For
##Data lakes
##Analytics pipelines
##Cloud storage
##Big data workflows

#Handling Feather Files(Big Data)
#================================
install.packages(c("arrow", "dplyr", "nycflights13"))
library(arrow)
library(dplyr)
library(nycflights13)
#Writing the feather files
#--------------------------
write_feather(flights,"flights.feather")

#Read the Feather Files
#----------------------
read_feather("flights.feather") |> select(month,year,day)

#Pros
##Extremely fast local read/write
##Great for R ↔ Python exchange
##Preserves types
##Zero-copy Arrow memory model
#Cons
##Not optimized for long-term storage like Parquet
##Less compression
#Used For
##Intermediate pipelines
##ML workflows
##Fast local storage
##Cross-language data exchange

#Handling Arrow Files(Big Data)
#==============================
#The Arrow Dataset format is useful when you want to:
##Work with large datasets
##Read only selected columns
##Filter without loading everything into memory
##Store partitioned data
##Use Parquet/Feather efficiently through Arrow
#In R, Arrow datasets are commonly created using the Apache Arrow package.

#1. Install and Load Packages
install.packages(c("arrow", "dplyr", "nycflights13"))
library(arrow)
library(dplyr)
library(nycflights13)

#2. Create a Dataset Directory
#Arrow Dataset is usually stored as:
##multiple parquet files
##partitioned folders

#3. Write Dataset Using write_dataset()
write_dataset(flights,path = "flights_dataset",format = "parquet")

#4. Partitioned Dataset Example
#Very important in real big data systems.
write_dataset(
  flights,
  path = "flights_partitioned",
  format = "parquet",
  partitioning = c("year", "month")
)

#5. Read Dataset Using open_dataset()
#Dataset is lazy-loaded.
#Nothing is fully read into memory yet
ds <- open_dataset("flights_partitioned")
ds1 <- open_dataset("flights_dataset")
#Dataset is lazy-loaded.
#Nothing is fully read into memory yet.

#6. View Dataset
ds
ds1

#7. Select Columns
#Only selected columns are read.
ds %>%
  select(year, month, day, carrier) %>%
  collect()
  
#8. Filter Rows
#Arrow pushes filtering to storage level.
#Very fast.
ds %>%
  filter(month == 1) %>%
  collect()
  
#9. Combined Query
ds %>%
  filter(month == 1, arr_delay > 60) %>%
  select(year, month, day, carrier, arr_delay) %>%
  collect()
  
#10. Aggregation Example
ds %>%
  group_by(carrier) %>%
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  collect()
  
#11. Read Only Metadata First
#Shows column types without loading data.
schema(ds)

#12. Read Specific Partition Automaticallyjan_data <- ds %>%
jan_data <- ds %>%
  filter(month == 1) %>%
  collect()
#Arrow only scans:
month=1/ #partition folder.

#13. Write Compressed Dataset
##Parquet already uses compression internally.
write_dataset(
  flights,
  path = "compressed_dataset",
  format = "parquet",
  existing_data_behavior = "overwrite"
)

#Difference Between Arrow Dataset and Parquet
#--------------------------------------------
#Arrow Dataset->Parquet
#Collection of files->Single file format
#Query engine support->Storage format
#Can contain many parquet files->Just one parquet file
#Supports partition discovery->Does not manage partitions
#Lazy querying->File storage only

#Think of it like:
##Arrow Dataset = Database/Table
##Parquet = Data File

#Function	Purpose
#write_dataset()	Write dataset
#open_dataset()	Read dataset
#collect()	Bring data into memory
#select()	Read columns
#filter()	Filter rows
#group_by()	Grouping
#summarise()	Aggregation
#schema()	View metadata


#Arrow Dataset operations are:
#lazy
#memory efficient
#parallel
#optimized
Collect()
#Data is only loaded when:

#Arrow datasets are heavily used in:
##Spark pipelines
##Data lakes
##DuckDB
##Cloud analytics
##AWS Athena
##BigQuery external tables
##Machine learning pipelines
#using:
##Parquet
##Feather
##IPC
##partitioned storage systems.

#Handling with mySQL Database
#============================
#Connecting R to MySql
#----------------------
install.packages("RMySQL")
library(RMySQL)
# Create a connection Object to MySQL database.
# We will connect to the sampel database named "sakila" that comes with MySql installation.
mysqlconnection = dbConnect(MySQL(), user = 'root', password = 'ganesh123', dbname = 'sakila',host = 'localhost',client.flag = 128)
# List the tables available in this database.
dbListTables(mysqlconnection)

#Query with existing tables
#--------------------------
#We can query the database tables in MySql using the function dbSendQuery()
#The query gets executed in MySql and the result set is returned using the R fetch() function.
#Finally it is stored as a data frame in R.
#Query the "actor" tables to get all the rows.
result = dbSendQuery(mysqlconnection, "select * from actor")
# Store the result in a R data frame object. n = 5 is used to fetch first 5 rows.
df=fetch(result, n = 5)
print(df)

#Lets us do CRUD Operations.

#CREATE
#--------
#Creating Tables in MySql
#Enable on the Server (MySQL)
#SET GLOBAL local_infile = 1;

# Use the R data frame "flights" to create the table in MySql.
flights1 <- flights |> slice_head(n=100)
dbWriteTable(mysqlconnection, "flight", flights1, overwrite = TRUE, row.names = FALSE)

#READ
#----
# 1. Send the query
result <- dbSendQuery(mysqlconnection, "select * from flight where carrier='UA'")
# 2. Fetch ALL records and store them in df
# n = -1 explicitly tells R to get every single row
df <- dbFetch(result, n = -1)
# 3. Clear the result immediately after fetching
dbClearResult(result)
# 4. Now use your data frame
print(df)

#UPDATE
#------
#Updating Rows in the Tables
#We can update the rows in a Mysql table by passing the update query to the dbSendQuery() function.
dbSendQuery(mysqlconnection, "UPDATE flight SET dep_delay = 200 WHERE carrier = 'UA' AND flight = 628")

#Inserting Data into the Tables 
dbSendQuery(mysqlconnection, 
    "INSERT INTO flight (year, month, day, carrier, flight, tailnum, origin, dest) 
     VALUES (2026, 5, 6, 'AA', 1234, 'N123XX', 'JFK', 'LAX')"
) 

#DROP
#----
#Dropping Tables in MySql
#We can drop the tables in MySql database passing the drop table statement into the dbSendQuery() in the same way we used it for querying data from tables.
dbSendQuery(mysqlconnection, 'drop table if exists flight')

#Validating Data after import 
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

                                                        
