#Intro
#Core Concept: mutate()
#Conditional Modifications
#Column-wise Operations
#Renaming Columns
#Reordering Columns
#Selecting While Modifying
#Replacing Values
#Type Conversion
#String Transformations
#Date-Time Modifications
#Ranking & Window Functions
#Group-wise Modifications
#Row-wise Modifications
#Conditional Column Creation with Logic
#Advanced Patterns
#Pipe + Modification Workflow
#.by inside mutate()
#pick() (Column selection inside mutate)
#reframe() vs mutate()
#mutate() with List Columns
#Row-level modeling
#nest() + mutate()
#row_number(), dense_rank(), percent_rank()
#Cumulative Functions
#ntile() (Bucketing)
#Advanced case_when() patterns
#Column Removal via NULL
#transmute() (Compact mutate)
#coalesce() across multiple columns
#Working with Factors
#lag() with ordering inside mutate
#slice_*() as modification helpers
#Window + Group Hybrid Logic
#Custom Functions inside mutate
#cur_group() / cur_column()
#Across with dynamic logic
#Performance Optimization Concepts
#Chained Feature Engineering Pipelines
#Modifying the function using custom function

#Intro
#=====
#This focuses on data modification (not filtering or joining) — i.e., creating, transforming, updating, and restructuring columns.


#Core Concept: mutate()
#======================
#Purpose:
# Add new columns
#Modify existing columns

#Create New Columns
flights %>%
  mutate(
    gain = arr_delay - dep_delay,
    speed = distance / air_time * 60
  )

#Modify Existing Columns
flights %>%
  mutate(dep_delay = dep_delay / 60)

#Multiple Transformations (Sequential Logic)
flights %>%
  mutate(
    gain = arr_delay - dep_delay,
    gain_per_hour = gain / air_time * 60
  )
#You can use newly created columns immediately

#Conditional Modifications
#=========================
#if_else() (Vectorized if)
flights %>%
  mutate(
    status = if_else(arr_delay > 0, "Delayed", "On Time")
  ) |> select(flight,arr_delay,status)

#case_when() (Multiple Conditions)
flights %>%
  mutate(
    delay_category = case_when(
      arr_delay <= 0 ~ "On Time",
      arr_delay <= 60 ~ "Minor Delay",
      arr_delay <= 180 ~ "Moderate Delay",
      TRUE ~ "Severe Delay"
    )
  )
#Best for complex business logic

#Column-wise Operations
#======================
#across() (Modern approach)
flights %>%
  mutate(across(c(dep_delay, arr_delay), ~ . / 60))

#Apply Multiple Functions
flights %>%
  mutate(across(
    c(dep_delay, arr_delay),
    list(
      sqrt = sqrt,
      log = log1p
    )
  ))
#Creates multiple derived columns

#Renaming Columns
#================
#rename()
flights %>%
  rename(departure_delay = dep_delay)

#Rename with across()
flights %>% 
  rename_with(~ paste0("departure_", .), starts_with("dep"))

#Reordering Columns
#==================
#relocate()
flights %>%
  relocate(arr_delay, dep_delay)

#Relative Position
flights %>%
  relocate(arr_delay, .after = dep_time)

#Selecting While Modifying
#=========================
#.keep argument in mutate()
flights %>%
  mutate(
    gain = arr_delay - dep_delay,
    .keep = "used"
  )
#Options:
#"all" (default)
#"used"
#"unused"
#"none"

#Replacing Values
#================
#Replace NA
flights %>%
  mutate(dep_delay = coalesce(dep_delay, 0))

#Replace Specific Values
flights %>%
  mutate(carrier = recode(carrier,
    "UA" = "United",
    "AA" = "American"
  ))

#Type Conversion
#===============
#Convert Data Types
flights %>%
  mutate(
    carrier = as.factor(carrier),
    flight = as.character(flight)
  )

#Bulk Type Conversion
flights %>%
  mutate(across(where(is.numeric), as.double))

#String Transformations
#=======================
#stringr

flights %>%
  mutate(
    carrier = str_to_upper(carrier)
  )

#Date-Time Modifications
#=======================
#(using lubridate)
library(lubridate)

flights %>%
  mutate(
    flight_date = make_date(year, month, day),
    dep_hour = hour(time_hour)
  )

#Ranking & Window Functions
#==========================
#Ranking
flights %>%
  mutate(rank_delay = min_rank(desc(arr_delay)))

#Lag / Lead
flights %>%
  arrange(time_hour) %>%
  mutate(
    prev_delay = lag(arr_delay),
    next_delay = lead(arr_delay)
  )

#Group-wise Modifications
#=======================
#group_by() + mutate()
#Adds group-level metrics to each row
flights %>%
  group_by(carrier) %>%
  mutate(avg_delay = mean(arr_delay, na.rm = TRUE))

#Standardization (Z-score)
flights %>%
  group_by(carrier) %>%
  mutate(
    z_delay = (arr_delay - mean(arr_delay, na.rm = TRUE)) /
              sd(arr_delay, na.rm = TRUE)
  )

#Row-wise Modifications
#======================
#rowwise()
flights %>%
  rowwise() %>%
  mutate(total_delay = sum(c(dep_delay, arr_delay), na.rm = TRUE))

#simple example
df <- tibble(
  student = c("Alex", "Blair"),
  q1 = c(80, 92),
  q2 = c(95, 70),
  q3 = c(88, 85)
)
df

# Using rowwise to calculate the max for each student
df %>%
  rowwise() %>%
  mutate(top_score = max(c(q1, q2, q3))) %>%
  ungroup() 

#Conditional Column Creation with Logic
#=====================================
flights %>%
  mutate(
    risk_flag = case_when(
      arr_delay > 120 & distance > 1000 ~ "High Risk",
      arr_delay > 60 ~ "Medium Risk",
      TRUE ~ "Low Risk"
    )
  )

#Advanced Patterns
#=================
#Dynamic Column Names
col_name <- "new_delay"

flights %>%
  mutate(!!col_name := arr_delay * 2)

#Using cur_data()
flights %>%
  rowwise() %>%
  mutate(avg = mean(c_across(dep_delay:arr_delay), na.rm = TRUE))

#Pipe + Modification Workflow (Real Pipeline)
#============================================
flights %>%
  mutate(
    gain = arr_delay - dep_delay,
    speed = distance / air_time * 60
  ) %>%
  group_by(carrier) %>%
  mutate(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    delay_flag = arr_delay > avg_delay
  ) %>%
  ungroup() %>%
  relocate(gain, speed, .after = distance)

#Common Mistakes
#---------------
#Using mutate() instead of summarise()
flights %>% mutate(mean_delay = mean(arr_delay)) |> select(flight,mean_delay)
#Forgetting na.rm = TRUE
mean(arr_delay)  # may return NA
#Overwriting important columns accidentally
mutate(arr_delay = arr_delay * 2)  # destructive

#Summary
#ask->Function#Add column->	mutate()
#Modify column->	mutate()
#Conditional logic->	if_else(), case_when()
#Multi-column ops->	across()
#Rename->	rename()
#Reorder->	relocate()
#Replace values->	coalesce(), recode()
#Group-based changes->	group_by() + mutate()

#.by inside mutate()
#===================
#Alternative to group_by() without changing grouping state
flights %>%
  mutate(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    .by = carrier
  )
#No need to ungroup()

#cleaner than:
group_by(carrier) %>% mutate(...)

#pick() (Column selection inside mutate)
#=======================================
flights %>%
  mutate(
    avg_delay = rowMeans(pick(dep_delay, arr_delay), na.rm = TRUE)
  )
#Cleaner than c_across()

#reframe() vs mutate()
#=====================
#mutate()-> keeps same rows
#reframe() -> can return multiple rows per group

flights %>%
  reframe(
    top_delay = head(sort(arr_delay, decreasing = TRUE), 3),
    .by = carrier
  )

#mutate() with List Columns
#==========================
#Used in ML, nested data, APIs
flights %>%
  group_by(carrier) %>%
  mutate(
    delay_list = list(arr_delay)
  )
#Each row contains a list

#Row-level modeling
flights %>%
  group_by(carrier) %>%
  summarise(
    model = list(lm(arr_delay ~ distance))
  )

#nest() + mutate()
#=================
library(tidyr)

flights %>%
  group_by(carrier) %>%
  nest() %>%
  mutate(
    avg_delay = map_dbl(data, ~ mean(.x$arr_delay, na.rm = TRUE))
  )

#row_number(), dense_rank(), percent_rank()
#==========================================
flights %>%
  mutate(
    rank = row_number(arr_delay),
    d_rank = dense_rank(arr_delay),
    p_rank = percent_rank(arr_delay)
  ) |> select(rank,d_rank,p_rank)

#Cumulative Functions
#====================
flights %>%
  arrange(time_hour) %>%
  mutate(
    cum_delay = cumsum(arr_delay),
    cum_avg = cummean(arr_delay)
  )

#ntile() (Bucketing)
#===================
flights %>%
  mutate(
    delay_bucket = ntile(arr_delay, 4)
  )
#Quartiles / segmentation

#Advanced case_when() patterns
#=============================
#Handling NA explicitly
flights %>%
  mutate(
    category = case_when(
      is.na(arr_delay) ~ "Missing",
      arr_delay < 0 ~ "Early",
      TRUE ~ "Late"
    )
  )

#Column Removal via NULL
#=======================
flights %>%
  mutate(gain = arr_delay - dep_delay,
         gain = NULL)
#Deletes column

#transmute() (Compact mutate)
#============================
flights %>%
  transmute(
    gain = arr_delay - dep_delay
  )
#Keeps only new columns

#coalesce() across multiple columns
#=================================
flights %>%
  mutate(
    delay = coalesce(arr_delay, dep_delay, 0)
  )
#First non-NA value

#Working with Factors
#====================
flights %>%
  mutate(
    carrier = factor(carrier),
    carrier = forcats::fct_reorder(carrier, arr_delay, mean)
  )

#lag() with ordering inside mutate
#================================
flights %>%
  mutate(
    prev_delay = lag(arr_delay, order_by = time_hour)
  )
#No need for arrange()

#slice_*() as modification helpers
#=================================
#Not exactly mutate, but used in pipelines:
flights %>%
  group_by(carrier) %>%
  slice_max(arr_delay, n = 3)

#Window + Group Hybrid Logic
#===========================
flights %>%
  group_by(carrier) %>%
  mutate(
    is_top_delay = arr_delay == max(arr_delay, na.rm = TRUE)
  )

#Custom Functions inside mutate
#===============================
normalize <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

flights %>%
  mutate(norm_delay = normalize(arr_delay))

#cur_group() / cur_column()
#==========================
flights %>%
  group_by(carrier) %>%
  mutate(group_name = cur_group()$carrier)

#Across with dynamic logic
#=========================
flights %>%
  mutate(
    across(where(is.numeric),
           ~ ifelse(is.na(.), 0, .))
  )

#Performance Optimization Concepts
#=================================
#Important in real-world big data
#Prefer .by over group_by()
#Avoid rowwise() unless necessary
#Use vectorized operations instead of loops

#Chained Feature Engineering Pipelines
#=====================================
flights %>%
  mutate(
    gain = arr_delay - dep_delay
  ) %>%
  mutate(
    efficiency = gain / distance
  ) %>%
  mutate(
    category = if_else(efficiency > 0, "Good", "Bad")
  )
  
#Modifying the function using custom function
#=============================================
 library(tidyverse)
library(nycflights13)

#Custom Functions + mutate()
#-------------------------
##Delay Category Function
delay_category <- function(delay) {
  case_when(
    is.na(delay) ~ "unknown",
    delay <= 0 ~ "on_time",
    delay <= 30 ~ "minor_delay",
    TRUE ~ "major_delay"
  )
}

flights %>%
  mutate(dep_status = delay_category(dep_delay),.keep="used")
#Concept covered:
#Vectorized functions
#NA handling
#Reusable logic

#Functions with Multiple Inputs
#-------------------------
##Speed Calculation
calc_speed <- function(distance, air_time) {
  (distance / air_time) * 60
}

flights %>%
  mutate(speed = calc_speed(distance, air_time),.keep="used")
#Used when:
#Column interaction needed
#Feature engineering

#Functions Inside across() (Bulk Column Operations)
#-------------------------
##Normalize Numeric Columns
normalize <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

flights %>%
  mutate(across(c(dep_delay, arr_delay), normalize),.keep="used")
#Concept:
#Apply function across multiple columns
#Clean reusable transformation

#Custom Functions in select()
#-------------------------
#Select Columns by Missing % Rule
high_na <- function(x) {
  mean(is.na(x)) < 0.1
}

flights %>%
  select(where(high_na))
#Concept:
#Logical predicate functions
#Used with where()

#Custom Functions in filter()
#-------------------------
#Filter Flights with Extreme Delay
is_extreme_delay <- function(delay) {
  delay > 120
}

flights %>%
  filter(is_extreme_delay(dep_delay))
#Concept:
#Boolean-return functions
#Cleaner filtering logic

#Custom Functions with group_by() + summarise()
#-----------------------------------------------
#Custom Summary Function
delay_summary <- function(x) {
  tibble(
    avg = mean(x, na.rm = TRUE),
    med = median(x, na.rm = TRUE),
    max = max(x, na.rm = TRUE)
  )
}

flights %>%
  group_by(carrier) %>%
  summarise(delay_summary(arr_delay))

#Concept:
#Returning multiple values
#Used inside summarise

#Functions Returning Single Value 
#-------------------------
#Safe Mean
safe_mean <- function(x) {
  if (all(is.na(x))) return(NA)
  mean(x, na.rm = TRUE)
}

flights %>%
  group_by(carrier) %>%
  summarise(avg_delay = safe_mean(arr_delay))
#Real-world use:
#Avoid errors in production pipelines

#Functions with Parameters
#-------------------------
#Flexible Delay Flag
delay_flag <- function(delay, threshold = 30) {
  delay > threshold
}
flights %>%
  mutate(late = delay_flag(arr_delay, 45),.keep="used")

#Concept:
#Parameterized reusable logic

#Using Functions in case_when()
#------------------------------
is_weekend <- function(day) {
  day %in% c(6, 7)
}

flights %>%
  mutate(weekend_flag = case_when(
    is_weekend(day) ~ "weekend",
    TRUE ~ "weekday"
  ),.keep="used")

#Anonymous Functions (Quick Usage)
#---------------------------------
flights %>%
  mutate(across(dep_delay:arr_delay, ~ .x / 60))

#Equivalent to:
function(x) x / 60

#Use when:
#One-time transformation
#No reuse needed

#Functions with cur_data() / cur_group() (Advanced)
#---------------------------------------
#Group-wise Standardization
group_normalize <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

flights %>%
  group_by(carrier) %>%
  mutate(norm_delay = group_normalize(arr_delay),.keep="used")
#Concept:
#Context-aware transformations

#Using Functions in arrange()
#----------------------------
delay_score <- function(dep, arr) {
  dep + arr
}

flights %>%
  arrange(delay_score(dep_delay, arr_delay)) |> select(dep_delay,arr_delay)

#Returning Data Frames from Functions
#------------------------------------
#Top N Flights per Group
top_n_delay <- function(df, n = 3) {
  df %>%
    arrange(desc(arr_delay)) %>%
    slice_head(n = n)
}

flights %>%
  group_by(carrier) %>%
  group_modify(~ top_n_delay(.x, 2))

#Concept:
#Data-frame-in, data-frame-out functions

#Programming with {{}} (Tidy Evaluation)
#-------------------------
#Dynamic Column Function
mean_by_group <- function(data, group_col, value_col) {
  data %>%
    group_by({{ group_col }}) %>%
    summarise(avg = mean({{ value_col }}, na.rm = TRUE))
}

mean_by_group(flights, carrier, arr_delay)
#Concept:
#Non-standard evaluation
#Writing reusable dplyr functions

#function + Using ... (Flexible Arguments)
#------------------------------------
multi_mean <- function(data, ...) {
  data %>%
    summarise(across(c(...), ~ mean(.x, na.rm = TRUE)))
}

multi_mean(flights, dep_delay, arr_delay)

#Combining Multiple Custom Functions
#------------------------------------
clean_delay <- function(x) {
  ifelse(is.na(x), 0, x)
}

categorize_delay <- function(x) {
  ifelse(x > 60, "high", "low")
}

flights %>%
  mutate(
    dep_delay = clean_delay(dep_delay),
    delay_type = categorize_delay(dep_delay),
    .keep="used"
  )

#Best Practices
#--------------
#DO:
##Keep functions pure (no side effects)
##Handle NA safely
##Keep them vectorized
##Use meaningful names
#AVOID:
##Hardcoding column names inside functions
##Non-vectorized loops
##Ignoring NA cases

#Real Pipeline Example
#----------------------
delay_pipeline <- function(data, threshold = 30) {
  data %>%
    mutate(
      speed = calc_speed(distance, air_time),
      delay_flag = delay_flag(arr_delay, threshold)
    ) %>%
    group_by(carrier) %>%
    summarise(
      avg_delay = safe_mean(arr_delay),
      avg_speed = safe_mean(speed)
    )
}

delay_pipeline(flights, 45)

#key_takeway
#-----------
#Custom functions in:
#mutate, filter, select, arrange
##group_by + summarise
##across() + bulk operations
#Tidy evaluation ({{}}, ...)
#Data-frame-returning functions
#Production-safe function design
  
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

                                                        