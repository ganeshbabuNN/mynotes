#Intro
#Wide -> Long (pivot_longer)
#Long -> Wide (pivot_wider)
#Separate Columns
#Unite Columns
#Extract Patterns
#Complete Missing Combinations
#Fill Missing Values
#Replace Missing Values
#Nesting and Unnesting
#Pattern-Based Reshaping
#Multi-Value Columns (.value)
#Handling Duplicate Rows (values_fn)
#Custom Column Naming (names_glue)
#Explicit Identifiers (id_cols)
#Filling Missing Values (values_fill)
#Complete Missing Combinations (complete)
#Expand vs Complete
#Nested Reshaping
#Cross Expansion (Full Grid)
#Time-Series Reshaping
#Feature Engineering
#Route Creation (Unite + Reshape)
#Round-Trip Validation
#Complex Real Pipeline
#Key Takeaways

#Intro
#-----
#What is Data Reshaping?
#Reshaping = changing the structure of data without changing its meaning.

#Two main types:
#Type	Description
#Wide -> Long	Columns become rows
#Long -> Wide	Rows become columns

#Wide -> Long (pivot_longer)
#===========================
#Basic Concept
##Convert multiple columns into key-value pairs.

flights %>%
  select(flight, dep_delay, arr_delay) %>%
  pivot_longer(
    cols = c(dep_delay, arr_delay),
    names_to = "delay_type",
    values_to = "delay"
  )

#Key Parameters
#Argument->	Meaning
#cols->	Columns to reshape
#names_to->	New column for column names
#values_to->New column for values

#Advanced: Multiple Columns Pattern
#----------------------------------
flights %>%
  select(flight, dep_delay, arr_delay) %>%
  pivot_longer(
    cols = ends_with("delay"),
    names_to = "type",
    values_to = "value"
  )

#Split Names into Multiple Columns
#---------------------------------
flights %>%
  select(flight, dep_time, arr_time) %>%
  pivot_longer(
    cols = c(dep_time, arr_time),
    names_to = c("event", "type"),
    names_sep = "_"
  )

#Remove NA Values
#----------------
pivot_longer(..., values_drop_na = TRUE)

flights %>%
  select(flight, dep_time, arr_time) %>%
  pivot_longer(
    cols = c(dep_time, arr_time),
    names_to = c("event", "type"),
    names_sep = "_",
    , values_drop_na = TRUE
  )

#Long -> Wide (pivot_wider)
#==========================
#Convert rows into columns.

flights %>%
  select(flight, carrier, dep_delay) %>%
  pivot_wider(
    names_from = carrier,
    values_from = dep_delay
  )

#Key Parameters
#Argument-->	Meaning
#names_from-->	Column to create new columns
#values_from-->	Values to fill

#Handling Duplicates (Important!)
#--------------------
flights %>%
  group_by(flight, carrier) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(
    names_from = carrier,
    values_from = delay
  )

#Fill Missing Values
#--------------------
pivot_wider(..., values_fill = 0)

#Separate Columns
#================
#Split one column into multiple.
flights %>%
  select(tailnum) %>%
  separate(
    tailnum,
    into = c("prefix", "number"),
    sep = 1
  )

#Unite Columns
#=============
#Combine multiple columns.
flights %>%
  unite("route", origin, dest, sep = "-")

#Extract Patterns
#=================
#Extract using regex.
flights %>%
  mutate(code = "AA123") %>%
  extract(
    code,
    into = c("carrier", "number"),
    regex = "([A-Z]+)([0-9]+)"
  )

#Complete Missing Combinations
#=============================
df <- tibble(
  name=c("A","AI","Beth"),
  day=c(1,3,2),
  apples=c(2,5,3)
)

df
df |> 
  complete(name,day=1:3)


colSums(is.na(flights))
flights %>%
  count(carrier, month) %>%
  complete(carrier, month)
#Fills missing combinations with NA.

#Fill Missing Values
#===================
df <- tibble(
  name=c("A","AI",NA,"B",NA,"C","D",NA,NA)
)
df |> 
  arrange(name) |> 
  fill(name,.direction = "down")

#if we do not arrange
df |> 
  fill(name,.direction = "down")

#Replace Missing Values
#======================
flights %>%
  mutate(dep_delay = replace_na(dep_delay, 0))

#Nesting and Unnesting (Advanced)
#================================
#Nest
nested <- flights %>%
  group_by(carrier) %>%
  nest()
nested

#Unnest
nested %>%
  unnest(cols = data)

#When to Use What?
#Situation	Function
#Columns->Rows	pivot_longer()
#Rows->Columns  -->	pivot_wider()
#Split column ->	separate()
#Combine column->	unite()
#Regex extract->	extract()
#Fill gaps->	complete()
#Fill NA->fill()

#Pattern-Based Reshaping (names_pattern)
#=====================================
#Split delay type automatically
flights %>%
  select(flight, dep_delay, arr_delay) %>%
  pivot_longer(
    cols = -flight,
    names_to = c("type", "metric"),
    names_pattern = "(dep|arr)_(delay)"
  )
#Useful when column names follow patterns
#Works better than names_sep in messy data
  
#When column names are complex.
df <- tibble(
  flight = 1:2,
  dep_delay_mean = c(10, 20),
  dep_delay_sd   = c(2, 3)
)
df

#Reshape using regex:
#Splits column names using regex groups.
df %>%
  pivot_longer(
    cols = -flight,
    names_to = c("metric", "stat"),
    names_pattern = "(.*)_(.*)"
  )

#Multi-Value Columns (.value)
#===========================
#Keep dep & arr as rows, but preserve delay/time separately
flights %>%
  select(flight, dep_delay, arr_delay, dep_time, arr_time) %>%
  pivot_longer(
    cols = -flight,
    names_to = c("type", ".value"),
    names_sep = "_"
  )
  
#This is very important in real pipelines
#Avoids multiple pivots

#Handling Duplicate Rows (values_fn)
#===================================
#Same carrier appears multiple times
flights %>%
  select(carrier, month, dep_delay) %>%
  pivot_wider(
    names_from = month,
    values_from = dep_delay,
    values_fn = mean
  )
#Automatically aggregates duplicates
#Avoids manual group_by + summarise

#Custom Column Naming (names_glue)
#=================================
flights %>%
  count(carrier, month) %>%
  pivot_wider(
    names_from = month,
    values_from = n,
    names_glue = "month_{month}_flights"
  )

#Explicit Identifiers (id_cols)
#===============================
flights %>%
  select(flight, carrier, dep_delay) %>%
  pivot_wider(
    id_cols = flight,
    names_from = carrier,
    values_from = dep_delay
  )
#Prevents unintended grouping
#Important in production

#Filling Missing Values (values_fill)
#====================================
flights %>%
  count(carrier, month) %>%
  pivot_wider(
    names_from = month,
    values_from = n,
    values_fill = 0
  )
#Creates complete matrix
#Very useful in ML features

#Complete Missing Combinations (complete)
#=========================================
#Ensure all carrier-month combinations exist
flights %>%
  count(carrier, month) %>%
  complete(carrier, month, fill = list(n = 0))

#Expand vs Complete
#==================
# Only combinations (no data)
expand(flights, carrier, month)

# Add missing rows with NA
complete(flights, carrier, month)

#Nested Reshaping
#================
#Group -> reshape inside groups
flights %>%
  group_by(carrier) %>%
  summarise(data = list(cur_data())) %>%
  mutate(
    reshaped = lapply(data, function(df) {
      df %>%
        select(dep_delay, arr_delay) %>%
        pivot_longer(everything())
    })
  )
#Used in advanced analytics / modeling

#Cross Expansion (Full Grid)
#===========================
#Ensures full matrix even if data missing
flights %>%
  count(carrier) %>%
  tidyr::crossing(month = 1:12)

#Time-Series Reshaping
#=====================
#Daily delay matrix
flights %>%
  group_by(month, day) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(
    names_from = day,
    values_from = delay
  )
#Used in heatmaps / forecasting

#Feature Engineering (ML Style)
#===================
flights %>%
  mutate(delay_flag = dep_delay > 15) %>%
  count(carrier, delay_flag) %>%
  pivot_wider(
    names_from = delay_flag,
    values_from = n,
    values_fill = 0
  )
#Converts categorical -> numeric features

#Route Creation (Unite + Reshape)
#================================
flights %>%
  unite("route", origin, dest, sep = "-") %>%
  count(route, carrier) %>%
  pivot_wider(names_from = carrier, values_from = n)

#Round-Trip Validation
#=====================
long <- flights %>%
  select(dep_delay, arr_delay) %>%
  pivot_longer(everything())

wide <- long %>%
  pivot_wider(names_from = name, values_from = value)
#Ensures transformation correctness

#Complex Real Pipeline
#=====================
#Compare delay types per carrier in matrix form
flights %>%
  select(carrier, dep_delay, arr_delay) %>%
  pivot_longer(
    cols = c(dep_delay, arr_delay),
    names_to = "delay_type",
    values_to = "delay"
  ) %>%
  group_by(carrier, delay_type) %>%
  summarise(avg_delay = mean(delay, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(
    names_from = delay_type,
    values_from = avg_delay
  )

#Key Takeaways
#-------------
#Reshaping in real-world 

#Structure change-> long ->wide
# Name parsing ->names_sep, names_pattern
#Duplicate handling->values_fn
#Missing data control-> complete, values_fill
#Feature engineering ->reshape → model-ready data

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

                                                        