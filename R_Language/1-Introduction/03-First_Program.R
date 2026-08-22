#First Program
#using command prompot or terminal
#Testing the input and output 

#First program
#=============
#Remember R is a case sensitive language

#using print function
#--------------------
#we just need a print function. No need of any packages or main functions, just a simple print function is enough---------
print("hello world")
#print() is a function which is used to print the values on to the output screen,It also has arguments, we can use it if needed

#if you don't want the quotes
print("hello world",quote=FALSE)

#using functions
#---------------
#Not really required but demostrating the possible way for running hello world program
new.hello <- function(){
  print("Hello world")
}

#calling the function
new.hello()

#using command prompt or terminal
#=================================
#open a notepad and type "print("hello world") and save the notepad as "helloworld.r
#go to command prompt and location the location of the R file saved and call the R file
Rscript helloworld.r ( from terminal options in R Studio)

#Testing the input and output 
#===========================

#reading the input from the users
#---------------------------------
#there are two ways
##Using readline() method
##Using scan() method

#readline() method
##----------------
#In R language readline() method takes input in string format. If one inputs an integer then it is inputted as a string
#here we use <- or = operator to store the output.

#Syntax:
var = readline();
var = as.integer(var);

#taking input as string
var =readline(prompt='Enter your name: ')

# taking input as number and converting to number
var =readline(prompt='Enter your number: ')
#as.integer(n); —> convert to integer
var=as.integer(var);

simillary 
#as.numeric(n); —> convert to numeric type (float, double etc)
#as.complex(n); —> convert to complex number (i.e 3+2i)
#as.Date(n) —> convert to date …, etc

# taking multiple inputs
{
name =readline(prompt='Enter your name: ')
age =readline(prompt='Enter your age: ')
place =readline(prompt='Enter your place: ')
}

print(name)
print(age)
print(place)

#scan() method
##----------------
#This method takes input from the console. This method is a very handy method while inputs are needed to taken quickly for any mathematical calculation or for any dataset
#scan() method is taking input continuously, to terminate the input process, need to press Enter key 2 times on the console

Syntax:
x = scan()

#taking input, default takes as number ! enter blank enter to quit the process
name=scan()

#to read as integer
age=scan(what=integer())
#to read as double
age=scan(what=double())
#to read as character
place=scan(what=character())
#to read a file and also the above parameter are applied for character and double.
file=scan("C:\\GBAG_Back\\MyTraining\\R\\1-Introduction\\test.txt")

#Printing the output of the user
#------------------------------#

#1. The Default: print():
##--------------------
user_output <- "Hello, World!"
print(user_output)

# Output:
# [1] "Hello, World!"

#Best for: Quick debugging and printing complex objects like data frames, lists, or linear models.Inspecting data frames, lists, and objects
#Limitation: It can only print one object at a time and keeps the automatic vector numbering ([1]).

#2. Clean Text: cat()
##--------------------
#Short for "concatenate", cat() combines multiple pieces of text and prints them cleanly without quotes or vector brackets
name <- "Alice"
cat("User name is:", name, "\n") # \n adds a new line

# Output:
# User name is: Alice

#Best for: Creating readable, custom console messages or writing to a text file.Printing clean, readable text to the console
#Limitation: By default, it doesn't automatically add a new line at the end, so you usually have to append \n.

#3. Styled Messages: message()
##--------------------
#This function sends text to the "diagnostic message" stream rather than standard output. By default, the text usually appears in a different color (like red in RStudio) to catch the eye.

user_status <- "Success"
message("Task completed with status: ", user_status)

# Output (often colored in IDEs):
# Task completed with status: Success

#Best for: Letting the user know a long process is running or has finished.Informational alerts and logs
#Bonus: Users can easily suppress these messages if they want to using suppressMessages().

#4. Formatted Strings: sprintf()
##---------------------------
#If you need to inject variables into a specific template, sprintf() works exactly like it does in C or Python. You use placeholders like %s for strings or %d for integers.
version <- 4.3
sprintf("Welcome user! You are running R version %s.", version)

# Output:
# [1] "Welcome user! You are running R version 4.3."

#Best for: Precise formatting, such as limiting decimal places (e.g., %.2f for two decimals).Precise control over variable formatting
#Note: sprintf() creates the string but technically relies on print() to show it unless you wrap it in cat().

#5. The Modern Way: glue::glue()
##-------------------------------
#If you have the glue package installed, this is often the cleanest and most modern way to handle output. It lets you interpolate variables directly inside curly braces.

# library(glue)
user <- "Bob"
score <- 95
glue("User {user} scored {score} points.")

# Output:
# User Bob scored 95 points.

#Best for: Highly readable code when building complex strings with many variables.Cleanest syntax for combining text and variables

#Help info
#---------
help(print) #Getting help on a function that you know the name of ? or help
?print
example(paste) #Use the example function to see examples of how to use it.
example(`for`)

demo() #The demo function gives longer demonstrations of how to use a function.
demo(package = .packages(all.available = TRUE)) # all demos
demo(plotmath)
demo(graphics)

#lot of more to see in variable chapater

#Quiz:
#=====

#Assignment:
#===========


#Resources:
#=========
