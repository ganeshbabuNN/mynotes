# Intro
# Numeric Data Type
# Number systems
# Built in functions
# Quiz
# Assignment
# Resources

# Intro
# =====
# Number data types store numeric values. They are immutable data types, means that changing the value of a number data type results in a newly allocated object

# Number objects are created when you assign a value to them. For example −
x <- 32 
.Internal(inspect(x))
y <- 33
.Internal(inspect(y))
y <- 32
.Internal(inspect(y)) #get the memory address which different.

# You can also delete the reference to a number object by using the rm function. The syntax of the del statement is −
a<-3
b<-'ga'
rm(a,b)
print(a)
print(b)

# The following would be a good recap
#------------------------------------

#Numeric Data Types Overview in R ===========
#Def:Numbers in R are primarily stored as double-precision numeric values by default.
#purpose : To represent quantities, measurements, and calculations.
x <- 5.5
typeof(x)
#Real-World Example
##Storing daily temperature readings.
#Common Mistakes
##Assuming integers and numerics are the same internally
#Best Practices
##Always verify type using typeof() when precision matters
#When to Use / Not Use
##Use numeric for calculations
##Do not use numeric for identifiers like phone numbers

#Integer vs Double (Numeric)  ===========
#def:integer: whole numbers ,double: decimal numbers (default)
#purpose : Control precision and memory usage.
x <- 10L
typeof(x)
y <- 10
typeof(y)
#Real-World Example
##Integer: number of employees
##Double: salary values
#Common Mistakes
##Forgetting L for integers
#Use integers for counts
#Use doubles for measurements
#When to Use / Not Use
##Avoid integers when decimals are expected

#Creating Numeric Values  ===========
#def: Numeric values can be created directly or through calculations.
#purpose: Input numeric data into R.
x <- 100 / 4
x
#Real-World Example
##Calculating average sales.
#Common Mistakes
##Using commas in numbers (1,000 is invalid)
#Best Practices
##Use clear numeric literals
#When to Use / Not Use
##Use when numeric computation is required

#Arithmetic Operators on Numbers  ===========
#Def: Operators like + - * / ^ %%.
#Purpose: Perform mathematical calculations.
a + b
10 %% 3
#Real-World Example
##Calculating tax percentages.
#Common Mistakes
##Confusing %/% with /
#Best Practices
##Use parentheses for clarity
#When to Use / Not Use
##Avoid mixing numeric and character types

#Numeric Coercion and Type Conversion  ===========
#Definition :Automatic or explicit conversion between types.
#Purpose:Ensure compatibility in operations.
as.numeric(x) #syntax
as.numeric("100")
#Real-World Example
##Reading numeric columns from CSV files.
#Common Mistakes
##Silent NA creation during coercion
#Best Practices
##Check warnings after conversion
##When to Use / Not Use
##Do not coerce without validation


#Special Numeric Values =========
#Definition:NA: missing ,NaN: invalid computation,Inf: infinity
#Purpose:Represent undefined or extreme numeric states
0 / 0
1 / 0
#Real-World Example
##Division by zero in financial ratios.
#Common Mistakes
##Treating NaN as NA
#Best Practices
##Use is.na(), is.nan(), is.infinite()
#When to Use / Not Use
##Use explicitly for error handling

#Checking Numeric Types
#Definition:Functions to validate numeric data.
#Purpose :Data validation and robustness.
is.numeric(x)
is.integer(10L)
#Real-World Example
##Validating user input in analytics pipelines.
#Common Mistakes
##Assuming is.numeric() implies integer
#Best Practices
##Combine multiple checks

#Numeric Precision and Floating-Point Representation
#Definition: R uses floating-point arithmetic.
#Purpose :Understand rounding errors.
0.1 + 0.2
#Real-World Example
##Financial calculations showing tiny discrepancies.
#Common Mistakes
##Direct equality checks
#Best Practices
##Use tolerance comparisons

#Vectorized Numeric Operations
#Definition:Operations applied element-wise.
#Example
c(1,2,3) * 2
#Real-World Example
#Applying discounts across products.
#Best Practices
#Prefer vectorization over loops

#Handling Missing Numeric Values
#Definition: Managing NA values.
#Example
sum(c(1,2,NA,45),na.rm = TRUE) #to exculde NA
sum(c(1,2,NA,45,NaN),na.rm = TRUE) #to exculde NA,NaN
sum(c(1,2,NA,45,NaN,NULL),na.rm = TRUE) #to exculde NA,NaN,NULL but it escape
sum(c(1,2,NA,45,NaN,NULL,Inf),na.rm = TRUE) #to exculde NA,NaN,NULL but it escape
a<-c(1,2,NA,45,NaN,NULL,Inf)
sum(a[is.finite(a)],na.rm = TRUE)# for exuclde the Inf
is.finite(a)
is.nan(a)
is.na(a)

#Real-World Example
##Incomplete survey responses.

#Numeric Comparison and Tolerance
#Definition -Avoid strict equality for floats.
#Example
all.equal(0.1 + 0.2, 0.3)

#Integer Overflow and Limits
##Integers have finite bounds.
.Machine$integer.max

#Numeric Attributes
##Metadata attached to numeric objects.
attr(x, "units") <- "kg"
x

#Large Numbers and Scientific Notation
#Use case : Scientific and financial modeling.
1e6

#Number System
#==============
#1)Base 10(Decimal)- Represent any number using 10 digits [0–9]
#2)Base 2 (Binary) — Represent any number using 2 digits [0–1]
#3)Base 8 (Octal) — Represent any number using 8 digits [0–7]
#4)Base 16(Hexadecimal) — Represent any number using 10 digits and 6 characters [0–9, A, B, C, D, E, F]
 
# Character → All Formats (including HTML)
c <- "Sarang"
dec <- utf8ToInt(c) 
cat("Decimal:", dec, "\n")
cat("Char   :", c, "\n")
bin <- paste(rev(as.integer(intToBits(dec))[1:8]), collapse="")
cat("Binary :", bin, "\n")
cat("Hex    :", format(as.hexmode(dec)), "\n")
cat("Oct    :", format(as.octmode(dec)), "\n")
cat("HTML   :", paste0("&#", dec, ";"), "\n")

#Binary → All Formats (including HTML)
b <- "01000001"
dec <- strtoi(b, base = 2)
cat("Binary :", b, "\n")
cat("Decimal:", dec, "\n")
cat("Char   :", intToUtf8(dec), "\n")
bin <- paste(rev(as.integer(intToBits(dec))[1:8]), collapse="")
cat("Binary :", bin, "\n")
cat("Hex    :", format(as.hexmode(dec)), "\n")
cat("Oct    :", format(as.octmode(dec)), "\n")
cat("HTML   :", paste0("&#", dec, ";"), "\n")

#Octal → All Formats (including HTML)
o <- "101"
dec <- strtoi(o, base = 8)
cat("Decimal:", dec, "\n")
cat("Char   :", intToUtf8(dec), "\n")
bin <- paste(rev(as.integer(intToBits(dec))[1:8]), collapse="")
cat("Binary :", bin, "\n")
cat("Oct    :", format(as.octmode(dec)), "\n")
cat("Hex    :", format(as.hexmode(dec)), "\n")
cat("HTML   :", paste0("&#", dec, ";"), "\n")

#Unicode → All Formats (including HTML)
u <- "0CA8"   # Kannada "ನ"=0CA8
dec <- strtoi(u, base = 16)
cat("Decimal:", dec, "\n")
cat("Char   :", intToUtf8(dec), "\n")
bin <- paste(rev(as.integer(intToBits(dec))[1:16]), collapse="")
cat("Binary :", bin, "\n")
cat("Hex    :", format(as.hexmode(dec)), "\n")
cat("Oct    :", format(as.octmode(dec)), "\n")
cat("HTML   :", paste0("&#", dec, ";"), "\n")

#Decimal → All Formats (including HTML)
dec <- 65 #2308= ऄ
cat("Decimal:", dec, "\n")
cat("Char   :", intToUtf8(dec), "\n")
bin <- paste(rev(as.integer(intToBits(dec))[1:8]), collapse="")
cat("Binary :", bin, "\n")
cat("Oct    :", format(as.octmode(dec)), "\n")
cat("Hex    :",format(as.hexmode(dec)), "\n")
cat("HTML   :", paste0("&#", dec, ";"), "\n")
#ref https://www.w3schools.com/charsets/ref_utf_hindi.asp
  
#Ref
#https://www.quora.com/What-is-the-use-of-number-system-in-computer
#https://www.tutorialspoint.com/computer_logical_organization/number_system_conversion.htm
 
#Know ASCII , unicode and Numbers systems
#----------------------------------------
#All computer data is just numbers,Each character of text is stored as a number.When you press a key on the keyboard, the keyboard sends a number, corresponding to the key that was pressed,When text is displayed on your monitor, each character is read from memory as a number.Computer doesn't understand English or Hindi or any language.But computer do understand only 0 and 1.
#-0 means False ,1 means True
#-ASCII codes represent text in computers, communications equipment, and other devices that use text
#-UNicod is the subset of ASCII and extended upto 2^21 characters

test<-utf8ToInt("Apples")
test
 
tes1=intToUtf8(test)
tes1

#Refer ASCII_Tables.jpg
 
#ref:
#http://www.asciitable.com/ - ASCII table
#http://www.differencebetween.net/technology/software-technology/difference-between-unicode-and-ascii/ - Def
#https://youtu.be/61Bs7-ycL64
#https://byjus.com/maths/number-system/
#https://byjus.com/maths/hexadecimal-number-system/

# Built in functions
# ==================
#Basic Mathematical Functions (*IMP*)
#---------------------------
abs(-10) #abs() – Absolute Value -Returns the positive value of a number.
sqrt(25) #sqrt() – Square Root
2^3 #^ or pow() – Power

#log(), log10(), log2() – Logarithms
log(10)        # Natural log
log10(100)     # Base-10 log → 2
log2(8)        # Base-2 log → 3

exp(1)         # e^1 #exp() – Exponential
factorial(5) #factorial() – Factorial
choose(5, 2) #choose(n, k) – Combinations (nCk)
prod(c(2, 3, 4)) #prod() – Product of Elements

#Rounding & Precision Control (*IMP*)
--------------------------------------------
round(3.456)
round(3.556)
round(3.456, 2) #round() – Round to Nearest
ceiling(4.1)   # 5 #ceiling()
ceiling(3.1) #ceiling() – Round Up irespective of decimal limit like 0.5 to 1..etc
floor(4.9)     # 4 vs floor() - removes rounding 
floor(3.9) #floor() – Round Down
trunc(5.9) #trunc() – Truncate Decimal Part

signif(123.456, 4) #signif() – Significant Digits
rank(c(100, 50, 75)) #Ranking, Ordering & Position Functions
order(c(100, 50, 75)) #order() – Sorting Index
#Assign the index 1,2,3
#find the small value: 50
#next smallest value : 76
#next : 100
#output
#2,3,1

which.min(x) #which.min() -Return Position of Min/Max
which.max(x) #which.max() – Return Position of Min/Max

#Handling Missing Values in Numeric Functions(*IMP*)
#---------------------------------------------
##Most numeric functions return NA if input has missing values.
#Using na.rm = TRUE
x <- c(10, 20, NA, 40)
sum(x)                 # NA
sum(x, na.rm = TRUE)  # 70
mean(x, na.rm = TRUE)

#Summary / Aggregation Functions
#-------------------------------
sum(c(10, 20, 30)) #sum() – Total
mean(c(10, 20, 30)) #mean() – Average
median(c(10, 20, 30)) #median() – Middle Value
min(3, 7, 2) #min()  Smallest
max(3, 7, 2) #max() Largest

#Range() function
##Range function in R, returns a vector containing the minimum and maximum of all the given arguments
range(c(5, 10, 20,90,50)) #range() – Minimum and Maximum
##Range function with NA:
x <- c(2,7,1,-17,Inf,35,21,7,NA)
range(x)
range(x,na.rm=TRUE)
##Range function for a character vector:
x<-c("a","h","x","i","j")
range(x)
##range() function in R of the dataframe column
mystu <- data.frame(name=c('a','b','c','d','e','f','g'), marks=c(43,45,67,32,56,23,54))
range(mystu$marks)

#Statistical Functions
#---------------------
sd(c(10, 20, 30)) #sd() – Standard Deviation
var(c(10, 20, 30)) #var() – Variance
quantile(c(10, 20, 30, 40), 0.75) #quantile() – Percentiles
IQR(c(10, 20, 30, 40)) #IQR() – Interquartile Range

#Cumulative Functions
#--------------------
cumsum(c(2, 4, 6)) #cumsum() – Cumulative Sum
cumprod(c(2, 3, 4)) #cumprod() – Cumulative Product
cummin(x)
#looks 1st element 1: min 1
#looks 2st element 1 and 2. min 1
#looks 3st element 1 2 and 3. min 1
#looks 3st element 1 2 3 and 4. min 1
#looks 3st element 1 2 3 4 5. min 1
cummax(c(1, 5, 3, 8)) #cummax() / cummin() – Running Max / Min
#looks 1st element 1: min 1
#looks 2st element 1 and 2. min 2
#looks 3st element 1 2 and 3. min 3
#looks 3st element 1 2 3 and 4. min 4
#looks 3st element 1 2 3 4 5. min 5

library(dplyr)
cummean(c(10, 20, 30))

#Formatting Numbers
#-------------------
#Format()
#Argument-->Purpose
#digits-->Controls the number of significant digits shown.
#nsmall-->Forces a specific number of digits after the decimal point.
#scientific-->Toggles scientific notation (TRUE, FALSE, or a threshold).
#trim-->If TRUE, removes leading/trailing padding spaces.
#big.mark-->Adds a separator (like a comma) for thousands.
getOption("digits")
options(digits = 7)  # default

format(c(10, 12.5, 100.6), nsmall = 2) #Controlling Decimals (nsmall)
format(12.345678, digits = 4) #Significant Digits (digits)
format(1250000, big.mark = ",", scientific = FALSE) #Big Number Formatting (big.mark)
#handling Dates
# %Y-->Year with century (4 digits)-->2026
# %y-->Year without century (2 digits)-->26
# %B-->Full month name-->January
# %b-->Abbreviated month name-->Jan
# %m-->Month as a number (01-12)-->	01
# %d-->Day of the month (01-31)-->	27
# %A-->Full weekday name-->Tuesday
# %a-->Abbreviated weekday name-->	Tue
format(Sys.time(), "%B %d, %Y") 
format(Sys.time(), "%Y-%m-%dT%H:%M:%S")
#Cleaning Up Space (trim)
nums <- c(1.1, 100.1)
format(nums)              # Output: "  1.1" "100.1"
format(nums, trim = TRUE) # Output: "1.1" "100.1"


#formatC() 
#While format() is a general-purpose tool, formatC() is its more powerful, faster cousin.
# #Type Code-->Description-->Example-->Output (x = 10)
# "f"-->Fixed floating point (decimal)-->10.000
# "e"-->Scientific notation-->1.000e+01
# "g"-->General (picks the shorter of 'f' or 'e')-->10
# "d"-->Integer (digits)-->10
# "s"-->String-->"10"

formatC(c(1, 15, 120), width = 4, format = "d", flag = "0") #Zero-Padding (Great for File Names or IDs)
formatC(1.2, digits = 3, format = "f") #Precise Decimal Control
formatC(1234.5678, format="f", digits=2) #formatC() – Control Formatting
formatC(c(-1.5, 2.3, 0), format = "f", digits = 1, flag = "+") #Forcing a Positive Sign
formatC(123456, format = "e", digits = 2) #Scientific Notation with Specific Precision

#Modular Arithmetic
#------------------
10 %% 3 #%% – Remainder
10 %/% 3 #%/% – Integer Division return the quotient

#Random Number Generation
#------------------------
runif(5, 1, 10) #runif()-used mainfly for disturbutions.
runif(20) #its the sequence but min=0 and max=1 as default
runif(4:20) #sequence range
runif(10,min = 18,max = 65) #with min and max value
floor(runif(5,min = 10,max = 20)) #getting integer value
ceiling(runif(5,min = 10,max = 20))
trunc(runif(5,min = 10,max = 20))

#sample() – Random Sampling
sample(1:10, 3) ##Generate a random integer between 1 and 10
sample(1:10, 5, replace=T) ##if we want to generate more than one random number, 
##Select 6 random numbers between 1 and 40, without replacement
sample(1:40, 6, replace=F)
sample(2:10)

?sample
set.seed(123) #set.seed() – Reproducibility
runif(3)
runif
?.Random.seed

#Testing / Logical Numeric Functions
#-----------------------------------
is.numeric(10) #is.numeric()
is.integer(10L) #is.integer()
#any() / all()
#if_any() Keeps a row if the condition is true in at least one of the selected columns.
any(c(1, 2, 3) > 2)
any(c(1, 2, 2) > 2)
#if_all() Keeps a row only if the condition is true in every single one of the selected columns.
all(c(1, 2, 3) > 2)
all(c(6, 5, 3) > 2)

#Sequence & Repetition
#---------------------
seq(1, 10, by = 2) #seq() – Generate Sequences
rep(5, times = 3) #rep() – Repeat Values

#Window / Rolling Style Numeric Functions
#-----------------------------------------
#diff() – Differences Between Consecutive Values
x <- c(10, 15, 25, 40)
diff(x)
#lag() / lead() (dplyr)
library(dplyr)
lag(x)
lead(x)
#Moving Average (Manual)
##The "Standard" Way: frollmean() (data.table)
library(data.table)f
data <- c(10, 20, 30, 40, 50)
# Calculate a moving average with a window of 3
frollmean(data, n = 3)
#The "Tidy" Way: rollmean() (zoo)
library(zoo)
# k = window size; fill = NA keeps the output the same length as the input
rollmean(data, k = 3, fill = NA)
#The "Base R" Way (No Packages)
stats::filter(data, filter = rep(1/3, 3), sides = 1)

#Numeric Testing & Classification
#--------------------------------
#is.finite(), is.infinite(), is.nan()
is.finite(10)
is.infinite(Inf)
is.nan(NaN)

#all.equal() – Floating Point Comparison
a <- 0.1 + 0.2
b <- 0.3
a == b            # FALSE (precision issue)
all.equal(a, b)  # TRUE

#Random & Probability Functions
#------------------------------
#Distributions: d, p, q, r
#For Normal Distribution:
#Function	Purpose
#dnorm()	Density
#pnorm()	Cumulative probability
#qnorm()	Quantile
#rnorm()	Random values

rnorm(5, mean=0, sd=1)
pnorm(1.96)

#Trigonometric Functions
#-----------------------
#All angles are in radian
sin(pi/2)     # 1
cos(0)        # 1
tan(pi/4)     # 1

#Inverse Functions
asin(1)
acos(1)
atan(1)

#Convert degrees → radians:
deg <- 30
rad <- deg * pi / 180
sin(rad)

#Scaling, Normalization & Transformation
#---------------------------------------
#scale() – Standardization (Z-score)
x <- c(10, 20, 30)
scale(x) #Centers to mean 0, sd 1.

#Min–Max Normalization
x <- c(10, 20, 30)
(x - min(x)) / (max(x) - min(x))

#Log Transformation
log(x) #Used to reduce skewness.

#Common Pitfalls
#----------------
#Ignoring NA
mean(c(10, NA, 20))   # NA
##Use
mean(c(10, NA, 20), na.rm=TRUE)

#Floating Point Comparisons
0.1 + 0.2 == 0.3   # FALSE
#Use
all.equal(0.1 + 0.2, 0.3)

#Real-World Analytical Examples
#-------------------------------
#Example 1: Z-Score Calculation (Outlier Detection)
x <- c(50, 55, 60, 200)
z <- (x - mean(x)) / sd(x)
z

#Example 2: BMI Calculation
weight <- c(60, 72, 80)   # kg
height <- c(1.65, 1.70, 1.75)  # meters
bmi <- weight / (height^2)
round(bmi, 2)

#Example 3: Percent Change
sales <- c(100, 120, 150)
pct_change <- diff(sales) / sales[-length(sales)] * 100
pct_change

#Example 4: Ranking Students
marks <- c(80, 95, 70, 85)
rank(-marks)   # Higher marks → better rank

#ZIP function equivalent in R
# -------------------------------
#zip() when you want to do something with the pairs immediately.

#The Direct Equivalent: mapply() or Map()
names <- c("Alice", "Bob")
ages <- c(25, 30)
Map(function(x, y) paste(x, "is", y), names, ages) # Returns a list (similar to Python's zip)
mapply(function(x, y) paste(x, "is", y), names, ages) # mapply is a "friendly" version that tries to simplify the output to a vector

#Zipping into a Data Frame
# Creating a table where each row is a "zipped" pair
df <- data.frame(names, ages)
df

#The Modern R Way: purrr::map2()
library(purrr)
map2_chr(names, ages, ~paste(.x, "is", .y)) # map2 takes two inputs; pmap takes many

#Unzipping
zipped <- list(c("Alice", 25), c("Bob", 30))
unzipped <- do.call(rbind, zipped) # Unzip into a matrix
unzipped


#Summary: Most Frequently Used String Functions
#----------------------------------------------
#Basic Mathematical Functions- abs(),sqrt(),log(),exp(),factorial(5),choose(),prod()
#Rounding & Precision Control- round(),ceiling(),floor(),trunc(),signif(),rank(),order(),which.min(),which.max()
#Handling Missing Values in Numeric Functions- na.rm()
#Summary / Aggregation Functions- sum(),mean(),median(),min(),max(),range()
#Statistical Functions - sd(),var(),quantitl(),IQR()
#Cumulative Functions- cumsum(),cumprod(),cummax()
#Formatting Numbers- format(),formatc(),
#Modular Arithmetic- %%, %/%
#Random Number Generation - runif(),rnorm(),sample()
#Testing / Logical Numeric Functions- is.numeric(),any(),all()
#Sequence & Repetition- seq(),rep()
#Window / Rolling Style Numeric Functions- diff(),lag(),lead(),moving average,rollmean()
#Numeric Testing & Classification- is.finite(),is.infi(),is.nan()
#Random & Probability Functions- dnorm(),pnorm(),qnorm(),rnorm()
#Trigonometric Functions- sing(),cos(),tan(),asin(),
#Scaling, Normalization & Transformation- scale(),log()
#zip() functions

#Most widely used in data analysis
#---------------------------------
#Aggregation / Summary Statistics - Sum(),mean(),median(),min(),max(),range(),quantile()
#Variability / Dispersion- sd(),var()
#Mathematical Operations - abs(),sqrt(),log(),log10().
#Rounding & Precision- round(),floor(),ceiling(),signif()
#Data Transformation / Scaling- scale()
#Missing Value Handling & Validation- is.na(),na.ram=TRUE
 
#Mental Model for Interviews & Projects
#--------------------------------------
#Numeric --> Summarize --> Clean --> Transform --> Report

# Quiz:
# =====
 
# Assignment:
# ===========
# https://github.com/ganeshbabuNN/MyNotes/blob/master/R_Language/2-Programming_Fundamentals/Assignments/Assignment_DataTypes.pdf

#Resources:
#=========
#https://resbaz.github.io/2014-r-materials/lessons/01-intro_r/data-structures.html
#https://www.statmethods.net/management/typeconversion.html
#https://rforexcelusers.com/calculate-percent-column-r/
#https://blog.revolutionanalytics.com/2009/02/how-to-choose-a-random-number-in-r.html
#https://www.datasciencemadesimple.com/range-function-in-r/
