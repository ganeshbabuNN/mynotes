#Introduction
#Data Types(Atomic Data Types)
##Primitive DataTypes
##Special Values
##Advance Data Types
#Strings
#Data Structures (Built from Data Types)
#Default value of Types
#Type Checking
#Missingness Semantics
#Data Type Conversion in R
#Quiz
#Assignment
#Resources

#Introduction
#============
#In programming languages, we need to use various variables to store various information. 
#Variables are the reserved memory location to store values. As we create a variable in our program, some space is reserved in memory.
#In R, there are several data types such as integer, string, etc. The operating system allocates memory based on the data type of the variable and decides what can be stored in the reserved memory
#R objects can be composed of different kinds of data according to the type and number of "atomic" values they contain:
#Scalar items are single values;
#Vectors are ordered sequences of scalars, they must all have the same "data type" (e.g. numeric, logical, character ...)

#Data Types(Atomic Data Types)
#=============================
#*In R, there are 6 data types
#1)Numeric 
#2)Integer
#3)Logical
#4)Complex
#5)Characters
#6)Raw

##Primitive DataTypes
#-------------------
#we shall understand the different type of data type

#Numeric
-------
#Definition :Stores real numbers with decimals.
#Purpose: Used for measurements, calculations, analytics.
  
#decimal
price <- 99.99
typeof(price)
class(price)

#using normal
b <- 323
typeof(b)
class(b)

.Machine$double.xmin
.Machine$double.xmax

#Real-World Example:
temperature <- c(36.5, 37.2, 38.1)

#Common Mistakes:
##Assuming integers are numeric by default
##Precision issues in comparisons

#Best Practices:
##Use all.equal() for comparisons
c<-323
all.equal(a,c)
all.equal(b,c)
##Avoid floating-point equality checks

#Use When:
##Continuous values are required

#Do NOT Use When:
##Exact counting is needed (use Integer)

#Integer
#--------
#Definition : Whole numbers ending with L.
#purpose : Memory efficiency and exact counts.

a <- 323L
typeof(a)
class(a)

a<-as.integer(3)

.Machine$integer.max

#Real-World Example:
number_of_orders <- 1200L

#Common Mistakes:
##Forgetting L
##Mixing numeric and integer unintentionally

#Best Practices:
##Explicitly define integers in loops

#Use When:
##Counting items or indexing

#Do NOT Use When:
##Fractions are needed

#Logical
------
#It is a special data type for data with only two possible values which can be construed as true/false.
#Definition :Boolean values: TRUE, FALSE.
#Decision making and filtering.

flag <- TRUE
typeof(flag)
class(flag) 

#Not valid
flag1 <- "FALSE"
typeof(b)
class(b) 

#Real-World Example:
is_active <- FALSE
employees$eligible <- employees$age >= 60

#Common Mistakes:
##Using "TRUE" instead of TRUE
##NA logical propagation

#Best Practices:
##Handle NA explicitly

#Use When:
##Conditions and flags

#Do NOT Use When:
##More than two states are needed

#Character
#--------
#*In R programming, a character is used to represent string values. 
#Definition: Text strings
#Purpose: Labels, names, categories.

#using double or single are the same quotes
name <- "R Programming"
name
typeof(name)
class(name)
name <- 'R Programming'
city <- "Chennai"

#Real-World Example:
customer_id <- "CUST_1023"

#Common Mistakes:
##Forgetting quotes
##Treating characters as numbers

#Best Practices:
##Trim and clean text early

#Use When:
##Data is textual

#Do NOT Use When:
##Mathematical operations are required

#Complex
#------
#A complex value in R is defined as the pure imaginary value i.
#Definition:Numbers with imaginary part.
#Purpose: Scientific and signal processing.

z <- 2 + 3i
typeof(z)
class(z)

#Real-World Example:
##Electrical engineering calculations

#Common Mistakes:
##Unexpected coercion

#Best Practices:
##Isolate from regular numeric data

#Use When:
##Imaginary numbers exist

#Do NOT Use When:
##Business analytics

#Raw
#---
#A raw data type is used to holds raw bytes.
#Definition:Binary data.
#Purpose: Low-level data handling.
myraw <- charToRaw("R is a Super Programming language")
typeof(myraw)
class(myraw)
readBin("file.pdf", "raw", n = 1e6)

#Real-World Example:
##File hashing
##Binary communication
##You are reading PDF files, images, encrypted files, APIs.

#Use When:
##Byte-level manipulation


##Special Values
#--------------
#NULL
##Represents no value / no object.
##Absence of object.
#Absence of a value.
#Length = 0.
#Not a data type; it removes objects.
x <- NULL
length(x)  # 0
typeof(x)
class(x)
x<-c("1","2","3",NULL)#NULL will be removed during output operations 
x

#Common Mistake:
#Confusing NA with NULL

#NA (Missing Values)
##Represents missing data. In details which see different type of missing value later.
##nothing is different missing is different but both are not same.
x <- NA
length(x)
class(x)
x <- c(10, NA, 30)
#NA==NULL 
#NULL==""
#1==1
#NA=" "

x <- c(10, NA, 30,"",NULL) #added a blank
x #observe
x<- as.integer(x)
x #observe the "" i,e string is repalced with NA which is missing.

#NaN
##Undefined numeric result
x <-0/0
x
typeof(x)
length(x) 
class(x)

#Inf / -Inf
##Infinity
x<-1/0    # Inf
x<--1/0   # -Inf
length(x) 
typeof(x)
class(x)

##Advance Data Types
#-------------------
#Date
----
  #Stores dates only not time.
  d <- as.Date("2026-01-13")
d#
typeof(d)
# "double"
class(d)
# "Date"
d <- as.Date(("2026-01-13 10:30:00")) #if want to print the time this will not be possible.
typeof(d)
class(d)
#Stored as number of days since 1970-01-01.
#for other language is
#R->1970‑01‑01 00:00:00 UTC
#Python->1970‑01‑01 00:00:00 UTC
#Java->1970‑01‑01 00:00:00 UTC
#SAS->1960‑01‑01 00:00:00 UTC

#POSIXct / POSIXlt (Date-Time)
---------------------------
#"POSIXct" is faster 
##Stores date + time.
t <- as.POSIXct("2026-01-13 10:30:00") #portable operating system interface(POSI) calender time(ct) 
typeof(t)
class(t)

#"POSIXlt" is heavy 
dt4 <-as.POSIXlt("2025-03-11 01:30:50") #portable operating system interface(POSI) local time(lt)
dt4
typeof(dt4)
class(dt4)

#the main difference apart from POSIXct we can extract data parts like date,hour,second,...etc.
lt <- as.POSIXlt(Sys.time())
lt
#time part
lt$sec
lt$min
lt$hour
#data part
lt$year+1900 #year since 1900
lt$mon+1 #month(0-11) since months start where jan=0
lt$mday
#metadata
lt$zone
lt$gmtoff

#formatting  the data
dt <- as.POSIXlt(Sys.time())
?strptime
format(dt,"%Y") #4-digit
format(dt,"%y") # 2-digit year
format(dt,"%m")# month(1-12)
format(dt,"%b") #abbreviated month
format(dt,"%B") #full month name
format(dt,"%A") #Weekname
format(dt,"%a") #short week 
format(dt,"%d") #day
format(dt,"%M") #minutes
format(dt,"%S") #Seconds
format(dt,"%H") #Hour

#Advanced way
library(lubridate)
#https://lubridate.tidyverse.org/reference/index.html
a<- now() #equivalent to Sys.time()
a
#date
year(a)
month(a)
mday(a)
wday(a) 
#time part
hour(a) 
minute(a)
second(a)
#impute
a+months(1) #adding month
a+months(2) #adding month
a+years(1) #adding year
a+days(10) #adding 10 days

#formatting
mdy("03-01-2026")
ydm("2026-15-03")
dmy("31-03/2026")
dmy_h("31-03/2026 10")

#handling partial dates
raw_dates <- c("2026-03-21","2026-05","2026")
#turncated 2 whichmonth and day
parse_date <- parse_date_time(raw_dates,order="ymd",truncated = 2)

#Ordered Factor – Ranking Systems
#--------------------------------
severity <- ordered(c("Mild","Moderate","Severe"))
severity

#there are other types like S3,R6..etc which are discussed in upcoming chapter.

#String
#======
#*Strings are a group of characters written inside a single or double-quotes
#*Internally R stores every string within double quotes, even when you create them with single quote

#Creating Strings

#Single or Double Quotes
s1<- 'Hello world'
s2<-"Hello world"
#String = character type in R

#using double quotes
##use single quotes also
s1 <- 'my name is baba'
s1
typeof(s1)
class(s1)

##s1 <- "my name is baba"
s1 <- "my name is baba"
typeof(s1)
class(s1)

#*we shall learn more on the string chapter using function in next chapters

#Data Structures (Built from Data Types)
#================================
#In computer science, a data structure is a data organization, management, and storage format that enables efficient access and modification
#More precisely, a data structure is a collection of data values, the relationships among them, and the functions or operations that can be applied to the data.
#Its is also called as sequential data types

#There are different types of R objects
#1)Vectors
#2)List
#3)Matricesss
#5)Factors
#6)DataFrame

#4)Arrays

#Vectors
#--------
#The very basic data types are the R-objects called vectors which hold elements of different classes as shown above
#When you want to create vector with more than one element
#You should use c() function which means to combine the elements into a vector
#Homogeneous collection of atomic values.

#create a vector
##character vector
a <- c("Ganesh","babu","Kumar","Veeresh")
a
typeof(a)
class(a)

##numreic vector
a <- c(3,2,3,4,5) #numeric
a
typeof(a)
class(a)

##integer vector
a <- c(3L,2L,3L,4L,5L) #numeric
a
typeof(a)
class(a)

#logical vector
a <- c(TRUE,FALSE,TRUE) 
a
typeof(a)
class(a)

#observe
a <- c("1","4","5","1",3,TRUE) #Coercion Hierarchy we shall understand later
a
typeof(a)
class(a)

##validate
a <- c(3,2,3,4,5,"a")
a
typeof(a)
class(a)

a <- c("1","4","5","1",3)
a
typeof(a)
class(a)
##*Note even numeric, logical, character and vector of different types can also be created . 
##this is expalined in detail in data structure chapter.

#Real-World Example:
daily_sales <- c(100, 120, 90)

#Mistake
##Mixing types unintentionally

##CRUD operations
#Create
x <- c(10,20,30,40)
x
class(x)

#Read
##always the index starts with 1 not Zero
x #full vector
x[2] # 2 element
x[c(3,4)] #read indiviual element
x[2:4] #range of values
x[-1] #reading reverse #it drops the first element and display remaining
x[c(-1,2)] #does not work
x[c(-1:-2)] #drops first two elements
x[c(-1,-3)] #drops first and 2 elements

#update
x[3] <-33
x
x[1:2] <- 20 #it updates all the sequence
x
x[c(1,2)] <- 50
x

#delete
x<-x[-2] #removes second element
x


#list
#----
#Heterogeneous container.
#A list is an R-object which can contain many different types of elements inside it like vectors, functions and even another list inside it

#syntax:
	list()

#create a list using list() function
a <- list(1,"Ganesh",TRUE,3.3,5L,0+3i,as.Date("2025-01-01"),NULL,NA,c(3,2,4,3),stu.data)
a
typeof(a)
class(a)

#Real-World Example:
employee <- list(id=1, name="Asha", salary=50000,age=20)
employee

#Use When:
##Nested or complex data

##CRUD Operations
#Create
my_list <- list(name = "Ganesh", age = 25, scores = c(80, 90))

#read
my_list
my_list$name #access the name using $
my_list["name"] #access the name using subset operator
my_list[c("name","scores")]

#update
my_list$age <- 26
my_list

#delte
my_list$age <- NULL
my_list


#Matrix
#--------
#its a 2D homogeneous structure.
#a matrix is a collection of elements of the same data type (numeric, character, or logical) arranged into a fixed number of rows and columns. 
#Since you are only working with rows and columns, a matrix is called two-dimensional.

#syntax:
matrix(data, nrow, ncol, byrow, dim_name)  

a<-matrix(c(1,2,3,4,5,6),nrow = 2,ncol = 3,byrow = TRUE)
a
typeof(a)
class(a) 

b<- matrix(c(7,8,9,10,11,12),nrow = 3,ncol = 2,byrow = TRUE)
b
typeof(a)
class(a) 

a %*% b #dot product ex: https://www.mathsisfun.com/algebra/matrix-multiplying.html

#Different behaviour
a<-matrix(c(1,2,3,4,5,6),nrow = 3,ncol = 3,byrow = TRUE)
a
b<- matrix(c(7,8,9,10,11,12),nrow = 3,ncol = 3,byrow = TRUE)
b
a*b 
a+b
a/b
a%%b #modulus

#Real-World Example:
##Survey response grids

##CURD Operations
#Create
m <- matrix(1:9, nrow = 3)
m

#Read
m
m[2, 3]   # row 2, column 3
m[2]
m[1:6]
m[c(3,6,8)]

#update
m[1, 1] <- 100

#Delete
(R does not directly delete like vectors, but you can remove rows/cols)
m <- m[-1, ]   # remove 1st row
m <- m[, -2]   # remove 2nd column
m



#arrays
#------
#Multi-dimensional matrix.
#While matrices are confined to two dimensions, arrays can be of any number of dimensions
#The array function takes a dim attribute which creates the required number of dimension.

#syntax:
	array_name <- array(data,dim(row_size,col_size,dim_names))

#create a array
names <- array(c("Ganesh","babu","Kumar","Veeresh"),dim=c(2,2,2))
names
class(names)

#Real-World Example:
#Time-series across regions and years

#Factors
#-------
#Categorical variable with levels.
#Factors are the r-objects which are created using a vector
#It stores the vector along with the distinct values of the elements in the vector as labels
#The labels are always character irrespective of whether it is numeric or character or Boolean etc. in the input vector.

#syntax:
	factor()

#Real-World Example:
gender <- factor(c("Male","Female","Male","Female"))
gender

#test it is a factor
is.factor((gender))

#Common Mistake:
##Treating factor as character

#DataFrame
#----------
#Definition :Tabular data with mixed types.
#Unlike a matrix in data frame each column can contain different modes of data
#It is a list of vectors of equal length.

#syntax:
	data.frame()

#creating a dataframe
student_data <- data.frame(
  student_id = c(14:19),
  student_name=c("ganesh","roopa","hari","swati","rudresh","vani"),
  student_gender=c("M","F","M","F","M","F"),
  student_age =c(32,44,34,56,34,23),
  student_class= c("MCA","BCA","BTECH","BE",NA,"MSC"),
  student_join=as.Date(c("2021-01-20","2022-01-22","2000-03-18","2012-01-11","2022-01-14","2000-03-24")),
  stringsAsFactors = FALSE
)

student_data
student_data$student_gender #checking making stringsAsFactors = TRUE
class(stu.data)
typeof(stu.data)
print(stu.data)

#Real-World Example:
##CSV, Excel data

#Tibble
#------
#Modern data frame.
#Does not auto-convert strings to factors.
library(tibble)
student_tdata<-tibble( student_id = c(14:19),
                    student_name=c("ganesh","roopa","hari","swati","rudresh","vani"),
                    student_gender=c("M","F","M","F","M","F"),
                    student_age =c(32,44,34,56,34,23),
                    student_class= c("MCA","BCA","BTECH","BE","MTECH","MSC"),
                    student_join=as.Date(c("2021-01-20","2022-01-22","2000-03-18","2012-01-11","2022-01-14","2000-03-24"))
                   )
student_tdata
# Tibble: returns another tibble
class(student_tdata[, 1])


#Feature-->Data Frame (Base R)-->Tibble (library(tibble))
#----------------------------------------------------------
#Printing-->Large, messy output-->Concise, 10-row summary
#Data Types-->Hidden-->Displayed in the header
#Strings-->Historically converted to Factors-->Always kept as Characters
#Partial Matching-->Yes (e.g., $a finds $apple)-->No (Lazy matching is disabled)
#Subsetting[ , ]-->May return a vector-->Always returns a tibble


#Default value of Types
#======================
#Default value = what R fills when you create an empty vector.
#0 is a real value
#NA means value not available

#numeric(double)  -> 0
numeric(2) #this print the empty value of an vector

#integer --> 0L
integer(4)

#logical --> FALSE
logical(2)

#charcter --> ""
character(1)

#complex -> 0+0i
complex(1)

#raw --> 00
raw(1)

#list --> NULL
vector("list",1)

#factor --> NA
factor(character(1))

#date ---> NA
as.Date(character(1))

#POSIXct/POSIXlt --> NA
as.POSIXct(character(1))
as.POSIXlt(character(1))

#Type Checking
#=============
#there are mostly 4 types in general
#1)typeof()->Internal storage
#2)class()->Object behavior
#3)mode()->Legacy (avoid)
#4)str()->Structure

#typeof()->How R stores it internally
#--------------------------------------
#typeof() tells you the low-level storage type used by R’s C engine.
#Think: “In memory, what kind of object is this?”

a<-3
b<-4L #Even though 10 looks like an integer, R stores it as double.
c<-"ga"
d <- factor(c("a","b"))
e <- as.Date("2026-01-13")
typeof(a)
typeof(b)
typeof(c)
typeof(d)
typeof(e)

#class() → What kind of object R thinks it is
----------------------------------------------
#*Conceptually class() gives the object-oriented class.
#*object<->class its idealogy is object , class is a keyword.
#*It controls how functions behave on the object (methods).
#Think like “What category of object is this for R functions?”

a<-3
b<-4L
c<-"ga"
d <- factor(c("a","b"))
e <- as.Date("2026-01-13")
class(a)
class(b)
class(c) #Internally: integer #Conceptually: categorical variable
class(d) #Internally: integer #Conceptually: categorical variable
class(e) ##Internally: stored as a double  #Conceptually: treated as a Date

#mode() → Legacy / user-level type
----------------------------------
#*Concept mode() is an older, higher-level type system.
#*It is simpler and often less precise.
#Think:“What general type does this belong to?”
#It groups many internal types together.

a<-3
b<-4L
c<-"ga"
d <- factor(c("a","b"))
e <- as.Date("2026-01-13")
mode(a) #"numeric"
mode(b) #"numeric"
mode(c)
mode(d) #"numeric"
mode(e) #"numeric"

#So:
#mode() hides details
#Mostly kept for backward compatibility

#str() → Structure of the object
#--------------------------------
#Concept str() shows Type,Class,Length / dimensions,Attributes
#A preview of values
#Think:“What is inside this object?”

#Example: Vector
x <- c(1, 2, 3)
str(x)
#num [1:3] 1 2 3

#Meaning:
#num → numeric (double)
#[1:3] → length
#1 2 3 → values

#Example: Data Frame
df <- data.frame(
  id = 1:3,
  name = c("A", "B", "C"),
  passed = c(TRUE, FALSE, TRUE)
)
str(df)

#Checking Data Types
#-------------------
typeof(a) #low -level type
class(a) # high level type object way
mode(a) # legacy high level system
str(a) # structure of an mode #glimpse()

#Concept with One Object
#------------------------
x <- as.Date("2026-01-13")

typeof(x)
#"double"
class(x)
#"Date"
mode(x)
#"numeric"
str(x)
#Date[1:1], format: "2026-01-13"

#Interpretation on above
#Stored as double
#Treated as Date
#Broad type: numeric
#Structure: 1 element Date with formatting

#Why This Matters ?
#Example: Character Date Column
RFSTDTC <- "2026-01-13"
typeof(RFSTDTC)  # "character"
class(RFSTDTC)   # "character"

#But after conversion:
RFSTDTC <- as.Date(RFSTDTC)
typeof(RFSTDTC)  # "double"
class(RFSTDTC)   # "Date"

#So:
#class() tells you how it behaves (date arithmetic)
#typeof() tells you how it is stored
#str() confirms structure for validation

#Ref: object<->class
#https://youtu.be/m_MQYyJpIjg //layman understanding of a Oops

#To test the type data type
#--------------------------
#primitive type
is.numeric(23.2)
is.double(23)
is.character("addd")
is.integer(43L)
is.integer(43)
is.complex(3+2i)
is.logical(TRUE)
is.logical(F)
is.logical(T)
is.logical(1) #FALSE

#special value
is.null(NULL)
is.na(NA)
is.nan(NaN)
is.infinite(Inf)
is.infinite(-Inf)

#data structure
is.vector(c(3,3,4))
is.list(list(3,3,3))
is.matrix(matrix(c(3,3,3,3)))
is.factor(factor(c(3,3)))
is.array(array(c(3,3,3)))
is.data.frame(flights)

#Missingness Semantics
#=======================
#Missingness Semantics or Handling missing values in R, one of the common tasks in data analysis is handling missing values.

#NA- Not Available
#-------------------
#NA represents missing data in a place where a value should exist. It is a logical placeholder for a value that is unknown
#its like A "Reserved" sign on a chair; someone should be there.
#logical --> NA (missing value (default logical))
x<- NA #In R, NA (Not Available) is technically a logical constant by default based on the Coercion Hierarchy. 
typeof(x) 
class(x)
length(x)


#So R actually has different kinds of NA, one for each type.
#They all mean “value is missing”, but they preserve the data type.
x<- NA_integer_
typeof(x) 
class(x)
x<- NA_real_ #(for decimals)
typeof(x) 
class(x)
x<- NA_character_
typeof(x) 
class(x)
x<- NA_complex_
typeof(x) 
class(x)

#observe
c(3L,NA_integer_) #integer missing but the output is NA
c(1L, NA_character_) #character missing
c(3.3,NA_real_)
c(3.3,NA_character_)
name <- c("Ravi", "Sita", NA_character_)
typeof(name)
c(3+2i,NA_complex_) #complex missing
#raw ---> NA
c(charToRaw("ganes"),NA)

#NULL (The Empty Set)
#-------------------
#NULL represents the absence of an object. its The chair was never put in the room.
#While NA is a hole in your data, NULL is the total vacuum where data never existed in the first place.
##Length: length(NA) is 1. length(NULL) is 0.
##Behavior: NULL often simply disappears when combined with other values

y <- c(1, 2, NULL, 4)
y
length(y) #(The NULL was ignored entirely)
length(NULL)

#NaN and Inf
#-----------
#this are discussed more in the specail data tpes.


#Testing for Missingness
#-----------------------
val <- NA
val1 <- NULL
# The wrong way
val == NA
# The right way
is.na(val)
is.null(val1)

##Summary of Missing values in other prompinent languages
---------------------------------------------------------
##in R, it represented by 'NA'(Not available-generic missing) and other typed version are NA_integer,NA_real_,NA_character_,NA_complex.
x <- c(10, NA, 30)
is.na(x)

##in python(Pandas/Numpy), it represented by 'None'(general python object),'NaN(not a number used in Numpy and pandas) and other typed version are NA_integer,NA_real_,NA_character_,NA_complex.
#import pandas as pd
#x = pd.Series([10, None, 30])
#x.isna()

##SAS, it represented as '.'(dot-numeric missing), " "(blankspace-charactermising) 
# data test;
#   input age salary;
#   datalines;
#   25 50000
#   . 60000
#   30 .
# ;
# run;

##SQL its is represented as NULL(no value/unknown/not applicable. its not equal to anything, even another nULL.
#SELECT * FROM employees WHERE salary IS NULL;

##Julia represent missing.
#x = [10, missing, 30]
#ismissing.(x)

##java represent null(for object), special value of primitives Double.Nan for loating-point numbers.
# Integer x = null;
# double y = Double.NaN;

##SPSS Representation .(dot), user-defined missing: specifc value like -99,999.
#MISSING VALUES age (-99).

##Important Concept (Across All Languages)
#1)Missing values are not zero and not empty strings. They mean:
#-Data was not collected
#-Data is unknown
#-Data is not applicable
#-Data was lost or corrupted
#2)Treating missing values incorrectly can:
#-bias analysis
#-break models
#-cause regulatory issues in clinical data

#Data Type Conversion in R
#==========================
#In another language it is called as type casting for primitive type and for objects its boxing/unboxing.
#There are two broad types of conversion:
##Implicit (Automatic) Type Conversion
## Explicit (Manual) Type Conversion

#Implicit (Automatic) Type Conversion
#------------------------------------
##R automatically converts data types without you asking, based on a fixed hierarchy.
##Type Hierarchy (Lowest → Highest)
##logical → integer → numeric → character

#logical to integer
x <- c(TRUE,FALSE,5L)
x
typeof(x)

#integer --> numeric
x <- (1L+2)
x
typeof(x)

#numeric --> character
x <-c(10.5,"hello")
x
typeof(x)

#Example: Arithmetic Coercion
5 + "2" #non-numeric argument to binary operator

##Explicit (Manual) Type Conversion
#----------------------------------
#You explicitly tell R to convert a value using as.*() functions.

#character to number
##as.numeric()
a<-as.numeric("10")
a
typeof(a)

##decimal
a<-as.numeric("10.3")
a
typeof(a)
##Non-numeric text:
a<-as.numeric("A") #NA Warning: NAs introduced by coercion
a
typeof(a)

#experimenting(exp) NULL or NA
#-------------------------
#When you call as.numeric(NULL), you aren't creating a "missing value"—you are creating an empty vector.
#NULL represents the absence of an object.When forced into a numeric type, it becomes a numeric vector with a length of 0.
#typeof() looks at the storage mode of that vector. Since you asked for it to be numeric, R stores it as a double (the default numeric type in R)
a<-as.numeric(NULL) #NULL is like an empty box. If you say "give me an empty box for numbers," typeof tells you it's a box meant for double numbers, even if it's empty
typeof(a) #double

#NA is a logical constant by default, but R has several "flavors" of NA to ensure type consistency within vectors.
#When you run as.numeric(NA), R converts the logical NA into NA_real_
#The typeof() for NA_real_ is double. Remember represent NA as NA_integer_,NA_real_,NA_logical and NA_character.
a<-as.numeric(NA)#NA is like a box with a "Missing" sign inside. To keep the box's type consistent, R uses a specific version of that "Missing" sign that matches the numeric (double) type
typeof(a) #NA

#numeric to integer
#as.integer()
a<-as.integer(10)
a
typeof(a)
#non-numeric
a<-as.integer("A")
a
typeof(a) #NA
#exp NULL or NA
a<-as.integer(NULL)
typeof(a) #NA
a<-as.integer(NA)
typeof(a) #NA

#integer to logical
z<-1L
z
typeof(z)
z<-as.logical(z)
z
typeof(z)
#exp NULL or NA
a<-as.logical(NULL)
typeof(a) #NA
a<-as.logical(NA)
typeof(a) #NA
#exp on non-zero
# logical understand two non-zero and zero, when you have non-zero its its 1 and zero is 0 i,e TRUE and FALSE
z <- 3#positive number i,e non-zero
typeof(z)
z<-as.logical(z)
z
z <- -32 #negative number i,e non-zero
typeof(z)
z<-as.logical(z)
z

#OTHER WAY AROUND
#Character Conversions
#numeric to character
a<-as.character(100)#numeric
typeof(a)
a<-as.character(3.14)#decimal
typeof(a)
a<-as.character(1L)#integer
typeof(a)
a<-as.character(TRUE)#logical
typeof(a)
a<-as.character(NULL)#NULL
typeof(a) #NA
a<-as.character(NA) #NA
typeof(a) #NA

#numeric conversation
a<-as.numeric("A") #character
a 
typeof(a) #NAs introduced by coercion see the above concept
a<-as.numeric(1L) #integer
a 
typeof(a)
a<-as.numeric(TRUE) #logical
a 
typeof(a)
y <- "Apple"

#integer conversation
a<-as.integer("A") #character
a 
typeof(a) #NAs introduced by coercion see the above concept
a<-as.numeric(12) #numeric
a 
typeof(a)
a<-as.numeric(TRUE) #logical
a 
typeof(a)

#Logical Conversions
a<-as.logical(1) #numeric
typeof(a)
as.logical(1L) #integer
a
typeof(a)
as.logical("A") #character
#It creates a "slot" in memory reserved for logical values (TRUE, FALSE, or NA).
#Because "A" cannot be interpreted as true or false, R fills that slot with NA
#Since the "box" was made to hold logicals, typeof(a) will always be logical.
a
typeof(a)

#Factor Conversions (Very Important)
##Factor → Character (Always do this first)
f <- factor(c("A", "B", "C"))
as.character(f)
#Factor → Numeric (Wrong Way)
as.numeric(f) #(these are level codes)
#Correct Way
as.numeric(as.character(f))

#Date & Time Conversions
##Character → Date
as.Date("2025-01-16")
##With Format
as.Date("16-01-2025", format="%d-%m-%Y")
#POSIXct / POSIXlt
as.POSIXct("2025-01-16 10:30:00")
#Date -> Character
as.character(Sys.Date())

#Conversion Inside Data Structures
##Data Frame Column Conversion
df <- data.frame(
  id = c("1", "2", "3"),
  age = c("25", "30", "40"),
  stringsAsFactors = FALSE
)
str(df)

df$age <- as.numeric(df$age)
df
str(df)
##Matrix Conversion
m <- matrix(c(1, "A", 3), nrow=3)
typeof(m) #Matrices must have one data type.
##List Conversion
lst <- list(1, "A", TRUE) #Lists can store mixed types (no coercion).

#Coercion During Operations
#The Coercion Hierarchy When R performs an operation, it looks at the types involved and moves "up" this chain:
#logical-->integer-->numeric(double)-->character
#Logical is the "lowest" (least complex).
#Character is the "highest" (most complex) because any number or boolean can be represented as text, but not all text can be a number.

##A. Logical to Numeric (The most useful coercion)
###When you use a logical value (TRUE/FALSE) in a mathematical operation, R treats TRUE as 1 and FALSE as 0.
TRUE + 5       # Result: 6 (TRUE becomes 1)
sum(c(T, F, T)) # Result: 2 (Count of TRUEs)
mean(c(T, F))   # Result: 0.5 (Proportion of TRUEs)
TRUE + TRUE ##Arithmetic

##B.Numeric to Character
##If you combine numbers and text (e.g., in a vector or a comparison), the numbers are coerced into strings.
c(1, 2, "three") # Result: "1" "2" "three" (The numbers become text)
5 == "5" # Result: TRUE (The number 5 is coerced to "5" for comparison)
"10" == 10 ##Comparison

#C.Numeric to Logical
#In conditional statements (like an if block), R can coerce numbers to logicals. Zero becomes FALSE, and any other number becomes TRUE.
as.logical(0)  # FALSE
as.logical(42) # TRUE
##Logical Operations
1 & 0

#Safe Conversion Techniques
##Suppress Warnings
as.numeric("A")
suppressWarnings(as.numeric("A"))
##Check Before Converting
is.numeric(x)
is.character(x)
##Convert Multiple Columns
df[] <- lapply(df, as.character)
df
str(df)

#Type Testing Functions
#function - purpose
#class()-object clse
#typeof()-storage mode
#mode()- old-style type
#is.numeric()-Numeric check
#is.integer() -integer check
#is.character()- character check
#is.factor()-factor check
#str()-structure

x <- 10L
class(x)
typeof(x)

#Common Conversion Pitfalls
##Factor Trap
f <- factor(c("10", "20"))
as.numeric(f)   # wrong
as.numeric(as.character(f))#Correct
##NA Introduction
as.numeric(c("10", "A")) #The Failure: The string "A" has no logical numeric value but 10 it understood a number equivalent
as.numeric(c(10, "A"))
#Logical Misinterpretation
as.logical("Yes")   # NA

#aspect --> implicit-->explicit
#who controls-->R --> you
#Warning shown?-->rare often
#safe?-->risky-->safer
#usercase --> quickops --> date cleaning

#conversaion cheats
#character-->numeric =as.numeric()
#numeric-->character= as.character()
#Numeric--> Integer= as.integer()
#Logical-->Numeric= Automatic
#Character-->Logical= as.logical()
#Factor-->Character= as.character()
#Factor-->Numeric= as.numeric(as.character())
#Character-->Date= as.Date()
#Character-->POSIXct= as.POSIXct()

#Mutable and immutable Objects
#=============================


#Quiz:
#=====

#Assignment:
#===========
# Refer 
#https://github.com/ganeshbabuNN/MyNotes/blob/master/R_Language/2-Programming_Fundamentals/Assignments/Assignment_DataTypes.pdf

#Resources:
#=========
#https://www.tutorialspoint.com/r/r_data_types.htm
#https://www.r-bloggers.com/2021/04/handling-missing-values-in-r/
#https://bcb420-2022.github.io/R_basics/r-scalars.html#r-data-types   #scalara types
