#Types of join
#Understanding by parameter
#Handling Duplicate Keys (Many-to-Many)
#Filtering Joins (Very Important)
#Handling Missing Values After Join
#Suffix Handling
#Chaining Multiple Joins
#Performance Tips
#Advanced Joins 
#Cross Join
#Self Join
#Debugging Joins
#Real Pipeline Example
#Join Relationships
#join_by() (Advanced Key Control)
#Non-Equi Joins (Powerful Concept)
#Rolling Joins (Time Matching)
#Overlap Joins (Range Matching)
#Multiple Condition Joins
#Joining with Aggregated Tables
#Join + Mutate Pattern
#Coalescing After Join
#Detecting Data Issues via Join
#Join Order Matters
#Lazy Joins (Database / Big Data)
#Memory Optimization Strategy
#Joining Lists / Nested Data
#Join with distinct()
#Join + Window Functions
#Iterative Joins (Loop / Functional)
#Join Audit Table (Professional Trick)
#Cartesian Explosion
#Join Validation Checklist
#join Syntax Sematics

library(dplyr)
library(nycflights13)

#Intro
#=====
#What is a Join
#A join combines rows from two tables based on a key column.


#Types of join
#=============
#1.inner_join() -Only keeps rows where the ID exists in both tables
#2.left_join() -Keeps everything from the left table; adds data from the right where it matches 
#3.right_join()-Keeps everything from the right table; adds data from the left where it matches. 
#4.full_join()-Keeps all rows from both tables, filling missing matches with NA
#5.nest_join()-Keeps the left table as-is but adds a list of matches as a mini-table inside a new
#6.semi_join()-Keeps rows in the left table only if they have a match in the right (but adds no new columns).
##filter joins
#7.anti_join()-Keeps rows in the left table only if they don't have a match in the right.
#8.cross_join()-Matches every row from the first table with every row of the second (100% combination).
#9.join_by()-A helper used inside a join to define how to match (e.g., if column names are different or use math).

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

#inner_join()
#Keeps only matching rows
#Only keeps rows where the ID exists in both tables.
inner_join(heroes, pubs, by = "pub_id")
# Result: Only ChotaBeem man (he has pub_id 1, which exists in both)
flights %>% inner_join(airlines, by = "carrier")
#Use when:
##You want only valid matches
##Example: only flights with known airlines

#left_join()
#Keeps all rows from left table
#Keeps everything from the left table; adds data from the right where it matches
left_join(heroes, pubs, by = "pub_id")
# Result: ChotaBeem and BalaGanesh (BalaGanesh gets NA for pub_name)
flights %>%left_join(airlines, by = "carrier")
#Use when:
##You want to enrich data
##Very common in SDTM derivations

#right_join()
#Keeps everything from the right table; adds data from the left where it matches
right_join(heroes, pubs, by = "pub_id")
# Result: ChotaBeem and JaiHanuman (JaiHanuman gets NA for name)
flights %>% right_join(airlines, by = "carrier")
##Keeps all rows from right table

#full_join()
#Keeps all rows from both tables, filling missing matches with NA.
full_join(heroes, pubs, by = "pub_id")
# Result: ChotaBeem , HeBalaGanesh, and JaiHanuman
flights %>% full_join(airlines, by = "carrier")
##Keeps everything from both tables

#nest_join()
#Keeps the left table as-is but adds a list of matches as a mini-table inside a new column.
#it is like putting an envelope (the list-column) on the original page, and putting all the matches inside that envelope
nest_join(pubs, heroes, by = "pub_id")
# Result: DC row contains a mini-table with "ChotaBeem"; JaiHanuman row contains an empty table.
test<-nest_join(pubs, heroes, by = "pub_id")
test$heroes[[1]] #to open the 1 tibble
test |> unnest(heroes) #from tidyr, using uunest() metho

#semi_join()
#same as left_join()
#Keeps rows in the left table only if they have a match in the right (but adds no new columns or rows).
semi_join(heroes, pubs, by = "pub_id")
# Result: Only ChotaBeem (He has a matching publisher)

#anti_join()
#Keeps rows in the left table only if they don't have a match in the right
anti_join(heroes, pubs, by = "pub_id")
# Result: Only BalaGanesh (Pub_id 3 is not in the Pubs table)

#cross_join()
#Matches every row from the first table with every row of the second (100% combination).
cross_join(heroes, pubs)
# Result: 4 rows (ChotaBeem -DChotaBeem, chotabeem-jaihunman,balaganesh-chotabeem,balaganesh-jaihanuman)

#join_by()
#A helper used inside a join to define how to match (e.g., if column names are different or use math).
inner_join(heroes, pubs, by = join_by(pub_id))
# Result: Used inside the join to tell dplyr exactly which keys to pair up.

sales <- tibble(
  id = c(1L, 1L, 1L, 2L, 2L),
  sale_date = as.Date(c("2018-12-31", "2019-01-02", "2019-01-05", "2019-01-04", "2019-01-01"))
)
sales

promos <- tibble(
  id = c(1L, 1L, 2L),
  promo_date = as.Date(c("2019-01-01", "2019-01-05", "2019-01-02"))
)
promos

# Match `id` to `id`, and `sale_date` to `promo_date`
by <- join_by(id, sale_date == promo_date)
left_join(sales, promos, by)

# For each `sale_date` within a particular `id`,
# find only the closest `promo_date` that occurred before that sale
by <- join_by(id, closest(sale_date >= promo_date))
left_join(sales, promos, by)

#Understanding by parameter
#==========================
##Same Column Name
left_join(flights, airlines, by = "carrier")
##Different Column Names
left_join(flights, airports, by = c("dest" = "faa"))
#flights$dest matches airports$faa

##Multiple Keys
left_join(flights, weather, by = c("origin", "time_hour"))
#Very important in real-world datasets

#Handling Duplicate Keys (Many-to-Many)
flights %>% left_join(weather, by = c("origin", "time_hour"))
#If duplicates exist:Rows will multiply,This is expected behavior
count(weather, origin, time_hour) %>%
filter(n > 1)

#Filtering Joins (Very Important)
#================================
##Semi Join:Keep rows that have match
flights %>% semi_join(airlines, by = "carrier") #No new columns added

##Anti Join:Find unmatched rows
flights %>% anti_join(airlines, by = "carrier")
#Used for: Data quality checks,Missing reference data

#Handling Missing Values After Join
#==========================
colSums(is.na(planes))
colSums(is.na(flights))
##Finds flights with missing plane info ? which tailnum taken as preferenced.
flights |> 
  left_join(planes,by="tailnum") |> 
  select(flight,tailnum,type,manufacturer) |> 
  filter(is.na(tailnum))
 ##check for other join()

#Suffix Handling
#=============
##When both tables have same column names : this will rename only the common column.
left_join(flights, weather, 
          by = c("origin", "time_hour"),
          suffix = c("_flight", "_weather")) 
##to suffix both the datasets forcely using rename_with()
flights |> 
  left_join(weather,by=c("origin","time_hour"),suffix=c("_f","_w")) |> 
  rename_with(~paste0(.,"_w"),any_of(names(weather))) |>  
  rename_with(~paste0(.,"_f"),any_of(names(flights))) |>
  glimpse()
		  
#Chaining Multiple Joins
#=======================
##Typical real-world pipeline
flights %>%
  left_join(airlines, by = "carrier") %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  left_join(planes, by = "tailnum")
##mixed joins
flights |> 
  left_join(airlines,by="carrier") |> 
  inner_join(airports,by=c("dest"="faa")) |> 
  semi_join(planes,by="tailnum")
  
#Performance Tips
#================
##Select Only Needed Columns
airlines_small <- airlines %>% select(carrier, name)
flights %>%
  left_join(airlines_small, by = "carrier")
  
flights |> 
  select(year,month,day,flight,dep_delay,carrier,dest,tailnum) |> #flight
  left_join(airlines,by="carrier") |> 
  select(year,month,day,flight,dep_delay,carrier,dest,tailnum,name) |> #flight+airlines
  inner_join(airports,by=c("dest"="faa")) |> 
  select(year,month,day,flight,dep_delay,carrier,dest,tailnum,name.x,name.y) |> #flight+ airlines +airport
  semi_join(planes,by="tailnum") 

#Advanced Joins (Power Concepts)
#================
##Non-equi Join (via filter)
flights %>%
  inner_join(weather, by = "origin") %>%
  filter(time_hour >= time_hour.y)
  
#Cross Join
tidyr::crossing(
  flights %>% select(origin),
  airlines
)

#Self Join
staff <- tibble(
  emp_id = c(1,2,3,4),
  name=c("A","B","C","D"),
  manager_id=c(NA,1,1,2)
)
staff

#in the above if you want see the name of the employee and the nameof the manager side-by-side , which join?
staff |> 
  inner_join(staff,
             by=c("manager_id"="emp_id"),
            suff=c("_emp","_mang"))

##SDTM / Clinical Data Perspective
#Add DM info to AE-->left_join()
#Check missing EX vs DM-->anti_join()
#Subset valid subjects-->semi_join()
#Merge VS + LB-->inner_join()

#Debugging Joins
#================
##Check unmatched rows
flights %>%
  anti_join(airlines, by = "carrier")
  
##Check row counts before/after
nrow(flights)
nrow(flights %>% left_join(airlines))

#Real Pipeline Example
#================
flights %>%
  left_join(airlines, by = "carrier") %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  group_by(name, dest) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))
  
#Join Relationships
#================
##Types:
##"one-to-one"
##"one-to-many"
##"many-to-one"
##"many-to-many"
##Prevents silent data explosion
##Very important in regulated environments  
##one- to-one
##precheck
daily_weather |> select(year,month,day,origin) |> nrow()
unique_days |> select(year,month,day,origin) |> nrow()
unique_days |> select(year,month,day,origin) |> distinct()

daily_weather <-weather |> 
                   group_by(year,month,day,origin) |> 
                  summarise(temp=mean(temp,na.rm = TRUE))

unique_days<- flights |> distinct(year,month,day,origin)

unique_days|> 
  inner_join(daily_weather,by=c("year","month","day","origin"),
            relationship = "one-to-many")
#one-to-Many
planes |> select(tailnum) |> nrow()
flights |> select(tailnum) |> nrow()

planes |> 
  inner_join(flights,by="tailnum",relationship ="one-to-many")

#many-to-many
flights |> select(origin) |> nrow()
weather |> select(origin) |> nrow()

flights |> 
  inner_join(weather,by="origin",relationship ="many-to-many")
#this is data explosion and should not be used anywhere

#join_by() (Advanced Key Control)
##Modern way to define joins
flights %>%
  left_join(airports, join_by(dest == faa))
  
#Non-Equi Joins (Powerful Concept)
##Join using conditions instead of equality
flights %>%
  left_join(weather, 
            join_by(origin, time_hour >= time_hour))
flights |> 
  left_join(weather,by=join_by(origin,year,month,day,
                               time_hour >=time_hour))
#Used in:
##Time-based joins
##Rolling joins
##Window matching			

#Rolling Joins (Time Matching)
#================
##Match closest previous record
flights %>%
  left_join(weather,
            join_by(origin, closest(time_hour)))
			
flights |> 
  left_join(weather,by=join_by(origin,year,month,day,
                               closest(time_hour >=time_hour)))
#Real-world usage:
#================
##Match latest lab value before visit
##Match last transaction before event

#Overlap Joins (Range Matching)
##Join based on intervals
# Example idea (not directly in dataset)
join_by(start <= date, end >= date)
#Used in:
##Clinical trials (treatment periods)
##Subscription windows
##Exposure periods

#Multiple Condition Joins
#================
#More precise than time_hour
flights %>%
  left_join(weather,
            join_by(origin, year, month, day, hour))
			
#Joining with Aggregated Tables
#==============================
##Pre-summarize before joining			
weather_summary <- weather %>%
  group_by(origin) %>%
  summarise(avg_temp = mean(temp, na.rm = TRUE))

flights |> 
  left_join(weather_summary,by='origin',relationship = "many-to-one") |> 
  select(flight,carrier,tailnum,origin,avg_temp)
 ##Prevents duplication
##Improves performance

#Join + Mutate Pattern
#================
flights %>%
  left_join(planes, by = "tailnum") %>%
  mutate(age = year - year.y)
##Very common in feature engineering

#Coalescing After Join
##Combine columns after full join
df <- full_join(df1, df2, by = "id") %>%
  mutate(value = coalesce(value.x, value.y))
#Used in:
##Data reconciliation
##Multi-source merging  

flights |> 
    left_join(planes,by='tailnum') |> 
    transmute(carrier,tailnum,age=coalesce((year.x-year.y),0))
#its age is temp varible in the pipe(), 
#mutate is adds new varibable or changes existing ones while keeping all orginal variables.
#transmute create new variable and drops every column which is not mentioned.

#Detecting Data Issues via Join
#==============================
##Duplicate keys
flights %>%
  count(tailnum) %>%
  filter(n > 1)
  
##Missing reference
flights %>%
  anti_join(planes, by = "tailnum")
##This is data quality validation using joins

#Join Order Matters
#==================
# Different results
flights %>% left_join(weather)
weather %>% left_join(flights)
#Always think:
##"Which is my base dataset?"

#Lazy Joins (Database / Big Data)
#==============================
##Same syntax works with:
##SQL databases
##Spark
##Arrow

tbl(con, "flights") %>%
  left_join(tbl(con, "airlines"), by = "carrier")
  
##Joins executed in database (not memory) 

#Memory Optimization Strategy
#============================
##Reduce columns BEFORE join
airlines_small <- airlines %>% select(carrier, name)

##Reduce rows BEFORE join
flights_small <- flights %>% filter(year == 2013)
##Huge performance improvement

#Joining Lists / Nested Data
#============================
nested <- flights %>%
  group_by(carrier) %>%
  nest()

nested %>%
  left_join(airlines, by = "carrier")
  
##Used in:
##Model pipelines
##Per-group analysis

#Join with distinct()
#===================
##Avoid duplicates before joining
planes_unique <- planes %>%
  distinct(tailnum, .keep_all = TRUE)

flights %>%
  left_join(planes_unique, by = "tailnum")
  
#Join + Window Functions
#=======================
flights %>%
  left_join(airlines, by = "carrier") %>%
  group_by(name) %>%
  mutate(rank = dense_rank(desc(arr_delay)))
##Used in ranking, scoring

#Iterative Joins (Loop / Functional)
#==================================
tables <- list(airlines, airports, planes)
Reduce(function(x, y) left_join(x, y), tables)
##Useful for pipelines

#Join Audit Table (Professional Trick)
#==================================
##Track join success
flights %>%
  left_join(planes, by = "tailnum") %>%
  mutate(join_flag = ifelse(is.na(manufacturer), "missing", "matched")) %>%
  count(join_flag)
##Used in:
##Regulatory reporting
##ETL validation

#Cartesian Explosion (Critical Risk)
#==================================
# Danger if both sides have duplicates
left_join(df1, df2, by = "id")
#Always check:
count(df1, id)
count(df2, id)

#Join Validation Checklist (Industry Level)
#==================================
##Before joining:
###Are keys unique?
###Are data types same?
###Are there missing keys?
###Expected join type?
###Row count expectation?

#join Syntax Sematics
#====================
?join
#inner_join(x,y,by = NULL,copy = FALSE,suffix = c(".x", ".y"),...,keep = NULL)
#S3 method for class 'data.frame'
#inner_join(x,y,by = NULL,copy = FALSE,suffix = c(".x", ".y"),...,keep = NULL,na_matches = c("na", "never"),multiple = "all",unmatched = "drop",relationship = NULL)
#x,y--> datasets

#.by
#---
##Works because both have carrier
inner_join(flights, airlines) 
##Risky if multiple common columns exist
##Explicit Key -Best practice
inner_join(flights, airlines, by = "carrier")
##Different Column Names
inner_join(flights, airports, 
           by = c("dest" = "faa"))
##Multiple Keys
##Used in real-world joins
inner_join(flights, weather,
           by = c("origin", "time_hour"))

#copy
#----
##Used when data is from different sources
inner_join(db_table, local_df, copy = TRUE)
##Copies y into database
##Mostly used with:
##Databases
##Spark

#suffix
#------
##Handles same column names in both tables
flights |> inner_join(weather,
           by = c("origin", "time_hour"),
           suffix = c("_flight", "_weather"))

#... (Extra Arguments)
#---------------------
#Used with modern join_by()
inner_join(flights, weather,
           by = join_by(origin, time_hour))

#keep
#----
#Keep both join key columns
inner_join(flights, airports,
           by = c("dest" = "faa"),
           keep = TRUE)
#Output contains:
##dest
##faa
#Normally one is dropped

#na_matches
#----------
##Default "na" --#NA matches NA
#Controls how NA values behave in joins
student <- tibble(id = c(1, 2, NA), name = c("Alice", "Bob", "Unknown"))
hobbies  <- tibble(id = c(1,NA), hobby = c("Coding","Sting"))
student |> left_join(hobbies,by="id") #which is default
student |> left_join(hobbies,by="id",na_matches="na") #NA matches which is default
student |> left_join(hobbies,by="id",na_matches="never") #NA never matches

#multiple= c("all","any","first","last","warning")
flights <- tibble(tailnum = "N123", destination = "BLR")
maint   <- tibble(tailnum = "N123", repair = c("Engine", "Tires", "Oil"))
flights |> left_join(maint, by = "tailnum")  
flights |> left_join(maint, by = "tailnum", multiple = "all") #default
flights |> left_join(maint, by = "tailnum", multiple = "any") #Only returns the first match it finds and ignores the rest
flights |> left_join(maint, by = "tailnum", multiple = "first")#Specifically picks the first or last occurrence
flights |> left_join(maint, by = "tailnum", multiple = "last")#Specifically picks the first or last occurrence
flights |> left_join(maint, by = "tailnum", multiple = "warning") #It returns all matches (like "all") but prints a warning in your console

#Real End-to-End Example
flights %>%
  filter(!is.na(tailnum)) %>%
  left_join(planes %>% distinct(tailnum, .keep_all = TRUE), by = "tailnum") %>%
  left_join(airlines, by = "carrier") %>%
  group_by(name, manufacturer) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_delay))

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

                                                        