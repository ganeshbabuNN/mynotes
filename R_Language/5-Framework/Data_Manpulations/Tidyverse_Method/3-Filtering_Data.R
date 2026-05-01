#filtering with single condition
#filtering with multiple condition
#filtering rows using their positions
#Filtering Using Logical Reduction
#Filtering with "Row-wise" Logic
#Filtering with Multiple Complex Conditions
#Filtering using the ~ formulae operator
#Filtering using Comparison Operators
#Filtering Missing Values
#Filtering Using Range
#Filtering with Dynamic Column Names
#filtering the unique rows
#Filtering Using Aggregates
#Filtering Using Window Ranking Functions
#filtering using case_when()
#Filtering Using near()
#Filtering all the data in the current group
#Filtering with String Conditions
#Filtering Using Regex/Pattern
#Filtering with Grouped data
#Filtering After Joining
#Filtering Top N Values
#Filtering with Date-Time Logic
#Filtering Using Cumulative Logic
#Filtering by Frequency
#Filtering Based on Computed Conditions
#Filtering by First / Last Within Groups
#Filtering Using Lead/Lag for Change Detection
#Filtering Rows That Are Duplicates
#Filtering with "Predicate(where) Functions"
#Filtering Using relocate() + conditions (pipeline logic)
#Filtering Nested Data
#Filtering joins
#Filtering Rows Based on Another Table 
#Filtering using the "Invert" of a Join
#Filter Syntax Sematics
#Practical Business Scenarios

library(dplyr)
library(nycflights13)
#======
#Syntax
#======
#flitering or subsetting
filter(.data, condition1, condition2, ...)

#filtering with single condition
#===============================
#Example 1: Filter flights in January
flights %>%
  filter(month == 1)
#Returns only January flights.

#flights which has Long Delays (> 2 hours)
flights %>%
  filter(arr_delay > 120)

#character matching
#flights carrier matching with "AS" 
#Single value
flights %>% filter(carrier=="AS")

#filtering with mulitple condition
#=================================
#Example 2: Multiple Conditions (AND logic)
flights %>%
  filter(month == 1, day == 1) #numeirc matching

#using operator &
flights |> filter(month==1 & day==10) |> select(carrier,month,day)  
  

#Example 3: OR Condition
flights %>%
  filter(month == 6 | month == 7 | month == 8) #numeirc matching

#multiple value using %in%
flights %>% filter(carrier %in% c("UA", "AA"))

#Calculated Expressions (Inline Computation)
##Flights with speed > 500 mph
flights %>% mutate(speed= (distance / air_time) * 60) |> filter(speed > 500)

#filtering rows using their positions
#====================================
#slice(): Selects rows by their specific integer positions
flights |> slice(1,2) #Extract index by rows and col
#flights |> slice(:,4) 
flights |> slice(1:4) #ranging

#slice_head():Grabs the very first $n$ rows or percentage of rows from the dataset
flights |> slice_head(n=4)

#slice_tail(): Grabs the very last $n$ rows or percentage of rows from the dataset.
flights |> slice_tail(n=4)

#slice_min(): Picks rows with the lowest values in a specific column (e.g., the flights with the shortest air_time).
flights |> slice_min(distance, n = 1)
flights |> slice_min(distance, n = 5) |> select(carrier,flight,distance)  |> distinct(distance) #top 3 minium value

#slice_max():Picks rows with the highest values in a specific column
flights |> slice_max(distance, n = 7) |> select(carrier,flight,distance) |> distinct(distance)

#slice_sample():Randomly selects a specified number or fraction of rows from the dataset for quick inspection
##This is essential for Bootstrapping(a statistical technique used to estimate the precision of sample statistics)
flights |> slice_sample( n = 7) #n=Fixed Number prop=Relative Percentage
flights |> slice_sample( prop = 0.05)
flights |> slice_sample( n = 7,replace=TRUE) #FALSE = Dealing cards from a deck, TRUE:Rolling a die.
flights |> filter(!is.na(air_time)) |> slice_sample(n = 5, weight_by = air_time) |> select(carrier,flight,air_time)
#here weight_by: Pick 10 flights at random, but give the flights that were in the air the longest a much better chance of winning

#Filtering Using Logical Reduction
#=================================
#Logical Reduction" refers to the process of taking multiple logical conditions (one for each column) and reducing them into a single TRUE or FALSE value for each row.
#In R, all() and any() are the fundamental logical reduction functions. While if_all() and if_any() are designed to work inside filter() across columns, the base R functions all() and any() are typically used to reduce a single logical vector into a single TRUE or FALSE.
#base r Way , let me learnt in base R concept.
a<- c(50,60,70,80,90)
b<- c(91,81,91,78,65)
any(c(a,b) >40)
all(c(a,b) >40)

#any(x): Returns TRUE if at least one element in x is TRUE
flights %>%
  filter(any(c(arr_delay, dep_delay) > 60))
  
#all(x): Returns TRUE only if every element in x is TRUE
flights %>%
  filter(all(c(arr_delay, dep_delay) > 60))  
  
#Filtering with "Row-wise" Logic
#===============================
#Usually, filter() works on columns. But what if you need to calculate something across a single row before deciding to keep it?

##Filtering with if_any() and if_all()
#------------------------------------
#if_all() and if_any() are designed to work inside filter() across columns
#if_any() – Filter if ANY selected columns meet condition
#classical Way
flights %>%
  filter(dep_delay > 60 | arr_delay > 60)
  
#pro way.
flights %>%
  filter(if_any(c(dep_delay, arr_delay), ~ . > 60))
  
#Step 1: The Input (flights %>%)
##The process starts with the flights tibble. It contains 336,776 rows and 19 columns.
#Step 2: The Scope (if_any(c(dep_delay, arr_delay), ... ))
##The if_any() function tells R to look at a specific subset of columns.
##Instead of checking every column, it focuses only on dep_delay and arr_delay.
##The "all" part of if_any acts like a logical AND. It means the row only stays if the condition is true for every column listed in the vector.
#Step 3: The Condition (~ . > 60)
##This is a lambda (formula) function:
##The ~ starts the formula.
##The . (dot) is a placeholder for "the current column value."
##It checks if the value is strictly greater than 60

#if_all() – Filter if ALL columns meet condition(AND (All must be true))
#classical Way
flights %>%
  filter(dep_delay > 100 & arr_delay > 100)
  
#Pro Way
flights %>%
  filter(if_all(c(dep_delay, arr_delay), ~ . > 100)) |> select(carrier,dep_delay,arr_delay)

#if_else() -- similar like ifelse() -OR (At least one must be true)
#--------
flights %>%
  mutate(status = if_else(
    condition = arr_delay > 60, 
    true      = "Very Late", 
    false     = "Acceptable",
    missing   = "Cancelled/Unknown"  # Explicitly handle NAs
  )) %>% select(flight,carrier,year,month,day,dep_time,arr_time,status)
  
#Filtering Using rowwise()
#-------------------------
#When logic depends on row level computation.
#Example: Keep a flight if the mean of dep_delay and arr_delay for that specific row is greater than 30.
#classical way 
flights |> select(carrier,dep_delay,arr_delay) |>
  mutate(
    m_dep=mean(dep_delay,na.rm=TRUE), 
    m_arr=mean(arr_delay,na.rm=TRUE),
    m_dep_arr=mean(c(dep_delay,arr_delay),na.rm=TRUE), #this taking column level
    m_dep_arr1=(dep_delay+arr_delay)/2 #i am addition level and mean
  ) |> 
  filter(m_dep_arr1 >50)
  
#using rowise()
flights |> 
  rowwise() |> 
  filter(mean(c(dep_delay, arr_delay), na.rm = TRUE) > 30) |> 
  ungroup() # Don't forget to ungroup!
  
#note.ungroup() is your "exit strategy." When you use group_by() or rowwise(), you are changing the fundamental way R "sees" your data. If you forget to ungroup, every single operation you do afterwards will be performed inside those little buckets, which can lead to massive errors or incredibly slow code

##what happens when you miss ungroup. to cal the number flights in that month and in whole year 2 requirements.
flights |>
  group_by(month) |>
  mutate(n_month = n()) |> 
  # Missing ungroup() here! after ungroup() <--- Now R sees all 336,776 rows again
  mutate(percent_of_year = n_month / n()) |> 
  distinct(month, percent_of_year)
  
#Filtering with across()  
#-----------------------
#Dynamic filtering across multiple columns.
flights %>%
  filter(across(c(arr_delay, dep_delay), ~ . > 30))
  
#Filtering with Multiple Complex Conditions
#==========================================
#Flights delayed but not cancelled
flights %>%
  filter(arr_delay > 0 & !is.na(arr_delay))

#Example: Extreme delays in winter
flights %>%
  filter(month %in% c(12, 1, 2), arr_delay > 180) 

#across() find flights where the "Total Operational Time" exceeded a certain threshold.
flights %>% 
  filter(rowSums(across(c(air_time, dep_delay, arr_delay)), na.rm = TRUE) > 500)

#Exp on sum,normal addition and rowSum  
sales <-tibble(
  item=c("apple","banna","cherry"),
  jan=c(50,0,0),
  feb=c(60,80,0),
  mar=c(20,NA,0),
  apr=c(20,NA,0),
)
#in sum function if there is any col has NA
#rowsum() will ignore NA.

sales |> 
  mutate(tot = sum(jan,feb,mar),
         tot1= jan+feb+mar,
         tot2=rowSums(across(c(jan,feb,mar)),na.rm=T))

sales |> 
mutate(tot = sum(jan,feb,mar),
       tot1= jan+feb+mar,
       tot2=rowSums(across(feb:mar),na.rm=T)
      )

sales |> 
  mutate(tot = sum(jan,feb,mar),
         tot1= jan+feb+mar,
         tot2=rowSums(across(ends_with("delay")),na.rm=T)
  )

sales |> 
mutate(tot = sum(jan,feb,mar),
       tot1= jan+feb+mar,
       tot2=rowSums(across(feb:mar),na.rm=T)
      ) 

#Filtering using the ~ formulae operator
#=======================================
#find flights where either the departure delay OR the arrival delay was greater than 80 minutes,
flights |> filter(rowSums(across(c(dep_delay,arr_delay),~.x>80),na.rm = TRUE)>=1) |> 
  select(carrier,dep_delay,arr_delay)

#Find any flight that had a significant delay (over 90 minutes) in either its departure or its arrival. 
#Both of these columns start with "delay" if we rename them, or we can use contains()/ends_with()
flights |> 
  filter(if_any(ends_with("delay"), ~ .x >= 90)) |> select(carrier,ends_with("delay"))
  
#Filtering using Comparison Operators
#==================================
#Equal To (==)
#Find all flights that flew to Miami ("MIA").
flights %>% 
  filter(dest == "MIA")

#Not Equal To (!=)
#Find all flights that did not depart from Newark ("EWR").
flights %>% 
  filter(origin != "EWR")

#Greater Than (>) and Greater Than or Equal To (>=)
#Find flights that were delayed by more than 2 hours (120 minutes)
flights %>% 
  filter(dep_delay > 120)

#Less Than (<) and Less Than or Equal To (<=)
#Find flights that departed strictly before 6:00 AM.
flights %>% 
  filter(dep_time < 600)

#The "In Group" Operator (%in%)
#Find flights operated by United (UA), American (AA), or Delta (DL).
flights %>% 
  filter(carrier %in% c("UA", "AA", "DL"))

#Boolean Operators
# AND = Both conditions must be true.
##Only flights that occurred on New Year's Day.
flights |> filter(month == 1 & day == 1)

#The OR Operator (|)
##You get all flights from January plus all flights from November
flights |> filter(month == 1 | month == 11)

#NOT (!): Inverts the logic.
#Flights that were not delayed by more than 2 hours: 
flights |> filter(!(arr_delay > 120))

#Filtering Missing Values (Very Important in Real Data)
#======================================================

#Different technique
#-------------------
##different way to find missing values
##1.The "Quick Check" (Base R) -# Count NAs for every column
colSums(is.na(flights))
##To see only the columns that have at least one missing value:
## Filter out the zeros
missing_counts <- colSums(is.na(flights))
missing_counts[missing_counts > 0]

##2.The dplyr Way
##Using summarise() and across() gives you a clean tibble output, which is great for reports or further piping.
flights %>%
  summarise(across(everything(), ~ sum(is.na(.x)))) %>% glimpse()
##summarize() Collapses the data. You get one row per group.
##filter() Keeps the data detailed. You get every original flight belonging to that group.

##3.The data.table Way
#For large datasets, data.table is significantly faster. It uses .SD (Subset of Data) to apply the check to every column.
library(data.table)
flights_dt <- as.data.table(flights)
## Fast count of NAs per column
flights_dt[, lapply(.SD, function(x) sum(is.na(x)))]

#4.Visualizing Missingness (The "Pro" Choice)
## install.packages("naniar")
library(naniar)
## A quick bar chart of missing values per variable
gg_miss_var(flights)

#Handling NA values
#-------------------
#Find all flights that which are cancelled (dep_time=='NA')
flights %>% filter(dep_time == NA) #This does NOT work
#Correct Way
flights %>% filter(is.na(dep_time))

#Keep only the flights that actually have a departure delay recorded
flights %>%
  filter(!is.na(dep_delay))

#Filtering out canceled flights effectively:
flights %>% filter(is.na(dep_time) & is.na(arr_time)) |> select(carrier,dep_time,arr_time)
#remove the NA rows itself, running flights
flights %>% drop_na(dep_time, arr_time)|> select(carrier,dep_time,arr_time)

#Which flights have arrival delay greater than 60 minutes, treating missing delays as 0?
##coalesce()- coalesce() returns the first non-missing value.
flights %>%
  filter(coalesce(arr_delay, 0) > 60)
  
#coalesce() can also use multiple columns.
flights %>%
  mutate(delay = coalesce(dep_delay, arr_delay))  #If departure delay is missing, it uses arrival delay.

#Filtering Using Range
#=====================
#The "Explicit" Method (Logical Operators)
#using traditional way.
flights %>%
  filter(arr_delay >= 30 & arr_delay <= 60)

#Pro way -Using the between() helper-It is equivalent to x >= left & x <= right.
flights %>%
  filter(between(arr_delay, 30, 60))
  
#The "In-List" Range (%in%)
#Filters for flights in the second quarter (April, May, June)
#Warning: This only works for whole numbers. Do not use this for continuous decimals (like arr_delay), as it will only match exact integers
flights %>%
  filter(month %in% 4:6)

#using summarize() 
flights %>%
  summarize(
    min_delay = min(arr_delay, na.rm = TRUE),
    max_delay = max(arr_delay, na.rm = TRUE)
  )
  
#Getting range of Min/Max by Group level
flights %>%
  group_by(carrier) %>%
  summarize(
    min_arr = min(arr_delay, na.rm = TRUE),
    max_arr = max(arr_delay, na.rm = TRUE)
 )
 
#Filtering by Percentile Range
#quaitile marker : min:0 , 1st quartile:0.25,median=0.50,3rd quartile:0.74,max:1.
#Sometimes you don't know the exact numbers, but you want to filter for the "top 5%" or the "middle 50%". You can use quantile() inside your filter
flights %>%
  filter(between(arr_delay, quantile(arr_delay, 0.25, na.rm = TRUE), 
                 quantile(arr_delay, 0.75, na.rm = TRUE))) |> 
  select(carrier,arr_delay) |> distinct(arr_delay) |> arrange(arr_delay) |>  pull(arr_delay)
#This is great for identifying outliers or focusing on the "interquartile range" (IQR) in clinical data

#using range() approach (Base R way)- 
range(flights$arr_delay,na.rm = TRUE)

#using summary() approach (Base R way)
summary(flights$arr_delay)

##f you are working with millions of rows (common in high-frequency data), these operations are optimized in R. However, if you are looking for even faster execution
#In R: collapse::fmin() and collapse::fmax() are significantly faster for grouped summaries.
library(collapse)
flights %>%
  fgroup_by(carrier) %>%
  fsummarise(
    min_arr = fmin(arr_delay),
    max_arr = fmax(arr_delay)
  )

#Filtering with Dynamic Column Names (Programming)
#===================================
#.method
col_name <- "distance"
flights %>% filter(.data[[col_name]] > 1000) 

#filtering the unique rows
#=========================
#get the unique carrier
flights |> distinct(carrier)
flights |> distinct(carrier,.keep_all = TRUE) #.keep_all=To keep all other columns for the first unique row found:
#A list of every unique flight path-To get unique combinations (e.g., every unique route).
flights |> distinct(origin,dest) 
#get the unique count of tailnum and carrier, use n_distinct() to retun the count of it.
flights |> summarize(unique_planes = n_distinct(tailnum),
                     unique_carrier =n_distinct(carrier))

#
#Filtering Using Aggregates
#==========================
#Filtering by Average (mean)
#Find all flights that belong to a carrier whose average departure delay is greater than 20 minutes
flights %>%
  group_by(carrier) %>%
  filter(mean(dep_delay, na.rm = TRUE) > 20)

#Filtering by Count (n)
#Only look at airports (dest) that have a high volume of traffic (more than 10,000 flights per year).
flights %>%
  group_by(dest) %>%
  filter(n() > 10000)

#Filtering by Rank or Extreme
#Find the "First Flight of the Day" for every single carrier.
flights %>%
  group_by(carrier, year, month, day) %>%
  filter(dep_time == min(dep_time, na.rm = TRUE))

#Filtering by Sum (sum)
flights %>%
  group_by(year, month, day) %>%
  filter(sum(distance) > 1000000) |> select(year,month,day,distance) 

#Filtering by Proportion (mean of a logical)
#Find airports where more than 5% of their flights were cancelled.
# Remember: is.na(dep_time) is TRUE (1) or FALSE (0)
# The mean of a logical is the percentage/proportion.
flights %>%
  group_by(origin) %>%
  filter(round(mean(is.na(dep_time)),2) >0.05)
  
flights %>%
  group_by(origin) %>%
  summarize(p_missing = mean(is.na(dep_time)))   

colSums(is.na(flights))
flights %>%
  summarise(across(everything(), ~ mean(is.na(.x))))

flights %>%
  group_by(origin) %>%
  mutate(m_dep=mean(is.na(round(dep_time,2)))) %>% 
  summarise(across(everything(), ~ mean(is.na(.x)))) %>% select(origin,dep_time)

#Filtering Using Window Ranking Functions
#=========================================
#c(10,20,20,40)
#row_number() - (1,2,3,4)-No ties allowed. It just counts rows
#min_rank()  - (1,2,2,4(skip3)) -Ties get the same rank; it skips numbers after.
#dense_rank() -(1,2,2,3(never skip3)) -Ties get the same rank; it never skips numbers.
#percent_rank() -0, 0.33, 0.33, -Scales the rank from 0 to 1.

##first flight per carrier per day
flights %>%
  group_by(year, month, day, carrier) %>%
  arrange(dep_time) %>%
 # mutate(row_num=row_number()) |> 
  filter(row_number() == 1)

#row_number() (The "No Ties" Rank)
##Find the single most delayed flight for each carrier
##If 5 flights all have the exact same record-breaking delay, you will get all 5 rows.
flights %>%
  group_by(carrier) %>%
  filter(row_number(desc(arr_delay)) == 1)

#min_rank() (The "Competition" Rank)
##Find the flights tied for the top 3 longest delays per origin airport.
##If 5 flights all have the exact same record-breaking delay, you will get all 5 rows
flights %>%
  group_by(origin) %>%
  filter(min_rank(desc(arr_delay)) <= 3)
##Assgn : Top 5 delays per month using min_rank() ?

#dense_rank() (The "No Gaps" Rank)
##Find flights in the top 2 "delay brackets" per day.
##This is useful when you care about the distinct values of delays rather than the number of flights.
flights %>%
  group_by(year, month, day) %>%
  filter(dense_rank(desc(arr_delay)) <= 2)

#percent_rank() (The "Percentage" Rank)
##Find only the "Nightmare Flights"—those in the worst 1% of delays.
##It ignores the total count of rows and focuses on the relative position.
flights %>%
  filter(percent_rank(arr_delay) >= 0.99)
  
#cume_dist(): Cumulative Distributioncume_dist() calculates the cumulative distribution of a value within a group. 
#It answers the question: "What proportion of values are less than or equal to the current value?"Result: A number between $0$ and $1$.
#Formula: $count(x <= current\_x) / total\_rows$
df <- data.frame(score = c(10, 20, 30, 40))
df %>% mutate(dist = cume_dist(score))

#ntile(): Bucket Ranking
#ntile() takes a vector and breaks it into $n$ roughly equal "buckets" or groups. It is the go-to function for creating quartiles, deciles, or percentiles.
#Result: An integer from $1$ to $n$.
# Break data into 4 buckets
df %>% mutate(quartile = ntile(score, 4))

#filtering using case_when()
#=============================
#case_when()
##Categorizing Delay Severity
flights_classified <- flights %>%
  select(carrier, flight, arr_delay) %>%
  mutate(delay_status = case_when(
    arr_delay < 0   ~ "Early",
    arr_delay == 0  ~ "On Time",
    arr_delay <= 30 ~ "Small Delay",
    arr_delay <= 60 ~ "Late",
    arr_delay > 60  ~ "Very Late",
    TRUE            ~ "Cancelled/Unknown"  # This is the "else" or "default"
  ))

##Grouping Airports into Regions
flights %>%
  select(origin, dest) %>%
  mutate(region = case_when(
    dest %in% c("MIA", "FLL", "TPA", "MCO") ~ "Florida",
    dest %in% c("ORD", "MDW", "DTW")        ~ "Midwest",
    dest %in% c("LAX", "SFO", "SEA")        ~ "West Coast",
    TRUE                                    ~ "Other"
  ))

#Filtering Using near() (Floating Point Comparison)
#==================================================
near(6.0000000000000067,6) #valid and acept
near(6.000000067,6) #not valid and coz of 6e8 

#get the list of the near() values for exp
weather |> select(origin,temp,dewp) |> filter(between(temp,30,40)) |> distinct(temp) |> arrange(temp) |> pull(temp)
#Only catches 39 (plus invisible decimals).
weather |> select(origin,temp,dewp) |> filter(near(temp,39)) |> distinct(temp)
#using tol parameter finds the near of the range
#Catches 39.2 because $0.2 < 0.5$.
weather |> select(origin,temp,dewp) |> filter(near(temp,39,tol = 0.5)) |> distinct(temp)
#round(temp)==36 Mathematically rounds everything to the nearest whole 36
weather |> select(origin,temp,dewp) |> filter(round(temp) == 36) |> distinct(temp)
#floor(temp) == 30 -Catches  because it "cuts off" the decimal.
weather |> select(origin,temp,dewp) |> filter(floor(temp) == 30) |> distinct(temp)

#Filtering all the data in the current group
#===========================================
#when you wanted to refer to "all the data in the current group" inside a function like filter() or mutate(), 
#pick() was introduced because it is more flexible and consistent with other new functions.
#you used cur_data()

#old way
#cur_data()-Older way to get the data; replaced by pick().
flights %>%
  group_by(dest) %>%
  filter(nrow(cur_data())<=2) |> 
  select(year, month, day, carrier, flight, dest)

#new way
#pick() -When you need the actual data/columns of the group.
flights %>%
  group_by(dest) %>%
  filter(nrow(pick(everything()))<=2) |> 
  select(year, month, day, carrier, flight, dest)

#pro way
#n() -When you only need the count of rows (the most efficient choice).
flights %>%
  group_by(dest) %>%
  filter(n() <= 2) %>%
  select(year, month, day, carrier, flight, dest)

#Filtering with String Conditions
#================================
#Exact vs. Partial Matches
# == Finding an exact match only.
# Exact Match: Only flights to Seattle
flights %>% filter(dest == "SEA")
#str_detect()-Finding a pattern anywhere in the string.
#Partial Match: Any destination containing "OR" (Orlando, Portland, etc.)
flights %>% filter(str_detect(dest, "OR"))

#Positional Filtering
#Sometimes the location of the characters matters. stringr provides dedicated functions for checking the beginning or end of a string, 
#str_starts() / str_ends()	Matching based on position.
#which are faster and more readable than complex regex
# Find destinations starting with 'A' (Atlanta, Anchorage)
flights %>% filter(str_starts(dest, "A"))
# Find destinations ending with 'C'
flights %>% filter(str_ends(dest, "C"))

#Multiple String Conditions
#use the %in% operator for exact matches, or the "OR" pipe (|) within str_detect()
#%in%	Checking against a list of exact options.
flights %>% filter(dest %in% c("SEA", "SFO", "PDX"))
# The str_detect approach (Pattern-based)
flights %>% filter(str_detect(dest, "SEA|SFO|PDX"))

#Handling Case Sensitivity
# Method A: Standardize the column
flights %>% filter(str_to_lower(dest) == "sea")
# Method B: Use the ignore_case flag (Best for str_detect)
flights %>% filter(str_detect(dest, regex("sea", ignore_case = TRUE)))

#Negating String Filters
#To exclude specific patterns, wrap the entire condition in !.
# Keep everything EXCEPT flights to New York (JFK and LGA)
flights %>% filter(!str_detect(dest, "JFK|LGA"))

#Filtering Using Regex/Pattern
#=============================
#Basic Pattern Matching
##Find all flights to airports starting with "S":
flights %>% 
  filter(str_detect(dest, "^S"))
##Find all flights flying to airports with "New" in their name (like Newark or New Orleans).
#Filter for destinations containing "E" followed by "WR" (EWR - Newark)
flights %>%
  filter(str_detect(dest, "EWR"))
##Find flights to Florida (destinations often start with "M" for Miami/Orlando or "T" for Tampa):
flights %>% 
  filter(str_detect(dest, "MIA|MCO|TPA"))

#Using Regular Expressions (Regex)
##Regex allows you to search for complex patterns rather than just static text.
#Pattern-->Meaning-->Example
#^-->Starts with-->str_detect(dest, "^A")-->(Starts with A)
#$-->Ends with-->str_detect(dest, "ST$")-->(Ends with ST)
#.-->Any character-->str_detect(dest, "A.C")-->(A, then anything, then C)
#[ ]-->Character set-->str_detect(dest, "^[ABC]")-->(Starts with A, B, or C)
#Finding destinations that start with 'S' and end with 'C':
flights %>%
  filter(str_detect(dest, "^S.*C$")) |> select(carrier,dest) |> distinct()

#Case Insensitivity
#By default, regex is case-sensitive. To ignore case, wrap your pattern in regex(..., ignore_case = TRUE)
flights %>%
  filter(str_detect(dest, regex("sea", ignore_case = FALSE))) |> select(carrier,dest)

#Filtering by "Does NOT Match"
#To keep rows that do not match a pattern, simply add the exclamation point ! (the "not" operator) before the string function.
# Keep flights that do NOT go to JFK or LGA
flights %>%
  filter(!str_detect(dest, "JFK|LGA")) |> select(carrier,dest) |> distinct(dest)
  
#Finding destinations that start with 'S' and end with 'C':
flights |> 
  filter(str_detect(dest,"^S.C$")) |> select(carrier,dest) 

#if_any, if_all
#Extract only the number from the tailnum.N14228 -> 14228
flights |> select(carrier,tailnum) |> 
  mutate(tail_digit = str_extract(tailnum,"\\d+"))

#Replace "N" at the start of tail numbers with "USA-"
flights |> select(carrier,tailnum) |> 
 mutate(new_tail = str_replace(tailnum,"^N","USA-"))

#Find the tail number that have double letters N3ALAA 
flights |> select(carrier,tailnum) |> 
  filter(str_detect(tailnum,"([A-Z])\\1")) |> distinct()

#find the destinations that ends with either 'A' or 'N'
flights |> select(carrier,dest) |> 
  filter(str_detect(dest,"[AN]$"))  

#Advanced: Filtering Multiple Columns
#If you want to search for a pattern across multiple columns at once (e.g., any column that mentions "New"), use if_any() or if_all().
# Keep row if 'origin' OR 'dest' contains "AH"
flights %>%
  filter(if_any(c(origin, dest), ~ str_detect(.x, "AH"))) |> distinct(origin,dest)

##Filtering with Grouped data(Very Important in Real Analysis)
#============================
#Filtering inside groups is powerful.

#Example: Worst arrival delay per month
flights %>%
  group_by(month) %>%
  filter(arr_delay == max(arr_delay, na.rm = TRUE)) #Returns worst delay within each month.

#Example: Above Average Delay per Carrier
flights %>%
  group_by(carrier) %>%
  filter(arr_delay > mean(arr_delay, na.rm = TRUE)) #Keeps only flights performing worse than carrier average.

#n_groups()-counts how many piles you have made.
#you want to know how many different airlines (carrier) are in the flights dataset.
flights |> group_by(carrier) |> n_groups()

#n()- Counts rows inside each group.
flights |> group_by(carrier,origin) |> summarise(num_of_flights_per_orgin=n())
flights |> group_by(dest) |> summarise(num_of_dest = n())

#get the  unique of carrier and flight
flights |> select(carrier,flight,year,month,day) |> 
  summarise(u_car = n_distinct(carrier),
            u_fligh = n_distinct(flight))

#Filtering After Joining (Real World Scenario)
#=============================================
#Suppose we want airline names.
flights %>%
  left_join(airlines, by = "carrier") %>%
  filter(name == "Delta Air Lines Inc.")

#Filtering Top/lowest N Values
#======================
#Instead of filter(), use:
flights %>%
  slice_max(arr_delay, n = 10)
  
#lowest
flights %>%
  slice_min(arr_delay, n = 10)

#Filtering with Date-Time Logic
#==============================
##Find all flights that departed late at night or very early in the morning. 
#dep_time >= 2200 → Flights departing 10:00 PM or later
#dep_time <= 500 → Flights departing 5:00 AM or earlier
#| (OR condition) → Select flights that satisfy either condition
flights %>%
  filter(dep_time >= 2200 | dep_time <= 500)
  
##Filter Earliest Flight (Minimum Date):Find the earliest flight in the dataset
flights %>%
  filter(time_hour == min(time_hour, na.rm = TRUE))

##Filter Latest Flight (Maximum Date)
flights %>%
  filter(time_hour == max(time_hour, na.rm = TRUE))
  

##Which flights occurred on or after March 1, 2013?
flights %>%
  filter(time_hour >= as.POSIXct("2013-03-01"))

##Filter Flights Within a Date Range:Flights between January 1 and January 15
flights %>%
  filter(
    time_hour >= as.POSIXct("2013-01-01") &
      time_hour <= as.POSIXct("2013-01-15")
  )

##Same Range Filtering Using between() (Cleaner) as above
flights %>%
  filter(between(time_hour,
                 as.POSIXct("2013-01-01"),
                 as.POSIXct("2013-01-15")))


#Filtering Using Cumulative Logic
#===============================
## how many flights it takes to reach a certain amount of delay time in a day. Find flights that contributed to the first 1000 minutes of delay at JFK 
flights %>% 
  select(origin, month, day, dep_delay) |>
  filter(origin == "JFK", !is.na(dep_delay)) %>%
  group_by(month, day) %>% 
  arrange(month, day, (dep_delay)) |>
  mutate(running_delay = cumsum(dep_delay)) %>%
  filter(running_delay <= 1000)
  
#Filtering by Frequency
#======================
#count()- Only one row per carrier remains.  
#------------
#How many flights did each airline operate? 
flights %>% 
  count(carrier, sort = TRUE)
  
#Internal Implementation
#count()
flights %>%
  group_by(carrier) %>%
  summarise(n = n())
  
#add_count()
flights %>%
  group_by(carrier) %>%
  mutate(n = n()) %>%
  ungroup()
  
  
#add_count() -Adds a count column to the original dataset 
#------------
#add_count() is an "expanding" function. It calculates the totals but adds them as a new column to your existing dataset without removing any rows or other columns. 
#It works like group_by() %>% mutate(n = n()).

#For each flight, how many flights does that airline operate overall? When you want counts attached to each row
flights %>% 
  add_count(carrier) %>% glimpse() #observe a n column which gives a count of rows.
  
##Filter Frequent Carriers:Keep airlines that appear at least twice
##purpose: Remove rare airlines and keep only frequently occurring carriers.
flights %>%
  add_count(carrier) %>%   # count frequency of each carrier
  filter(n >= 2)          # keep carriers appearing at least twice
  
#Filter Frequently Used Aircraft (Tail Numbers):Keep aircraft that flew at least 50 times
#purpose:Analyze aircraft with enough flight records.
flights %>%
  add_count(tailnum) |> 
  filter(n >= 50)

#Filter Popular Routes:Keep routes that occurred at least 100 times
#pur: Keep commonly traveled routes and remove rare routes.
flights %>%
  add_count(origin, dest) %>%
  filter(n >= 100)
  

#Filtering Based on Computed Conditions
#======================================
##Which flights still have more than 30 minutes delay even after subtracting a 10-minute buffer?
##Flights with arrival delay after subtracting buffer
#arr_delay - 10	== Adjust delay by removing 10 minutes
#> 30== Still delayed more than 30 minutes
flights %>%
  filter(arr_delay - 10 > 30)
  
#Filtering by First / Last Within Groups  
#=======================================
#The first/last row depends on the order of the dataset. Usually we sort first.

#What is the first recorded flight from each origin airport?
flights %>%
  group_by(origin) %>%
  filter(row_number() == 1) %>%
  select(origin, carrier, flight, time_hour)

#What is the last recorded flight from each origin airport?
flights %>%
  group_by(origin) %>%
  filter(row_number() == n()) %>% #
  select(origin, carrier, flight, time_hour)
  
#Instead of row_number() you can use:
slice_head(n = 1)
slice_tail(n = 1)

#Filtering Using Lead/Lag for Change Detection
#=============================================
#lead() and lag() are used to compare a row with the next or previous row.
#This is useful for detecting changes, trends, or transitions in sequential data.

#Function	Meaning
#lag(x)	Value from the previous row
#lead(x)	Value from the next row

#Detect Change from Previous Row (lag())
#Which flights have a different departure delay compared to the previous flight?
flights %>%
  filter(dep_delay != lag(dep_delay))
##Only rows where delay changed are kept.

#Detect Change Within Groups
#Which flights have a different delay compared to the previous flight of the same airline?
flights %>%
  group_by(carrier) %>%
  arrange(carrier,dep_delay) |> 
  filter(dep_delay != lag(dep_delay))
##Now comparison happens within each carrier.

#Detect Increase Compared to Previous Row
#Which flights have larger delay than the previous flight?
flights %>%
  filter(dep_delay > lag(dep_delay))
#This finds increasing delays.

#Detect Decrease Compared to Previous Row
#Which flights have smaller delay than the previous flight?
flights %>%
  filter(dep_delay < lag(dep_delay))

#Compare with Next Row (lead())
#Which flights have delay smaller than the next flight?
flights %>%
  filter(dep_delay < lead(dep_delay))
#This compares current row with next row.

#Detect Delay Change Between Consecutive Flights
#Where did the delay change between two consecutive flights?
flights %>%
  filter(dep_delay != lead(dep_delay))

#Find Turning Points
#Which flights represent a peak delay compared to both neighbors?
flights %>%
  filter(dep_delay > lag(dep_delay) & dep_delay > lead(dep_delay))
#previous delay < current delay > next delay. These are local peaks.

#lead() and lag() depend on row order.
#So normally you should sort first.
flights %>%
  arrange(time_hour) %>%
  filter(dep_delay != lag(dep_delay))
  
#Filtering with External Lookup Tables/values
#============================================
#By values(hard coded values)
valid_tailnums <- planes |> filter(year > 2010) |> pull(tailnum)
length(unique(valid_tailnums))
# Filtering the main table
flights |> 
  filter(tailnum %in% valid_tailnums) |> select(carrier,tailnum) 

#Tables
cust_tailnums <- tibble(tailnum=c("N101DQ","N101DU","N101NN","N102DN"))
dim(cust_tailnums)
flights |> semi_join(cust_tailnums,by="tailnum") |> 
  select(carrier,tailnum) |> 
  distinct(tailnum)
  
##dyanmic
new_planes<- planes |> filter(year>2010,str_starts(tailnum,"N101")) |> select(seats,tailnum)
#Perform the semi_join(Columns from the first table only)
flights %>% 
  semi_join(new_planes, by = "tailnum") |> glimpse() |> distinct(carrier,tailnum)  

#Filtering Rows That Are Duplicates
#==================================
#find the unique of carrier and destination
#The "Clean" Way: distinct()
#---------------------------
#distinct()-If you just want to get rid of duplicates and keep one unique row for every occurrence, use distinct().
flights |> distinct(carrier, dest)
##.keep_all = TRUE: Ensures you keep all other columns in the dataset
flights |> distinct(carrier, dest,.keep_all = TRUE)

#using dplyr
flights |> 
  group_by(flight,year,month,day,carrier) |> 
  filter(n()>1) |> 
  ungroup() |> 
  relocate(flight,year,month,day,carrier,everything())
 
#using add_count() 
flights |> 
  add_count(flight,year,month,day,carrier) |> 
  filter(n>1) |> 
  select(-n) #drop that column.
  
#The "Investigation" Way: get_dupes()
#------------------------------------
#If you want to see which rows are duplicates (to see the actual data that is repeating), the janitor package has the best tool for this.
library(janitor)
flights |> 
  get_dupes(year, month, day, hour, carrier) |> glimpse()
#This will return every row that shares those exact values, 
#along with a dupe_count column so you can see how many times that specific combination appeared.

#The "Logic" Way: duplicated() #not working 
#-----------------------------
#If you want to stay within dplyr without extra packages, you can use the base R duplicated() function inside a filter().
#To see the duplicates:
flights |> 
  filter(duplicated(select(flights,year, month, day, carrier)) |
           duplicated(select(flights, year, month, day, carrier, flight), fromLast = TRUE))
#Note: Using fromLast = TRUE ensures you see both the original and the copy

#To remove the duplicates (the hard way): Keeps the 1st copy
flights |>  filter(!duplicated(pick(everything())))
##best way and faster way using distinct(deletes others.)
flights |> distinct(year, month, day, carrier) |> nrow()
flights |> distinct()

#base R way using as vector
#--------------------------
u_carr <- flights |> select(carrier) |> pull()
typeof(u_carr)
unique(u_carr)
length(unique(u_carr))

#Simple dataset with one clear duplicate
mini_flights <- tibble(
  day = c(1, 2, 1, 3),
  carrier = c("AA", "DL", "AA", "UA"),
  flight = c(101, 500, 101, 202)
)
mini_flights
#To FIND the Duplicates
mini_flights |> 
  filter(
    duplicated(pick(day, carrier, flight)) | 
      duplicated(pick(day, carrier, flight), fromLast = TRUE)
  )
#fromlast=TRUE, show the duplicate rows else False returns 1 rows
#To REMOVE the Duplicates
mini_flights |> distinct()
#The Logical Filter Way
mini_flights |> filter(!duplicated(pick(day, carrier, flight)))


#Filtering with "Predicate(where) Functions" (if_any / if_all with types)
#==========================================
#Predicate functions are To filter based on data type (Numeric, Factor, Date).
#You already know if_any(starts_with(...)). A pro move is filtering based on data types rather than column names.

#EX:"Keep rows where ANY numeric column has a value over 1000, but ignore the character columns."
# Find rows where any number is massive, regardless of the column name
weather |> 
  filter(if_any(where(is.numeric), ~ .x > 100))
  
#Filtering Based on Percentiles
#==============================
#R calculates one single threshold for the entire dataset .its too advanced.
#Any flight delayed more than 75 minutes is in the top 10% of all flights
flights %>%
  filter(arr_delay > quantile(arr_delay, 0.9, na.rm=TRUE))
  
#Filtering Using relocate() + conditions (pipeline logic)
#======================================================== 
#Relocate by Logic (Column Type/Name)
##Instead of typing every column name, you can use tidy-select functions inside relocate() to bring important data forward before you apply your filter.
#I want to see the airline, origin, and delays first, then filter for the 2-hour delays
flights %>%
  # Move all character columns and anything with "delay" to the front
  relocate(where(is.character), contains("delay")) %>%
  # Now filter based on the columns you just moved
  filter(arr_delay > 120)

#The "Verify and Filter" Pipeline
#A common workflow is to use relocate() to move the column you are about to filter on to the first position. This is a "sanity check" for your code.
flights %>%
  # 1. Bring the target column to position 1
  relocate(air_time) %>% 
  # 2. Filter based on that column
  filter(air_time < 30) %>%
  # 3. (Optional) Relocate back or keep for inspection
  relocate(origin, dest, .after = air_time)

#Conditional Relocation (Advanced)
#relocate() doesn't have a "condition" argument for rows, but you can use it to organize columns based on column statistics.
#If you want to move columns to the front only if they have a certain amount of missing data (NAs), you can do this:
colSums(is.na(flights))
flights %>%
  # Move columns with more than 1000 NAs to the front
  relocate(where(~ sum(is.na(.x)) > 1000)) %>%
  # Then filter out those NAs
  filter(!is.na(dep_time))

#Filtering Nested Data
#=====================
#In the R tidyverse, "Nested Data" usually refers to a list-column—where a single cell in a tibble contains an entire data frame (or a list of values). 
#Filtering this kind of data is a bit different because you aren't just filtering rows;you are filtering the data inside the rows

#The Scenario: Nested Flights
#Imagine you have nested your flights by carrier. You now have a tibble with two columns: carrier and data (the nested tibble)
# Create nested data
nested_flights <- flights %>%
  group_by(carrier) %>%
  nest()

#Filtering Based on Nested Content
#If you want to keep only the carriers that have at least one flight with a delay over 500 minutes, you can't use a standard filter. 
#You have to "reach into" the nested list
long_delay_carriers <- nested_flights %>%
  filter(map_lgl(data, ~ any(.x$arr_delay > 500, na.rm = TRUE)))
#filter(...): Operates on the rows of the top-level tibble (the 16 carriers)
#map_lgl(data, ...): This "maps" over the data column. The lgl stands for logical, meaning it expects a TRUE or FALSE for every row
#any(.x$arr_delay > 500): For each carrier's mini-table (.x), it checks if any row meets the criteria.

#Filtering the Nested Data Itself
#Sometimes you don't want to remove the carrier; you just want to filter the rows inside the nested tables (e.g., keep all carriers, but remove all on-time flights from their nested data).
only_delayed_nested <- nested_flights %>%
  mutate(data = map(data, ~ filter(.x, arr_delay > 0)))
#This keeps the carrier "UA," but the tibble inside its data cell now only contains delayed flights

#Filtering by Nested Summary Statistics
#You can also filter carriers based on an aggregate value of their nested data (like average delay)
high_avg_carriers <- nested_flights %>%
  filter(map_dbl(data, ~ mean(.x$arr_delay, na.rm = TRUE)) > 20)  
  
#Filtering joins
#===============
#Filtering joins filter rows from x based on the presence or absence of matches in y:
#Table A: Heroes
heroes <- tribble(
  ~name,    ~pub_id,
  "ChotaBeem",  1,
  "BalaGanesh", 3
)

# Table B: Pubs
pubs <- tribble(
  ~pub_id, ~pub_name,
  1,       "ChotaBeem",
  2,       "JaiHanuman"
)
#semi_join()
##Keeps rows in the left table only if they have a match in the right (but adds no new columns).
semi_join(heroes, pubs, by = "pub_id")
##Result: Only ChotaBeem (He has a matching publisher)

#anti_join()
##Keeps rows in the left table only if they don't have a match in the right.
anti_join(heroes, pubs, by = "pub_id")
## Result: Only BalaGanesh (Pub_id 3 is not in the Pubs table)

#Filtering Rows Based on Another Table (Semi Join Concept)
#=========================================================
#Flights going to airports in California:
airports %>%
  filter(tzone %in% "America/Chicago")

flights %>%
  semi_join(ca_airports, by = c("dest" = "faa"))
  
#Filtering using the "Invert" of a Join (anti_join)
#=================================================
#You mentioned semi_join, but its "evil twin" anti_join is the ultimate data-cleaning tool. 
#It finds the "orphans" or the "mismatches."

#EX: Find all flights where the plane's tailnum does not exist in the planes table (detecting data gaps)
flights |> 
  anti_join(planes, by = "tailnum") |> glimpse() |> select(flight,tailnum)

#check in planes datasets
planes |> filter(tailnum %in% c("N302DN","N308DN"))  

#Filter Syntax Sematics
#======================

#filter()-Keeps rows where condition is TRUE
#-------
#syntax: filter(.data, ..., .by = NULL, .preserve = FALSE)
##.data --> input dataset
filter(flights, arr_delay > 30)
##... (Conditions) --> Logical expressions used to filter rows
##Key Points:
  ##Multiple conditions = AND (&)
  ##Use | for OR
  ##Supports functions (is.na, between, etc.)
filter(flights, arr_delay > 30, origin == "JFK")
##.by (New in dplyr 1.1+) -->Temporary grouping inside filter() without group_by()
filter(flights, arr_delay <=min(arr_delay,na.rm = TRUE), .by = month)
###equivalent to above code
flights %>%
  group_by(month) %>%
  filter(arr_delay == max(arr_delay)) %>%
  ungroup()
##.preserve --> Controls grouping structure after filtering
#lets a take a simple example.
df <- data.frame(
  group = c("A", "A", "B", "B"),
  value = c(10, 20, 5, 8)
)
df
##preserve = FALSE After filtering, groups that have no rows left are dropped
df %>%
  group_by(group) %>%
  filter(value > 15,.preserve = FALSE) %>%
  summarise(n = n())
##preserve = TRUE -All original groups (months) are preserved
##Even if a group has zero rows after filtering, it still exists internally
##So no group becomes empty
df %>%
  group_by(group) %>%
  filter(value > 15,.preserve = TRUE) %>%
  summarise(n = n())
  
#filter_out()
#-----------
#filter_out()	Removes rows where condition is TRUE
#flights delayed more than 1 hour
flights %>%
  filter(arr_delay > 60)
#Remove flights delayed more than 1 hour
flights %>%
  filter_out(arr_delay > 60)
 ##equivalent 
flights %>%
  filter(!arr_delay > 60)
  
#filter_all() → apply condition to ALL columns
#-------------
#helper functions
#all_vars() -All conditions must be TRUE
#any_vars() -At least one condition must be TRUE
#These are now replaced by if_all() and if_any() with across()

#Keeps rows where ALL columns satisfy condition
#Keep rows where all numeric values are positive
flights %>%
  select(dep_delay, arr_delay, distance) %>%
  filter_all(all_vars(. > 0))
  
#filter_all() equivalent:
flights %>%
  filter(if_all(c(dep_delay, arr_delay), ~ . > 0))

#filter_if() → apply condition based on column TYPE
#-----------
#Applies condition to columns that satisfy a predicate
#Remove rows where any numeric value is negative
flights %>%
  select(dep_delay, arr_delay, distance) %>%
  filter_if(is.numeric, all_vars(. >= 0))
  
#Keep rows where all numeric columns are NOT NA
flights %>%
  select(dep_delay, arr_delay, distance) %>%
  filter_if(is.numeric, all_vars(!is.na(.)))
  
#filter_if() equivalent:
flights %>%
  filter(if_all(where(is.numeric), ~ !is.na(.)))
  
#filter_at() → apply condition to SELECTED columns
#-----------
#You choose specific columns
#Keep rows where dep_delay & arr_delay > 0
flights %>%
  filter_at(vars(dep_delay, arr_delay), all_vars(. > 0))
  
#Any delay > 60
flights %>%
  filter_at(vars(dep_delay, arr_delay), any_vars(. > 60))
  
#filter_at() equivalent:
flights %>%
  filter(if_any(c(dep_delay, arr_delay), ~ . > 60))
  
#Old Function->New Approach
#filter_all()->if_all()
#filter_if()->if_all(where())
#filter_at()->if_any() / if_all()

#In Nutshell
#filter_all() = apply to all columns
#filter_if() = apply to columns by condition (type)
#filter_at() = apply to specific columns
#Modern across() unifies everything

#Practical Business Scenarios
#============================
#Scenario 1: Flights delayed more than 30 mins in summer from JFK
flights %>%
  filter(origin == "JFK",
         month %in% 6:8,
         arr_delay > 30)
		 
#Scenario 2: Flights cancelled due to weather
weather_delays <- flights %>%
  filter(is.na(dep_time) & !is.na(weather$precip))

#Quiz
#====
  
#Assignment
#==========
AE<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/ae.csv")
DM<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/dm.csv")
VS<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/vs.csv")
EX<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/ex.csv")
LB<-read_csv("https://raw.githubusercontent.com/ganeshbabuNN/datasets/refs/heads/master/clinical_datasets/sdtm/daibetes/csv/lb.csv")

#DM (Demographics) – Filtering Assignments
#-----------------------------------------
#1.Filter male subjects only. 
#2.Filter subjects older than 65 years.
#3.Filter subjects belonging to STUDYID "ABC123".
#4 Filter subjects randomized to Treatment Arm A.
#5 Filter subjects from USA and Canada only. Use %in%.

#AE (Adverse Events)
#------------------
#6 Filter serious adverse events.
#7 Filter severe adverse events.
#8 Filter treatment related adverse events.
#9 Filter AEs that started after first dose date.
#10 Filter AEs ongoing at end of study.
#11 Filter AEs occurring in first 30 days after treatment.
#12 Filter subjects having more than 3 adverse events. Use group_by() + filter(n() > 3).

#VS (Vital Signs)
#---------------
#13 Filter high systolic blood pressure (>140).
#14 Filter low heart rate (<50 bpm).
#15 Filter vital signs collected during screening visit.
#16 Filter abnormal vital signs results.
#17 Filter subjects with increasing blood pressure compared to previous visit. Use lag().
#18 Filter subjects who received study drug.
#19Filter missed doses.
#20 Filter exposures before adverse event start date.
#21 Filter subjects who received more than 10 doses. Use group_by(USUBJID).
#22 Filter highest dose per subject. Use max(EXDOSE).

#LB (Laboratory)
#---------------
#23 Filter abnormal lab results.
#24 Filter ALT values greater than 3× upper normal limit.
#25 Filter lab tests collected after treatment start.
#26 Filter highest lab value per subject. Use slice_max().
#27 Filter lab values missing results.

#CM (Concomitant Medication)
#---------------------------
#28 Filter medications related to hypertension.
#29 Filter medications started before study drug.
#30 Filter ongoing medications.
#31 Filter subjects taking more than 5 medications. Use group_by(USUBJID).

#SV (Subject Visits)
#-------------------
#32 Filter screening visits only.
#33 Filter unscheduled visits.
#34 Filter visits occurring after Day 30.
#35 Filter subjects who missed visits.
#36 Filter subjects who discontinued study.
#37 Filter subjects who completed study.
#38 Filter discontinuation due to adverse event.
#39 Filter subjects withdrawn due to lack of efficacy.
#40 Filter subjects discontinued within first 60 days. Use between() or date calculation.

#Advanced Cross-Domain Assignments
#-----------------------------------
#These mimic real clinical analysis queries.
#41 Find subjects with severe adverse events who received high dose drug.Join AE + EX.
#42 Find subjects with abnormal lab results after treatment start.Join LB + EX.
#43 Find subjects with hypertension medication and high blood pressure. Join CM + VS.
#44 Find subjects discontinued due to adverse events.Join DS + AE.
#45 Find subjects with more than 2 serious adverse events and discontinued study. Join AE + DS.

#Resources:
#=========
#https://dplyr.tidyverse.org/reference/arrange.html

                                                        