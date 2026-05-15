#intro
#Tidyverse packages
#Sample Datasets
#data frame and tibble
#Need of tidyverse
#Summary
#Frequently used verbs
#Workflow & Readability
#Frequently Used functions
#Quiz
#Assignment
#Resources

#intro
#=====

#Domain ->container-->Entry-->Element
#RelationDB->table->Record/tuple->field/attribute
#NoSQL->Collection->Document->key/field/attribute
#JSON/JS->Array->Object->Property
#Excel->Sheet->Row-->Column/cell
#Matrix->Matrix->Vector->Scalar
#ClinicalData->Domain->observation->Variables
#R->Dataframe-->Rows-->Variables
#SAS->Datasets-->Observations->Variables.

#Tidyverse packages
#=================
install.packages("tidyverse")
library(tidyverse) #to load the core tidyverse and make it available in your current R session.
pak::pkg_system_requirements("tidyverse") #If you’re compiling from source, you can run
pak::pkg_sysreqs()
#https://tidyverse.tidyverse.org/

#The tidyverse is a set of packages that work in harmony because they share common data representations and API design. 
#The tidyverse package is designed to make it easy to install and load core packages from the tidyverse in a single command
#Best books https://r4ds.hadley.nz/
#Usage
library(tidyverse) #will load the core tidyverse packages:
tidyverse_packages() #to know what are the packages

#Sample Datasets
#---------------
#I shall introduce the datasets which is very famous and covers all the sceanarios for data analysis
install.packages("nycflights13")  #check in the package session for more info.
library(nycflights13)

##view the data in data grid
View(airlines)
View(airports)
View(flights)
view(planes)
view(weather)
##get object class and type
class(flights) 
typeof(flights)
##get the data frame structure
##A diagnostic function in Base R used to display the internal structure of any R object (lists, functions, models, arrays, or data frames).
str(flights)
##compared to str we can use glimpse()
##A data-focused function from the pillar package (used by dplyr and tidyverse) specifically optimized for providing a dense,..
##horizontal preview of data frames
glimpse(flights)
##get data frame dimensions
dim(flights)
nrow(flights)
ncol(flights)

#data frame and tibble
#=====================

#Data Frame (data.frame)
#-----------------------
#The standard, built-in structure in Base R for storing tabular data. It has been the backbone of R since its inception.
#Structure: A list of vectors of equal length.
#Philosophy: "Do what I say, even if it causes a mess later." It is very flexible but can be "lazy" about checking for errors.
#key functonality
##Printing -Dumps the entire dataset into your console (can crash R if the file is huge).
##Data Types- Older versions used to convert strings to "Factors" automatically.
##Subsetting- If you select 1 column (df[,1]), it turns into a vector.
##Column Names - Will "fix" names (e.g., turning "My Column" into "My.Column").
##Error Checking- If you call a column that doesn't exist, it returns NULL silently.

#Tibble (tbl_df)
##A modern reimagining of the data frame, introduced by the tidyverse (specifically the tibble package).
##Structure: It is technically a data frame, but with extra "metadata" and stricter rules.
##Philosophy: "Fail early and fail clearly." It is designed to stop you from making common data analysis mistakes.

#Practical Example
##If you look at the flights data, it is already a tibble. 
##Notice how it tells you the dimensions and the data types (<int>, <chr>) right at the top:
library(nycflights13)
flights # This is a tibble
##If you convert it to a standard data frame and try to look at it, you'll see the difference immediately:
flights_old <- as.data.frame(flights)
head(flights_old) # You HAVE to use head(), or it will print 336,776 rows!

#data.frame()- Creating a Data Frame
##You use the base R function data.frame().
# Creating a standard data frame
my_df <- data.frame(
  name = c("Alice", "Bob", "Charlie"),
  age = c(25, 30, 35),
  has_pets = c(TRUE, FALSE, TRUE)
)

print(my_df)

#tibble()- Creating a Tibble
##You use the tibble() function from the tibble (or tidyverse) package.
library(tibble)
my_tbl <- tibble(
  name = c("Alice", "Bob", "Charlie"),
  age = c(25, 30, 35),
  has_pets = c(TRUE, FALSE, TRUE)
)

print(my_tbl)

#tribble()- The "Cool" Way to Create Tibbles: 
##Use when you are manually typing in a small table and want it to look organized in your code.
my_tribble <- tribble(
  ~name,     ~age,  ~has_pets,
  "Alice",   25,    TRUE,
  "Bob",     30,    FALSE,
  "Charlie", 35,    TRUE
)
my_tribble

#Which is more effective?
##use Tibbles for Analysis, Data Frames for Base R Compatibility.
##This is much easier for humans to read when typing manual data.

#Need of tidyverse
#=================
#Why we need to tidyverse, see the below base R code
#Ex: i want filter the month ==1 data in flights dataset along year, month,day col
flight_month<- flights[,c("year","month","day")]
glimpse(flight_month)
flight_first_month=flight_month[which(flight_month$month==1),]
flight_first_month

##Transfer the above to dplyr and using going forward %% pipe operator
flight_month<-select(flights,year, month, day)
filter(flight_month,month == 1)
#using the pip method VERY VERY USEFUL
flight_m <- flights %>%
            select(year, month, day) %>%
            glimpse() %>%  # Peeks at the 3 columns #but in str() it will crash
            filter(month == 1) # Continues to filter the data
#there is nave pipe operators came for official version from R |> Works in Base R (version 4.1+). its faster then standard pipe

#For very large data:
##Consider data.table
##Consider duckdb
##Consider sparklyr

#Summary
#=======
#ggplot2,for data visualisation. https://ggplot2.tidyverse.org/
#dplyr, for data manipulation.   https://dplyr.tidyverse.org/
##dbplyr...dplyr backend         https://dbplyr.tidyverse.org/
##dtplyr ... provides data.table backend for dplyr  https://dtplyr.tidyverse.org/
##duckplyr ... larger in memory datasets    https://duckplyr.tidyverse.org/
#tidyr, for data tidying.        https://readr.tidyverse.org/
#readr, for data import.         https://readr.tidyverse.org/
#purrr, for functional programming. https://purrr.tidyverse.org/
#tibble, for tibbles, a modern re-imagining of data frames. https://tibble.tidyverse.org/
#stringr, for strings.           https://github.com/tidyverse/stringr
#forcats, for factors.           https://github.com/tidyverse/forcats
#lubridate, for date/times.      https://github.com/tidyverse/lubridate

#other subj packages
#--------------------
#Working with specific types of vectors:
##hms, for times.           https://hms.tidyverse.org/
##bob S3 framework          https://blob.tidyverse.org/
##magrittr                  https://magrittr.tidyverse.org/
##glue.. fasten strign literals https://glue.tidyverse.org/
#Tidymodels for modeling and ML learning https://www.tidymodels.org/

#Importing other types of data:
#------------------------------
##feather, for sharing with Python and other languages. https://github.com/wesm/feather
##haven, for SPSS, SAS and Stata files.                 https://github.com/tidyverse/haven
##httr, for web apis.                                   https://github.com/r-lib/httr
##jsonlite for JSON.                                    https://github.com/jeroen/jsonlite
##readxl, for .xls and .xlsx files.                     https://readxl.tidyverse.org/index.html
##googlesheet4                                          https://googlesheets4.tidyverse.org/  
##googledrive                                           https://googledrive.tidyverse.org/
##rvest, for web scraping.                              https://rvest.tidyverse.org/
##xml2, for XML.                                        https://xml2.r-lib.org/

#Tidyselect  https://tidyselect.r-lib.org/reference/index.html


#Frequently used verbs
#=====================

#Core Data Manipulation (dplyr)
#-----------------------------
#Verb -->One-line summary
#select()-->	Pick specific columns from a dataset
#filter()-->	Keep rows that satisfy conditions
#arrange()-->	Sort rows by one or more columns
#mutate()-->	Create or transform columns
#summarise() / summarize()-->	Reduce data to summary statistics
#group_by()-->	Define groups for grouped calculations
#rename()-->	Rename columns
#distinct()-->	Remove duplicate rows
#count()-->Quickly count rows by group
#slice()-->	Select rows by position
#pull()-->	Extract a single column as a vector

#Combining & Joining Data
#------------------------
#Verb-->One-line summary
#left_join()-->Keep all rows from left table and match from right
#right_join()-->	Keep all rows from right table and match from left
#inner_join()-->	Keep only matching rows from both tables
#full_join()-->	Keep all rows from both tables
#bind_rows()-->	Stack datasets row-wise
#bind_cols()-->	Combine datasets column-wise

#Reshaping Data (tidyr)
#--------------------
#Verb-->	One-line summary
#pivot_longer()-->	Convert wide data to long format
#pivot_wider()-->	Convert long data to wide format
#separate()-->	Split one column into multiple columns
#unite()-->	Combine multiple columns into one
#drop_na()-->	Remove rows with missing values
#replace_na()	Replace missing values

#Data Cleaning & Helpers
#-----------------------
#Verb-->One-line summary
#across()-->	Apply functions to multiple columns
#if_else()-->	Vectorised conditional logic
#case_when()-->Multiple condition transformations
#coalesce()-->Pick first non-missing value
#rowwise()-->Perform row-by-row operations

#Workflow & Readability
#======================
#Verb	One-line summary
#%>%	Pipe output of one step into the next
#glimpse()	Compact view of data structure
#as_tibble()	Convert data into tibble format

#Most Common Daily Analysis Pattern
data %>%
  filter() %>%
  select() %>%
  mutate() %>%
  group_by() %>%
  summarise()
#80–90% of real-world analysis uses just these five verbs

#In real-world data analysis, date, string, and number functions are used constantly—often inside mutate(), filter(), and summarise()
#Date & Time Functions (mostly lubridate)
#Used for deriving periods, filtering timelines, aging, trends, cohorts.

#Frequently Used functions
#=========================

#Function	One-line summary
#---------------------------
#ymd() / mdy() / dmy()	Parse character strings into Date objects
#as.Date()	Convert to Date class
#year()	Extract year from date
#month()	Extract month (numeric or labeled)
#day()	Extract day
#wday()	Extract weekday
#qtr()	Extract quarter
#floor_date()	Round date down to unit (month, year, etc.)
#ceiling_date()	Round date up to unit
#interval()	Create time interval
#%within%	Check if date falls in a range
#difftime()	Calculate difference between dates
#today() / now()	Current date or datetime

#Very common use case:
mutate(year = year(visit_date), month = month(visit_date))

#String Functions (mostly stringr)
#---------------------------
#Used for cleaning text, extracting codes, pattern matching, categorisation.

#Function	One-line summary
#str_detect()	Check if pattern exists
#str_replace()	Replace first match
#str_replace_all()	Replace all matches
#str_extract()	Extract matching pattern
#str_sub()	Extract substring by position
#str_length()	Count characters
#str_to_upper()	Convert to uppercase
#str_to_lower()	Convert to lowercase
#str_trim()	Remove leading/trailing spaces
#str_split()	Split string into parts
#paste()	Join strings with separator
#paste0()	Join strings without separator
#sprintf()	Format strings with placeholders

#Very common use case:
#filter(str_detect(subject_id, "^SUBJ"))

#Number / Numeric Functions (base R + dplyr)
#---------------------------
#Used for summaries, transformations, thresholds, business rules.

#Function	One-line summary
#mean()	Average value
#median()	Middle value
#sum()	Total
#min() / max()	Smallest / largest value
#round()	Round numbers
#ceiling()	Round up
#floor()	Round down
#abs()	Absolute value
#log()	Natural logarithm
#sqrt()	Square root
#sd()	Standard deviation
#var()	Variance
#n()	Number of rows in group
#n_distinct()	Count unique values
#rank()	Rank values
#percent_rank()	Relative ranking (0–1)

#Very common use case:
summarise(avg_age = mean(age, na.rm = TRUE))

#Functions Used Across ALL Three (Daily Usage)
#--------------------------------------------
#Function	Purpose
#is.na()	Identify missing values
#if_else()	Conditional logic
#case_when()	Multi-condition classification
#coalesce()	First non-missing value
#na.rm = TRUE	Ignore missing values

#MOST USED COMBINATION IN REAL PROJECTS
data %>%
  mutate(
    year = year(date),
    month = month(date),
    category = case_when(
      str_detect(code, "A") ~ "Group A",
      value > 100 ~ "High",
      TRUE ~ "Other"
    )
  ) %>%
  group_by(year, category) %>%
  summarise(
    avg_value = mean(value, na.rm = TRUE),
    count = n()
  )


#Resources
#---------
