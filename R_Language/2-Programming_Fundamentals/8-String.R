#Intro
#Creating Strings
#Printing Strings
#String Formatting
#Accessing String elements
#Escape characters
#String Regular expressions
#String Functions
#Quiz
#Assignment
#Resources

# Intro
# =====
# *Strings are a group of characters written inside a single or double-quotes
# *Internally R stores every string within double quotes, even when you create them with single quote

#Creating Strings
#================
#In R, a string is a sequence of characters and is stored as a character vector.

#String Creation Methods
#-----------------------
##Direct Assignment
x <- "Data Science"
class(x)
##character() function
x <- character(3)
x 

#Single Quotes vs Double Quotes
#------------------------------
'Hello World' #using Single quotes
"Hello world" #using double quotes #but we cannot use double quotes or single quotes ,in the same statement more than one time

mystr<-" I'm using single quotes, but this will create an error"# Be careful with quotes!
#for correcting the above , use double quotes
mystr<-"I'm using single quotes, but this will create an error"
mystr
nchar(mystr) # counting the character in a given string
a <- 32423423
length(a) # it counts the items
nchar(as.character(a)) #count of digits
#get class and type
class(x)
typeof(x)

#Empty String vs NA
#-----------------------
x <- c("", NA, "R")
class(x)
x == ""
is.na(x)

# create a vector of two empty strings 
y <- character(2)
y
length(y)
nchar(y)

# create an empty character vector
z <- character(0)
z
length(z)
nchar(z)

# add a component to the vector
z[1] <- "Tom"
z
length(z)
nchar(z)

#Character Vectors (Core Concept)
#--------------------------------
#In R, strings never exist alone.
#They always exist inside a vector, even if there is only one string.
x <- "R"
length(x)
#Multiple strings:
languages <- c("R", "Python", "SQL")

length(languages)

#check whether a variable is of character type
x <- "The wheather is fine"
is.character(x)

# convert a numeric vector in a character vector
x <- c(2, 3, 4)
typeof(x)

x <- as.character(x)
x

typeof(x)
is.character(x)

#Rules Applied in String Construction
------------------------------------
#*The quotes at the beginning and end of a string should be both double quotes or both single quote. They can not be mixed.
#*Double quotes can be inserted into a string starting and ending with single quote.
#*Single quote can be inserted into a string starting and ending with double quotes.
#*Double quotes can not be inserted into a string starting and ending with double quotes.
#*Single quote can not be inserted into a string starting and ending with single quote.

#Printing Strings
#=================
#using R studio, you can directly enter

# We can simply declare a string
'Hello world'

#Example of valid strings
a <- "learn the R Programming language"
print(a)

a <- 'learn the R Programming language'
print(a) #observe the output R takes internally Double quotes

a <- "learn the R 'Programming language"  
print(a) #observer the output 

a <- 'learn the R "Programming language'
print(a) #observer the output 

#Example of In-valid strings
#a <- "learn the R "Programming language'
#a <- 'learn the R 'Programming language'
#a <- "learn the R"Programming language"

#String Formatting
#=================
#String formatting lets you inject items into a string rather than trying to chain items together using commas or string concatenation. As a quick comparison, consider:

#for example
company='Novo nordisk'
experience='7'
name ='Ganesh babu'

#using cat functions
cat("Myself,",name,'working in',company,' for past ',experience,' years.') 
#using paste functions
paste("Myself,",name,'working in',company,' for past ',experience,' years.') 

#There are three ways to perform string formatting
#using cat functions (classical way)
#using paste functions (classical way)
#using paste functions (classical way)
#using paste0 functions (classical way)
#using stringf() in R

#print() Function in R
#---------------------
#Definition: print() displays an R object in the console.
#Simple meaning :“Show me what is inside this object.”

#Why use print()? 
##Default way R shows output
##Useful inside functions, loops, and scripts
##Automatically called when you type an object name

#Syntax
#print(object)

#Basic Example
x <- 10
print(x)

#Real-World Example
total_sales <- 15420
print(total_sales)

#Special Behavior
print(10 + 5)
#does the same in interactive mode.

#Common Mistakes
##Expecting formatted output
##Using print() for string building

#Best Practices
##Use inside loops and functions
##Use for debugging
##Combine with sprintf() if formatting needed

#When to Use vs Not Use
##Use
###Debugging
###Checking intermediate results
##Do NOT use
###For clean formatted messages (use cat() or sprintf())

#cat() Function in R
#-------------------
#Definition: cat() concatenates and prints output directly to the console.
#Simple meaning“Say this text exactly as written.”

#Why use cat()?
##Clean console messages
##No quotes
##No [1] index
##Great for user messages

#Syntax
cat(..., sep = " ", file = "", fill = FALSE)

#Basic Example
cat("Hello World")

#Multiple Values
cat("Total:", 100, "units")

#New Line (VERY IMPORTANT)
cat("Hello\nWorld")

#Real-World Example
cat("Process completed successfully\n")
##Writing Directly to a File
cat("Log Entry: Script started successfully1", file = "log1.txt", append = TRUE)
##Building Custom "User-Facing" Messages
check_status <- function(db_name) {
  cat("Connecting to database:", db_name, "...\n")
  cat("Status: [CONNECTED]\n")
  cat("User: Admin")
}
check_status("Production_Server")
##Monitoring Long-Running Loops (Progress Logs)
for (i in 1:5) {
  # ... doing heavy data work ...
  Sys.sleep(1) 
  cat("Successfully processed iteration", i, "at", as.character(Sys.time()), "\n")
}

#Vector Behavior
cat(c("A", "B", "C"))

#Common Mistakes
#Forgetting \n
#Expecting returned value (cat returns NULL)

#Best Practices
##Use \n explicitly
##Use for user messages and logs
##Do not use for data storage

#When to Use vs Not Use
##Use
##Console messages
##Progress updates

#Logs
##Do NOT use
##When output needs to be saved
##When chaining functions

#paste() Function in R
#--------------------
#Definition :paste() combines values into a single string with a separator.
#Simple meaning :“Join text pieces together with space (or any separator).”

#Why use paste()?
##Create strings dynamically
##Join text + numbers
##Vectorized string joining

#Syntax
paste(..., sep = " ", collapse = NULL)

#Basic Example
paste("Hello", "R")

#Custom Separator
paste("2026", "01", "26", sep = "-")

#Vector Example
names <- c("A", "B", "C")
paste("Item", names)

#Real-World Example
##using paste for dynamic SQL
table_name <- "inventory_2023"
min_stock <- 50
query <- paste("SELECT * FROM", table_name, "WHERE stock_level <", min_stock)
query

##Summarizing Rows (Collapsing)
shopping_list <- c("Apples", "Milk", "Bread")
shopping_list
paste(shopping_list, collapse = ", ") ## Turn the vector into a single sentence

##Custom Plot Titles
region <- "North America"
total_sales <- 45000
plot_title <- paste("Sales Report for", region, "| Total: $", total_sales)
plot_title
# Used in ggplot2: labs(title = plot_title)

#Common Mistakes
##Forgetting collapse
##Using paste for numeric formatting

#Best Practices
##Use for simple string joining
##Combine with vectors
##Avoid complex formatting

#When to Use vs Not Use
##Use
###Joining text
###Labels
###Messages
##Do NOT use
###Decimal formatting
###Alignment needs
getwd()

#paste0() Function in R
#----------------------
#Definition: paste0() is the same as paste() but without space separator.
#Simple meaning “Glue strings together tightly.”

Syntax
paste0(...)

#Equivalent to:
paste(...,)

#Basic Example
paste0("Hello", "R")

#Real-World Example (VERY COMMON)
file_id <- 10
paste0("report_", file_id, ".csv")
ids <- 1:3
paste0("ID_", ids)

##using paste0 for batch file importing
months <- c("Jan", "Feb", "Mar", "Apr")
folder <- "C:/Users/ganes/Documents/Kriyababa/GitHub/mytrainings/R_Training_Swetha_20260105"
## Generate full paths
file_paths <- paste0(folder, "Sales_", months, ".csv")
file_paths

#Common Mistakes
#Expecting spaces
#Overusing when readability suffers

#Best Practices
#Use for IDs, filenames, keys
#Prefer paste() for readable text

#When to Use vs Not Use
##Use
###File names
###IDs
###URLs
##Do NOT use
###Human-readable sentences

#One-Line Decision Rule
#Debugging / checking value --> print()
#User messages / logs --> cat()
#Joining readable text --> paste()
#IDs / filenames → paste0()
#Professional formatting → sprintf()

#Using stringf()
--------------
#sprintf() creates formatted strings by inserting values into a template string using format specifiers.
  
#Benefits:
##Control decimal places
##Align numbers
##Add leading zeros
##Create professional reports
##Generate filenames dynamically
##Cleaner than paste() for numeric formatting
  
#Why do we need sprintf()?
paste("Score:", 9.45678) #without springf()s
sprintf("Score: %.2f", 9.45678) #with springf()s

#Basic Syntax
sprintf("format_string", value1, value2, ...)
#"format_string" → text + placeholders
#value1, value2 → values to insert

#Most Important Format Specifiers
#Specifier-->Meaning-->	Example
##most frequenlty used.
#%s-->String-->name
#%d or %i-->Integer-->10
#%f-->Decimal (float)-->3.14

##formatting & precssion specifer
#%.nf(Precision)--> %.2f - 2 decimal places-->3.14
#%e-->Scientific notation-->1.23e+03
#%g --> automatically choise either %f or %e.. #six digits by default 
#%% --> literals

##paddig and alignment
#%5d(Width)-->pads with spaces
#%05d(padding)-->Pad with zeros
#%-10s(left align)
#%10s(right align)


#String formatting
sprintf("Hello %s", "Ganesh")
#Integer formatting
sprintf("Total items: %d", 25)
#Decimal control
sprintf("%f", 0.725896956) #by default, it prints six decimals
sprintf("%.3f", 0.725896956) #to print 3 decimals only
sprintf("%.f", 0.725896956) #round the number (print no decimals)
sprintf("%+.3f", 0.725896956) #print the + sign (but the first 3 decimals only)
sprintf("Accuracy: %.2f", 98.456)
sprintf("Accuracy: %.2f%%", 98.456) #ti add percentage sign
#Multiple Values in One String
name <- "Ravi"
score <- 87.345
sprintf("Student %s scored %.1f marks", name, score)
sprintf("%e", 82.235691) #%e and %E print the number in exponential format
sprintf("%E", 82.235691)
sprintf("%g", 82.235691) #%g prints six digits by default
sprintf("%.4g", 82.235691) #print the first 4 digits
sprintf("%.4s", "Philadelphia") #%s prints the desired number of characters in a string

#padding and alignment
sprintf("%5d",82) #blank padding.. width
sprintf("%05d",82) #leading Zero padding
sprintf("%-10s","Gan") #right align
sprintf("%10s","Gan")  #left align

#Real-World Practical Examples
##Report generation
month <- "January"
revenue <- 15432.678
sprintf("Revenue for %s: ₹%.2f", month, revenue)

##File name creation (very common)
id <- 7
sprintf("report_%03d.csv", id)

##Creating Standardized IDs (Padding)
### if you want EMP-001, EMP-002
emp_ids <- c(1, 24, 105)
# %03d means: "Integer, 3 digits wide, pad with zeros"
formatted_ids <- sprintf("EMP-%03d", emp_ids)
formatted_ids 

##Logging messages
time <- "10:30 AM"
users <- 124
sprintf("[%s] Active users: %d", time, users)

##we want to print the following:
###"The sum of the numbers 4.5 and 10 is 14.5"
a <- 4.5
b <- 10
x <- sprintf("The sum of the numbers %.1f and %d is %.1f", a, b, a+b)
x

##Formatting Currency and Decimals
price <- 1250.4
sprintf("$%.2f", price) 

##Scientific Notation or Hexadecima
sprintf("%e", 1500000) # "1.500000e+06" # Scientific notation
sprintf("#%X%X%X", 255, 0, 255) # "#FF0FF" # Hexadecimal (useful for color codes)

##Vectorized Nature of sprintf()
##sprintf() works vector-wise.
scores <- c(78.123, 82.5, 90.678)
sprintf("Score: %.1f", scores)

#Rule of thumb
##Use paste() for simple text joining
##Use sprintf() for formatted output

#Common Mistakes
##Wrong number of arguments
sprintf("Value: %d %d", 10)
##Wrong specifier
sprintf("Value: %d", "text")
##Forgetting %% for percentage
sprintf("Success: %d%", 90)   # wrong
sprintf("Success: %d%%", 90)

#When to Use vs When NOT to Use
##Use sprintf() when:
##Formatting numbers
##Generating clean outputs
##Printing aligned results
##Creating dynamic strings
#Do NOT use when:
##Just joining plain text
##No formatting control is needed

#Accessing String elements
#=========================
#-The individual characters of a string can be extracted from a string by using the indexing methods of a string
#-There are two R’s inbuilt functions in order to access both the single character as well as the substrings of the string
#-substr() or substring() function in R extracts substrings out of a string beginning with the start index and ending with the end index

#Syntax:
substr(..., start, end)
or 
substring(..., start, end)

x <- "Learn R programming"
substr(x,1,1) #grapping from start 1 to end 1
substr(x,1,5) #grapping from start 1 to end 4

#-create sequences of letters using the built-in vector letters
letters
letters[1] #-the first letter of the alphabet
letters[1:5] #-the first five letters of the alphabet
letters[c(1, 5, 14)] #-the first, fifth and fourteenth letters of the alphabet

#Escape characters
#=================
#To insert characters that are illegal in a string, use an escape character
#An escape character is a backslash \ followed by the character you want to insert.

#There are difference types:
#\': single quote. You don’t need to escape single quote inside a double-quoted string, so we can also use "'" in the previous example.
#\": double quote. Similarly, double quotes can be used inside a single-quoted string, i.e. '"'.
#\n: Starts a new line.
#\t: tab character.
#\b: Backspace.
#\": Double quote.
#\r: Carriage return.
#\\: Single Backslash

#Example:
#\' : Single Quote : Used when your string is wrapped in single quotes, but you need to include a literal single quote inside it.
# output: "He said, "R is powerful."
cat('It\'s a beautiful day in the neighborhood.') #
#\" : Double Quote : Used when your string is wrapped in double quotes, and you need to include literal double quotes (like for speech).
cat("The professor said, \"R is powerful for statistics.\"")
#\n : New Line :Moves the cursor to the start of the next line. This is the most common way to format multi-line output.
cat("Line One\nLine Two\nLine Three") 
#\t : Tab Character:Inserts a horizontal tab, useful for aligning text or creating simple columns without a table.
cat("ID\tName\tScore\n1\tAlice\t95\n2\tBob\t88")
#\b : Backspace :Moves the cursor back one space, effectively deleting the character that was previously there.
cat("Errorrr\b\b") #try in base R ,RStudio: Often ignores \b entirely or just moves the cursor without erasing, 
#\r : Carriage Return : Moves the cursor to the beginning of the current line without moving to a new line. 
#In many modern consoles, this allows you to "overwrite" what was previously written.
cat("Loading... 0%\r") # try in base R
cat("Loading... 100%\n")
cat("helloworld\rGoodbye")
#\\ : Single Backslash :Because the backslash is the "escape character" itself, 
#if you want to print an actual backslash (like in a file path), you have to escape the escape.
cat("The file is located at C:\\Users\\Documents\\Data")
cat("c:\users\documents\data.csv")
cat("c:\\users\\documents\\data.csv")

#Raw string
##Raw Strings to avoid escaping altogether
# Syntax: r"(content)"
path <- r"(C:\Users\Documents\data.csv)"
cat(path)
# Output: C:\Users\Documents\data.csv

#String Regular expressions
#==========================
#Regular Expressions (Regex) are the "search patterns" used inside string functions like str_detect(), grep(), or str_replace(). 
#Think of them as a special language that describes a set of strings without naming them individually
#In R, there is one major "gotcha": Double Backslashes. Because the backslash is an escape character in R,
#you almost always need to use \\ instead of \ for regex codes.

#1. The Building Blocks (Special Characters)
#Special characters have pre-defined meanings in regex. They are not treated as normal letters.
#These define where to look or which specific characters to allow.
#Most common special characters
#Character->Meaning -> Simple explanation
#. =   Any single character -->Except newline
#^  =  Start of string -->“Must begin with”
#$  =  End of string --> “Must end with”
#* = Zero or more followed or contained-> Can repeat or be absent
#+ = One or more --> Must appear at least once
#? = Zero or one --> Optional
#` =  Match this OR that (TBD)
#() =  Grouping -->Treat parts as a unit
#[] = Character class --> One from many
#{} = Quantifier --> Exact counts
#\\ = Escape(R Factor) --> Makes special characters literal
#[^] = Negative Set: Any character NOT inside 

#Special Characters
x <- c("cat", "bat", "rat", "drat", "cat123", "123cat", "c.at")
#.(Dot)
##Meaning: Matches any single character (except newline)
grep("c.t", x, value = TRUE)
library(tidyverse)
str_subset(pattern = "c.t", string = x)

#^ (Caret)
##Meaning: Start of string
grep("^c", x, value = TRUE)
#$ (Dollar)
##Meaning: End of string
grep("t$", x, value = TRUE)
#* (Asterisk)
##Meaning:*- zero or more occurrence of the previous character which contains else in the string or followed.
grep("ca*", x, value = TRUE)
#+ (Plus)
##Meaning: One or more occurrences
grep("ca+", x, value = TRUE)
#? (Question mark)
##Meaning: Zero or one occurrence (optional)
grep("ca?t", c("ct", "cat", "caat"), value = TRUE)
#{}(Curly braces)
##Meaning: Exact or range repetition
grep("a{2}", c("a", "aa", "aaa"), value = TRUE)
#[] (Character class)
##Meaning: Match one character from a set
grep("[cr]at", x, value = TRUE)
#[^ ] (Negated character class)
##Meaning: Match any character NOT in the set
grep("[^0-9]", c("123", "12a", "456"), value = TRUE)
#() (Grouping)
##Meaning: Group parts of the pattern
grep("(cat|bat)", x, value = TRUE)
#| #OR
##Meaning: Logical OR
grep("cat|rat", x, value = TRUE)
#\\ (Escape character class)
##Meaning: Treat special characters literally
grep("\\.", x, value = TRUE)
#\\d, \\w, \\s (Perl-style shortcuts)
#its like “Match one character from this set”
#\\d : Digit (0-9)
#\\D : Non-digit
#\\w : Word character (letters, numbers, and underscores)
#\\W : Non-word character (symbols, spaces, etc.)
#\\s : Whitespace (spaces, tabs, newlines)
#\\S : Non-whitespace
##These work only with perl = TRUE
##\\d - digit
grep("\\d", x, value = TRUE, perl = TRUE)
##\\w - word character (letter, digit, _)
grep("\\w+", x, value = TRUE, perl = TRUE)
#\\s - whitespace
grep("\\s", c("hello world", "helloworld"), value = TRUE, perl = TRUE)

#Quantifiers (how many times?)
#Quantifiers control how many times something may repeat.
#These symbols follow a character to tell R how many times it should appear.
#Common quantifiers
#* : 0 or more times
#+ : 1 or more times
#? : 0 or 1 times
#{n} : Exactly n times
#{n,} : At least n times
#{n,m} :Between n and m times 

##Quantifiers
x <- c("a", "aa", "aaa", "aaaa", "b", "ab", "abb", "abbb")
#* -->Zero or more times
##Meaning: The preceding character/group may appear zero times or many times
grep("ab*", x, value = TRUE)
#+ -> One or more times
##Meaning:  The preceding character/group must appear at least once
grep("ab+", x, value = TRUE)
#? → Zero or one time (optional)
##The preceding character/group is optional but cannot repeat
#{n} → Exactly n times
##The preceding character/group must occur exactly n times
grep("a{3}", x, value = TRUE)
#{n,} → At least n times
##The preceding character/group must occur n or more times
grep("a{2,}", x, value = TRUE)
#{n,m} → Between n and m times
##The preceding character/group must occur at least n and at most m times
grep("a{2,3}", x, value = TRUE)
#Quantifiers with groups ()
##Quantifiers can apply to entire patterns, not just single characters.
grep("(ab){2}", c("ab", "abab", "ababab"), value = TRUE)
#Quantifiers with character classes
##grep("[0-9]{3}", c("12", "123", "1234"), value = TRUE)
#Greedy behavior (default)
##Quantifiers are greedy by default — they match as much as possible.
grep("a+", "aaaa", value = TRUE)
#Lazy (non-greedy) quantifiers (perl = TRUE)
##Add ? to make quantifiers lazy
regmatches("aaaa", regexpr("a+?", "aaaa", perl = TRUE))

#Match Indian 10-digit mobile numbers
grep("^[6-9][0-9]{9}$",
     c("9876543210", "1234567890", "998877665"),
     value = TRUE)
#? --> maybe
#* --> any amount
#+ --> must exist
#{} --> controlled count

#Common predefined character classes
##Class	Meaning
##[:digit:]	Digits (0–9)
##[:alpha:]	Letters
##[:alnum:]	Letters + digits
##[:lower:]	Lowercase
##[:upper:]	Uppercase
##[:space:]	Whitespace

#predefined character classes
##this is the third pillar of regex, and once this lands, regex becomes predictable instead of scary.
x <- c(
  "abc",
  "ABC",
  "AbC123",
  "123",
  "abc_123",
  "hello world",
  "\tspace",
  "email@test.com"
)
#[[:digit:]] -> Digits
##Meaning: Matches 0–9
grep("[[:digit:]]", x, value = TRUE)
#[[:alpha:]] -> Letters
##Meaning: Matches A–Z and a–z
grep("[[:alpha:]]", x, value = TRUE)
#[[:alnum:]] -> Letters + digits
##Meaning: Alphanumeric characters only
grep("[[:alnum:]]", x, value = TRUE) #Almost everything except pure symbols
#[[:lower:]] -> Lowercase letters
grep("[[:lower:]]", x, value = TRUE)
#[[:upper:]] -> Uppercase letters
grep("[[:upper:]]", x, value = TRUE)
#[[:space:]] -> Whitespace
grep("[[:space:]]", x, value = TRUE)
#[[:punct:]] -> Punctuation
##Meaning: Any punctuation character
grep("[[:punct:]]", x, value = TRUE) # Includes _ . , ! @ # etc.
#[[:graph:]] ->  Visible characters
##Meaning: Everything except whitespace
grep("[[:graph:]]", x, value = TRUE) #All strings except those with only spaces
#[[:print:]] → Printable characters
##Meaning: Visible characters plus spaces
grep("[[:print:]]", x, value = TRUE) #Almost everything except control characters
#[[:cntrl:]] → Control characters
##Meaning: Tabs, newlines, non-printable chars
grep("[[:cntrl:]]", x, value = TRUE)
#[[:xdigit:]] → Hexadecimal digits
#Meaning: 0–9, A–F, a–f
grep("[[:xdigit:]]", c("A3", "F9", "G7"), value = TRUE)
#[[:blank:]] → Space & tab only
##Difference from [[:space:]]
grep("[[:blank:]]", x, value = TRUE)

#Combine predefined classes with quantifiers
##Example: Match exactly 4 digits
grep("^[[:digit:]]{4}$", c("123", "2024", "12345"), value = TRUE)
##Example: Extract words only
grep("^[[:alpha:]]+$", c("hello", "hello123", "HELLO"), value = TRUE)
##Perl-style shortcuts (optional but common)
grep("\\d+", "Order123", value = TRUE, perl = TRUE)

#Mental model (lock this in)
##Predefined class -> What type of character?
##Quantifier -> How many?
##Anchors -> Where?

#Commonly used regex functions in BaseR vs stringr package
#Base R -->stringr / dplyr Equivalent-->What it does in a dplyr context
#grepl()-->str_detect()-->Used inside filter() to keep rows matching a pattern.
#grep()-->str_which() or which(str_detect())-->Returns the numeric indices of matches.
#regexpr()-->str_locate()-->Returns a matrix of start and end positions for the first match.
#gregexpr()-->str_locate_all()-->Returns a list of matrices for all matches.
#sub()-->str_replace()-->Replaces the first match (usually inside mutate()).
#gsub()-->str_replace_all()-->Replaces every match found in the string.
#regexec()-->str_match()-->Extracts the match and any capture groups (the () parts).
#regmatches()-->str_extract() / str_subset()-->Pulls out the actual text that matched.

#Commonly used regex functions in stringr package
#Function -> One-Line Description
#str_detect() -> Returns TRUE/FALSE if the pattern exists (best for filtering rows).
#str_extract() -> Pulls out the first text match it finds in each string.
#str_extract_all() -> Pulls out every match in the string (returns a list).
#str_replace() -> "Swaps the first match with new text (e.g., fixing one typo)."
#str_replace_all() -> "Swaps every match (e.g., removing all symbols from a column)."
#str_remove_all() -> "Deletes every instance of a pattern (shortcut for replacing with """")."
#str_subset() -> Keeps only the entire strings that match the pattern.
#str_count() -> "Counts how many times a pattern appears (e.g., number of commas)."
#str_split() -> Breaks a string into pieces wherever the pattern occurs.
#str_match() -> Extracts the full match and specific capture groups into a matrix.

#Commonly used regex functions in base R
#---------------------------------------
#Function -> One-Line Description
#grepl() -> "Returns TRUE/FALSE if a pattern is found (the ""l"" stands for logical)."
#grep() -> Returns the indices (positions) of the strings that match the pattern.
#regexpr() -> Finds the starting position and length of the first match.
#gregexpr() -> Finds the starting positions and lengths of all matches in a string.
#sub() -> Replaces only the first occurrence of a pattern.
#gsub() -> "Replaces all occurrences of a pattern (the ""g"" stands for global)."
#regexec() -> "Like regexpr, but also identifies the positions of capture groups."
#regmatches() -> Used in combination with regexpr or exec to actually extract the text.

#Key Differences to Remember
#Object Structure: 
##stringr functions usually return simple vectors or matrices. 
##Base R functions (like regexpr) return integer vectors with attributes (like match.length), which you often have to extract using attr().
#Argument Order:
##stringr: str_detect(string, pattern) → (Data first, then Pattern)
##Base R: grepl(pattern, string) → (Pattern first, then Data)
##This is the most common mistake when switching between the two!
#Global vs Single: 
##In Base R, you have to choose between different function names for global actions (e.g., sub vs gsub). In stringr, it's usually a suffix (e.g., _all).

#String Functions
#================
#Objects are usually have built-in methods. 
#These methods are functions inside the object (we will learn about these in much more depth later) that can perform actions or commands on the object itself.
#Two Main Ways to Work with Strings in R
##Base R functions – built-in, no package required
##stringr functions – consistent, readable, tidyverse style

# Install once if needed
install.packages("stringr")
library(stringr)

#Creating & Inspecting Strings
#-----------------------------
#character() – create empty character vector
x <- character(3)
x
#is.character() – check type
x <- "data science"
is.character(x)

#Length & Basic Inspection
#-------------------------
#length() vs nchar()
#length()-->Number of elements
#nchar()-->Number of characters inside string

x <- c("R", "Python", "SQL")
length(x)
nchar(x)

#from stringr
str_length("sdfsdf")
str_length(c("R", "Python", "SQL"))

#Combining & Formatting Strings
#-----------------------------
#this paste(),paste0, springf() are already explained.

#paste() – combine strings
paste("Ganesh", "Analyst")
paste("Ganesh", "Analyst", sep = " - ")
#paste0() – faster
paste0("ID", 101) #Used heavily while creating IDs, column names
#sprintf() – formatted strings
sprintf("Name: %s | Age: %d | Salary: %.2f", "Ravi", 30, 45000.567) #Useful for reports, logging, and file naming.

#from stringr
name <- "Alice"
score <- 95
# Instead of paste("Student", name, "scored", score)
str_glue("Student {name} scored {score}%") 
# Output: "Student Alice scored 95%"

#Case Conversion 
#---------------
#Common during data standardization
toupper("Hello") ##toupper() 
tolower("WORLD") ##tolower()

#from stringr
library(stringr)
str_to_lower("GANESH BABU")
str_to_upper("GANESH BABU")
str_to_title("GANESH BABU")
str_to_camel("GANESH BABU") #were the first letter of each word is capitalized, with no separation between words.
str_to_sentence("GANESH BABU")
str_to_snake("GANESH BABU")  #convert to lower case and put underscore between sentence
str_to_kebab("GANESH BABU") #convert to lower case and put dash between sentence


#Trimming & Padding (Data Cleaning)
#------------------------------
#trimws() – Remove Leading/Trailing Spaces
trimws("   hello world   ")
#strrep() – repeat strings
strrep("-", 10)

#from Stringr
x="   String with trailing,   middle      , and leading white space  "
str_trim(x)
str_trim(x,side = c("left")) # like do al lthe string
str_squish(x) #Trims all whitespace from the start and end. The Ultimate Cleaner

#Substring & Extraction (CORE SKILL)
#----------------------------------
#substr() – extract part of string
x <- "DataScience"
substr(x, 1, 4)

#substring() – similar, but vector-friendly
substring(x, c(1,5), c(4,11))

#from stringr
shopping_list <- c("apples 5", "bananas 10", "cherries no-count")
### Extract the first digit found
str_extract(shopping_list, "\\d+") #returns the first match it finds. If no match is found, it returns NA
###Pulls every match (returns a list).
str_extract_all(shopping_list, "\\d+")
#Returns the entire string that contains a match.
str_subset(shopping_list, "\\d+")

#Pattern Matching (VERY IMPORTANT FOR ANALYSIS)
----------------------------------------------
#grep() – find positions (returns index)
x <- c("apple", "banana", "grape")
grep("ap", x)

#grepl() – logical output (MOST USED in filtering)
##grep() – Return Matching Index/Values
grepl("ap", x) #Used inside subset(), dplyr::filter() 
x <- c("AE_TERM", "AE_SEVERITY", "DM_AGE") 
grep("AE", x)

#from stringr
fruits <- c("apple", "banana", "cherry", "date") 
str_detect(fruits, "an") #It checks if a pattern exists anywhere inside the string
str_starts(fruits, "a") #only returns TRUE if the string begins with the specified pattern
str_ends(fruits, "e")#It only returns TRUE if the string finishes with the specified pattern

#Replace & Remove Text (DATA CLEANING CORE)
#-------------------------------------------
#sub() – replace first occurrence
x <- "2025-01-22"
sub("-", "/", x)

#gsub() – replace all occurrences (VERY IMPORTANT)
gsub("-", "/", x) #Used in date cleanup, ID cleanup, text normalization

#chartr() – character translation
##The function maps each character in the first argument (old) to the corresponding character in the second argument (new).
## like first argu to second arg mapping a=1,e=2,i=3,o=4,u=5 .. and replace the mapped element to 3rd argument
chartr("aeiou", "12345", "banana")

#from stringr
text <- "apple apple apple"
str_replace(text, "apple", "pear") #It only replaces the very first occurrence of a pattern it finds in each string.
str_replace_all(text, "apple", "pear") #It replaces every single occurrence of the pattern it finds.
#These are actually just shortcuts for str_replace() where the replacement is an empty string ("").
prices <- c("$10.00", "$25.50", "$100")
str_remove(prices, "\\$")
#it also acts as a name vector
grades <- c("A", "B", "C")
str_replace_all(grades, c("A" = "Excellent", "B" = "Good", "C" = "Pass"))

#Splitting Strings
#----------------
#strsplit() – split string into pieces
x <- "R,Python,SQL,Julia" #Used when handling CSV-like text columns
strsplit(x, ",")

#from stringr
str_split(x,pattern = ",") #retrun the list  

#Comparing Strings
#-----------------
# == – Exact Match
"abc" == "ABC"
"ABC" == "ABC"

#identical() – Strict Comparison
identical("abc", "abc")
identical("abc", "ABC")

#Sorting & Ordering Strings
#--------------------------
#sort() – alphabetical order
x <- c("SQL", "R", "Python","PPyl")
sort(x)
#order() – index-based ordering
x[order(x)]


#Handling Missing & Empty Strings (IMPORTANT)
#----------------------------------
x <- c("R", "", NA)
is.na(x)
x == ""
#Empty string "" ≠ NA

#Common Real-World Examples
#--------------------------
#Clean Subject IDs
ids <- c(" SUB_001 ", "SUB-002", "sub_003")
ids_clean <- toupper(trimws(gsub("-", "_", ids)))
ids_clean

#Extract Visit Number from Label
visit <- c("Visit 1", "Visit 2", "Visit 10")
as.numeric(str_extract(visit, "[0-9]+"))

#Split First and Last Name
name <- "Ganesh Babu"
parts <- strsplit(name, " ")[[1]]
first <- parts[1]
last <- parts[2]
paste(first,last)

#Validate Email
email <- "test@example.com"
grepl("^A-Za[-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", email)

#Filter emails with Gmail
emails <- c("a@gmail.com", "b@yahoo.com")
emails[grepl("gmail", emails)]

#File Name Generation
subject <- "ABC123"
date <- "20250116"
paste0("Report_", subject, "_", date, ".csv")

#Clean column names
names <- c("First Name", "Last Name")
clean_names <- tolower(gsub(" ", "_", names))
clean_names
# "first_name" "last_name"

#Extract year from date string
date <- "2025-01-22"
substr(date, 1, 4)


#Common Pitfalls
#--------------
#Using == for Pattern Matching
"Data" == "ClinicalData"   # FALSE
#Use:grepl("Data", "ClinicalData")

#Forgetting Vectorization
for (i in 1:length(x)) {
  x[i] <- toupper(x[i])
}
#Better
toupper(x)


#Summary: Most Frequently Used String Functions
#----------------------------------------------
#Creating & Inspecting Strings - character(),is.character()
#Length & Basic Inspection - length(),nchar()
#Combining & Formatting Strings -paste(),paste0, springf()
#Case Conversion- toupper,tolower,stringr
#Trimming & Padding (Data Cleaning) - trimws(),strrep
#Substring & Extraction  -substr(),substring()
#Pattern Matching - grep(),grepl(),
#Replace & Remove Text - sub(),gsub,str_replace()
#Splitting Strings -strsplit()
#Comparing Strings- ==,identical(),chartr()
#Sorting & Ordering Strings - sort(),order()
#Handling Missing & Empty Strings - is.na()


#Most widely used functions in data analysis
#---------------------------------
#String Length & Validation - nchar(),str_length()
#Combining / Concatenation- paste(),paste0()
#Case Conversion / Standardization - toupper(),tolower(),str_to_upper(),str_to_lower()
#Trimming & Whitespace Cleanup-  trimws(),str_trim()
#Pattern Matching / Detection (Regex)- grep(),grepl(),str_detect(),str_start(),str_ends()
#Extraction / Substring- substr(),substring(),str_extract()
#Replacement / Cleaning - sub(),gsub(),chartr(),str_replace(),str_replace_all(),str_remove()
#Splitting & Parsing- strsplit(),str_split()
#Filtering & Selection- str_subset()

#Mental Model for Interviews & Projects
#Numeric → Summarize → Clean → Transform → Report
#String → Clean → Standardize → Detect → Extract

#Quiz:
#=====

#Assignment:
#===========

#Resources:
#=========
# https://www.tutorialspoint.com/r/r_strings.htm
# https://www.gastonsanchez.com/r4strings/
# https://www.geeksforgeeks.org/r-strings/
# https://www.r-bloggers.com/2020/01/objects-that-feel-mutable-in-r/
# https://www.tutorialkart.com/r-tutorial/find-length-of-string-in-r-programming/
# https://rstudio-pubs-static.s3.amazonaws.com/74603_76cd14d5983f47408fdf0b323550b846.html
# https://bookdown.org/yihui/rmarkdown-cookbook/latex-output.html
# https://cran.r-project.org/doc/manuals/R-lang.html#Literal-constants  --officials
# https://www.datacamp.com/community/tutorials/strings-in-r
# #https://stringr.tidyverse.org/
# https://www.rdocumentation.org/packages/DescTools/versions/0.99.41/topics/StrAlign
