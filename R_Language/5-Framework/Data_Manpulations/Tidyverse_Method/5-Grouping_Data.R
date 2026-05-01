#Intro
#Basic Grouping
#Summarising Groups
#Multiple Grouping Variables
#Key Concept: Grouping Structure
#.groups Argument in summarise()
#mutate() with Grouping
#filter() with Grouping
#arrange() with Groups
#slice() with Groups
#n() — Count Rows per Group
#across() with Grouping
#Group-wise Ranking
#cur_group() & cur_data()
#Advanced: group_map() / group_modify()
#.by Argument (Modern Alternative)
#Grouped Joins (Important Concept)
#Handling Missing Values in Groups
#group_keys() — Get Unique Group Combinations
#group_data() — Full Group Metadata
#group_rows() — Row Positions per Group
#group_indices() — Numeric Group ID
#nest_by() — Row-wise Grouping + Nested Data
#group_split() — Split into List of DataFrames
#group_walk() — Side Effects per Group
#group_trim() — Remove Empty Groups
#.drop = FALSE in group_by()
#Window Functions
#Rolling Calculations
#Conditional Group Operations
#Group-wise Custom Functions
#Nested Modeling per Group
#Multi-level Aggregation (Hierarchy)
#Dynamic Grouping (Programming)
#Grouped Case Logic
#Group-wise Distinct Values
#Combining group_by() + pivot (Advanced Reporting)
#Grouped Sampling
#Group-wise Top/Bottom Logic
#Memory Optimization
#Production-Level Pattern
#FINAL EXPERT MINDSET
#Real-World Pattern
#Common Mistakes
#Performance Tip
#Mental Model 
#End-to-End Real Example

#Intro
#=====
#What is Grouping in dplyr?
#“Split data into categories → Apply operations per group → Combine results”

library(dplyr)
library(nycflights13)

flights 

#Basic Grouping
#==============
#Group by one column
#This does not change output, but stores grouping metadata.
flights %>%
  group_by(month)
  
#Summarising Groups
#==================
#Most common use: summarise()
flights %>%
  group_by(month) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))
#1 row per group

#Multiple Grouping Variables
#===========================
flights %>%
  group_by(month, carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))
#Hierarchical grouping:
#First: month
#Then: carrier inside month

#Key Concept: Grouping Structure
#===============================
#Check grouping:
group_vars(flights %>% group_by(month, carrier))
#Remove grouping:
ungroup()

#.groups Argument in summarise()
#===============================
#Controls grouping after summarization:
flights %>%
  group_by(month, carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE),
            .groups = "drop")
#Options:
#"drop" → remove all grouping
#"drop_last" (default)
#"keep"

# Base grouping for all examples:
base_summary <- flights %>%
  group_by(origin, carrier, month)
base_summary
#1. .groups = "drop_last" (The Default)
#This drops the last level of grouping (month) but keeps the data grouped by origin and carrier.
base_summary %>%
  summarise(avg_dep = mean(dep_delay, na.rm = TRUE), .groups = "drop_last")
# Result: Grouped by [origin, carrier]
#2. .groups = "drop"
#This removes all grouping entirely. The result is a standard, ungrouped tibble. 
#This is highly recommended for the final step of a pipeline to avoid accidental grouped operations later.
base_summary %>%
  summarise(avg_dep = mean(dep_delay, na.rm = TRUE), .groups = "drop")
# Result: Ungrouped (plain tibble)
#3. .groups = "keep"
#This retains the exact same grouping structure you started with (origin, carrier, and month). 
#This is useful if you plan to perform more calculations within those same specific groups.
base_summary %>%
  summarise(avg_dep = mean(dep_delay, na.rm = TRUE), .groups = "keep")
# Result: Still grouped by [origin, carrier, month]
#4. .groups = "rowwise"
#This turns every single row of the resulting summary into its own group. 
#This is less common but useful if you intend to perform row-based operations (like sum() across columns) immediately after
base_summary %>%
  summarise(avg_dep = mean(dep_delay, na.rm = TRUE), .groups = "rowwise")
# Result: Each row is its own group

#summary
#Value->Effect on Grouping
#"drop_last"->Removes the last variable->Quick exploration (Default).
#"drop"->Removes all grouping->Finalizing a dataset for export or plotting.
#"keep"->Keeps all grouping->Further calculations on the same groups.
#"rowwise"->Each row becomes a group ->Subsequent row-by-row functions.

#if you find yourself constantly typing .groups = "drop", 
#you can set a global option at the start of your script to silence the message and define a default behavior:
options(dplyr.summarise.inform = FALSE)

#mutate() with Grouping
#=====================
#Works like window function
flights %>%
  group_by(month) %>%
  mutate(month_avg = mean(arr_delay, na.rm = TRUE))
#Adds group-level value to each row

#filter() with Grouping
#======================
#Keeps rows above group average
flights %>%
  group_by(month) %>%
  filter(arr_delay > mean(arr_delay, na.rm = TRUE))

#arrange() with Groups
#=====================
#Sorting happens within groups
flights %>%
  group_by(month) %>%
  arrange(desc(arr_delay))

#slice() with Groups
#===================
#Top N per group:
flights %>%
  group_by(carrier) %>%
  slice_max(arr_delay, n = 3)

#n() — Count Rows per Group
#==========================
flights %>%
  group_by(carrier) %>%
  summarise(count = n())

#across() with Grouping
#======================
flights %>%
  group_by(month) %>%
  summarise(across(c(arr_delay, dep_delay),
                   ~mean(.x, na.rm = TRUE)))
#Apply same function to multiple columns

#Group-wise Ranking
#==================
flights %>%
  group_by(carrier) %>%
  mutate(rank = min_rank(desc(arr_delay)))

#cur_group() & cur_data()
#======================== 
#cur_group()
#This returns a one-row tibble containing the values of the variables used for grouping. 
#It is essentially a way to see "Which group am I currently processing?"

# Identifying the group keys during a summary
flights %>%
  group_by(origin, month) %>%
  summarise(
    group_info = list(cur_group()),
    avg_delay = mean(dep_delay, na.rm = TRUE),
    .groups = "drop"
  )

#cur_data()
#This returns a tibble containing all the rows and columns for the current group excluding the grouping variables themselves. 
#This is powerful when you need to pass the entire "chunk" of data to a custom function or a model.

#Calculating Rank within Groups
#If you want to see the full data for each carrier at a specific airport:
flights %>%
  group_by(origin) %>%
  mutate(
    # Capturing the group's data to count total rows in that specific group
    total_group_rows = nrow(cur_data())
  ) %>%
  select(origin, total_group_rows, everything()) 

#cur_column()
#Dynamic Column Creation
#You can use cur_column() to create new column names or reference external lists that match your column names
flights %>%
  summarise(across(c(dep_delay, arr_delay), ~ {
    message("Currently processing column: ", cur_column())
    mean(.x, na.rm = TRUE)
  }))
#Useful for debugging & dynamic pipelines

#summary
#Function->Output->Context
#cur_column()->String (e.g., "dep_delay")->Inside across()
#cur_group()->Tibble (the group keys)->Inside group_by() operations
#cur_data()->Tibble (the group's data)->Inside group_by() operations

#Advanced: group_map() / group_modify()
#=======================================
#group_map()
#-------------
#Apply custom function per group
flights %>%
  group_by(carrier) %>%
  group_map(~ head(.x, 2))
  
#group_modify()
#-------------
#group_modify(), it helps to think of it as a "data frame in, data frame out" operation for each group.
#Unlike summarise(), which reduces a group down to a single row, group_modify() allows you to return any number of rows for each group, as long as the result is a data frame.

flights |>
  group_by(carrier) |>
  group_modify(~ {
    # .x represents the data for the current group
    .x |> 
      arrange(desc(arr_delay)) |> 
      slice_head(n = 3)
  }) |> select(carrier,arr_delay)
  
  
 #Simple example:
 students <- tibble(
  dept = c("CS", "CS", "CS", "Math", "Math"),
  name = c("A", "B", "C", "D", "E"),
  score = c(95, 80, 75, 40, 30)
)
#Give me the top student in each department.
students |> 
  group_by(dept) |> 
  slice_max(score, n = 1)

#If the top score in a department is less than 50, add a "Warning" row to that department's data. If it's 50 or more, just keep the data as is
#You cannot do this with a normal filter or slice because you are actually creating a new row that wasn't there before.
students |> 
  group_by(dept) |> 
  group_modify(~ {
    # Check the max score in the current group (.x)
    max_score <- max(.x$score)
    
    if (max_score < 50) {
      # If scores are low, add a new row to the data frame
      warning_row <- tibble(name = "SYSTEM", score = 0, status = "FAILING DEPT")
      return(bind_rows(.x, warning_row))
    } else {
      # Otherwise, just return the data as it is
      return(.x)
    }
  })

#.by Argument (Modern Alternative)
#=================================
#Instead of group_by():
#Cleaner & avoids explicit grouping state
flights %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE),
            .by = month)

#Grouped Joins (Important Concept)
#=================================
flights %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  left_join(airlines, by = "carrier")

#Handling Missing Values in Groups
#=================================
flights %>%
  group_by(month) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))
#Always use na.rm = TRUE

#group_keys() — Get Unique Group Combinations
#============================================
#Returns only distinct group identifiers
flights %>%
  group_by(month, carrier) %>%
  group_keys()

#the above is equivlent.
flights %>%
   distinct(month, carrier)

#group_data() — Full Group Metadata
#==================================
#While group_rows() gave you just the raw row numbers, group_data() gives you the "Manager's View" of your data frame.
#When you run that code, it returns a summary table (a tibble) that describes the groups themselves rather than the individual flights.

an<-flights %>%
  group_by(month) %>%
  group_data()

an$.rows
#Shows:
##Group values
##Row indices per group
##Useful for debugging internal grouping

#above is equivlent but now exactly.
flights %>%
  group_by(month) %>% 
  summarise(nrow = n())

#group_rows() — Row Positions per Group
#======================================
#Returns list of row indices per group
#The group_rows() function is a helper tool used to see where each group is located in your data frame.
#When you run that code, it doesn't return the flight data itself. Instead, it returns a list of integers. Each item in the list corresponds to a month (Group 1, Group 2, etc.), and the integers tell you the exact row numbers #where that month's data is stored

flights %>%
  group_by(month) %>%
  group_rows()

#group_indices() — Numeric Group ID
#==================================
#Assigns a unique group number
#When you group by both month and carrier, R looks for unique combinations. Each unique pair gets a number
flights %>%
  group_by(month, carrier) %>%
  group_indices()
  
#Since group_indices() only gives you the numbers, it's usually better to use the modern cur_group_id() so you can see the answer side-by-side  
flights |> 
   group_by(month,carrier) |> 
   mutate(group_id=cur_group_id()) |> 
  select(month,carrier,group_id)

#nest_by() — Row-wise Grouping + Nested Data
#===========================================
flights %>%
  nest_by(carrier)
#Creates:
##One row per group
##A list-column (data) containing subgroup

#group_split() — Split into List of DataFrames
#=============================================
flights %>%
  group_by(carrier) %>%
  group_split()
#Output: list of datasets per carrier
#Useful for:
##Parallel processing
##Model building

#group_walk() — Side Effects per Group
#======================================
flights %>%
  group_by(carrier) %>%
  group_walk(~ print(nrow(.x)))
#Used when:
##You do not return data
##Only perform actions (logging, saving files)

#group_trim() — Remove Empty Groups
#==================================
df %>%
  group_by(category, .drop = FALSE) %>%
  group_trim()
#Removes unused factor levels

#.drop = FALSE in group_by()
#===========================
flights %>%
  group_by(carrier, .drop = FALSE)
#Keeps all factor levels (even if no rows)
#Important in:
##Clinical data (SDTM)
##Reporting completeness

#Window Functions
#================
#Used inside mutate() with grouping:
flights %>%
  group_by(month) %>%
  mutate(
    lag_delay = lag(arr_delay),
    lead_delay = lead(arr_delay)
  )
#Other window functions:
#row_number()
#dense_rank()
#cumsum()
#cummean()

#Rolling Calculations
#====================
#Running statistics per group
flights %>%
  group_by(carrier) %>%
  mutate(running_avg = cummean(arr_delay))

#Conditional Group Operations
#============================
flights %>%
  group_by(month) %>%
  summarise(
    high_delay = sum(arr_delay > 60, na.rm = TRUE)
  )

#Group-wise Custom Functions
#===========================
my_func <- function(df) {
  summarise(df, avg = mean(arr_delay, na.rm = TRUE))
}

flights %>%
  group_by(carrier) %>%
  group_modify(~ my_func(.x))

#Nested Modeling per Group (REAL DATA SCIENCE)
#=============================================
#Build models per group
library(broom)

flights %>%
  group_by(carrier) %>%
  group_modify(~ {
    model <- lm(arr_delay ~ dep_delay, data = .x)
    broom::tidy(model)
  })

#Multi-level Aggregation (Hierarchy)
#===================================
flights %>%
  group_by(year, month, day) %>%
  summarise(daily_avg = mean(arr_delay, na.rm = TRUE)) %>%
  group_by(month) %>%
  summarise(month_avg = mean(daily_avg))

#Dynamic Grouping (Programming)
#==============================
group_var <- "month"

flights %>%
  group_by(.data[[group_var]]) %>%
  summarise(avg = mean(arr_delay, na.rm = TRUE))

#Grouped Case Logic
#==================
flights %>%
  group_by(month) %>%
  mutate(
    category = case_when(
      arr_delay > mean(arr_delay, na.rm = TRUE) ~ "Above Avg",
      TRUE ~ "Below Avg"
    )
  )

#Group-wise Distinct Values
#==========================
flights %>%
  group_by(carrier) %>%
  summarise(unique_dest = n_distinct(dest))

#Combining group_by() + pivot (Advanced Reporting)
#=================================================
library(tidyr)

flights %>%
  group_by(carrier, month) %>%
  summarise(avg = mean(arr_delay, na.rm = TRUE)) %>%
  pivot_wider(names_from = month, values_from = avg)

#Grouped Sampling
#================
flights %>%
  group_by(carrier) %>%
  slice_sample(n = 2)

#Group-wise Top/Bottom Logic
#===========================
flights %>%
  group_by(carrier) %>%
  filter(arr_delay == max(arr_delay, na.rm = TRUE))

#Memory Optimization
#===================
#Use .by instead of group_by() when possible
#Avoid unnecessary grouping
#Use select() before grouping

#Production-Level Pattern
#========================
process_data <- function(df) {
  df %>%
    group_by(...) %>%
    summarise(...) %>%
    ungroup()
}

#Always:
##Encapsulate logic
##Remove grouping state

#FINAL EXPERT MINDSET
#Think in 4 layers:
#rouping definition → group_by()
#Operation type
##collapse → summarise()
##retain → mutate()
#Control grouping
##.groups
##ungroup()
#Advanced workflows
##nesting
##modeling
##pipelines

#Real-World Pattern
#==================
#Pattern
data %>%
  group_by(...) %>%
  summarise(...) %>%
  ungroup()
#Prevents accidental grouped operations later

#Common Mistakes
#================
#Forgetting ungroup()
#Using summarise() but expecting row-level output
#Not handling NA values
#Over-grouping (too many columns)

#Performance Tip
#===============
#Grouping is expensive on large data
#Prefer .by when possible

#Mental Model (VERY IMPORTANT)
#=============================
#Verb->	Behavior with groups
#summarise->collapse groups
#mutate->keep rows
#filter->subset within group
#arrange->sort within group

#End-to-End Real Example
#=======================
flights %>%
  group_by(carrier, month) %>%
  summarise(
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    total_flights = n()
  ) %>%
  filter(total_flights > 100) %>%
  arrange(desc(avg_arr_delay)) %>%
  ungroup()


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

                                                        