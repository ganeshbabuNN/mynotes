#Command Prompt
#####################Basic ##########################
#Using Function
#####################Advanced ##########################
#Using S3 method
#Using s4 Method
#using R6 Method
#Note Handling files in R
#Storing in RScript file and calling the script
#Help info
#Quiz
#Assignment
#Resources

#Introduction
#============
#this are the different way of executing the program from R.

#Command Prompt
#==============
# We can use the print() function
print("Hello World!")

# Quotes can be suppressed in the output
print("Hello World!", quote = FALSE)

# If there are more than 1 item, we can concatenate using paste()
print(paste("How","are","you?"))

#print is a statement
#Hello world! is a string literals
#paste is functions and statement

#Using Function
#==============

hello <- function() {
  print("hello world")
}
hello()

#if dynamically
hello <- function(a) {
  result<- a
  return(a)
}
hello("hello world") 

#hello is a function name which is an identifier
#function is a keyword
#print is a statement to print output.
#function has its syntax

#Procedure with code
#--------------------
#1)Decide function name
## hello <- 
#2)Declare function using function()
## hello <- function() {}
#3)Add input arguments or leave it blank
## hello <- function(a) {body}
#4)Write function body
##   hello <- function() {
## result<- a
## return(a)
##   }
#5)Return output (optional)
##return(a)
#7)Call the function
# hello("hello world")  or hello()

#Using S3
#=========
##S3 is informal, class-based, and generic-function driven.
##S3 Class -Function changes based on object type
##You call a function, and R decides which method to use based on the object’s class.

obj <- list()
class(obj) <- "helloworld"
hello <- function(x, ...) {
  UseMethod("hello")
}
hello.helloworld <- function(x, ...) {
  print("Hello, World!")
}
hello(obj)

#Procedure with code
--------------------
## Step 1: Create base object
obj <- list()
## Step 2: Assign S3 class
class(obj) <- "helloworld"
## Step 3: Define generic function
hello <- function(x, ...) {
  UseMethod("hello")
}
## Step 4: Define class-specific method
hello.helloworld <- function(x, ...) {
  print("Hello, World!")
}
## Step 5: Call generic function
hello(obj)
## Step 6: Check available methods(optional)
methods(hello)


#A Hello World program using the S3 object system, where method dispatch is based on the object’s class
#S3 Hello World = class(obj) + UseMethod() + hello.class

#Another way
studentDetails <- list(
  name = "ganesh",
  age = 43,
  contact = "india",
  grade = 12
)
class(studentDetails) <- "studentinfo"
studentDetails

#Using S4
#========
#S4 Class -Strict class with formal method
##You call a function, and R decides which method to use based on the object’s class.

setClass("HelloWorld",slots = list(dummy = "logical"))
obj <- new("HelloWorld", dummy = TRUE)
setGeneric("hello",function(x) standardGeneric("hello"))
setMethod("hello",signature(x = "HelloWorld"),
          function(x) {
            print("Hello, World!")
          }
)
hello(obj)

#Procedure with code
--------------------
## Step 1: Define S4 class
###Add at least one slot (even a dummy slot). if you do not have the slot , you shall get the error.
setClass("HelloWorld",slots = list(dummy = "logical"))
###Now the class is concrete, not virtual.
## Step 2: Create S4 object
obj <- new("HelloWorld", dummy = TRUE)
## Step 3: Define generic function
setGeneric("hello",function(x) standardGeneric("hello"))
## Step 4: Define method for class
setMethod("hello",signature(x = "HelloWorld"),
  function(x) {
    print("Hello, World!")
  }
)
## Step 5: Call generic function
hello(obj)
##4)Inspect class structure(optional)
slotNames("HelloWorld")


#Using R6
#========
#R6-Object owns its behavior (Java-style)
#The object itself has methods. You call them with $.

library(R6)
HelloWorld <- R6Class(
  "HelloWorld",
  public = list(
    hello = function() {
      print("Hello, World!")
    }
  )
)
obj <- HelloWorld$new()
obj$hello()

#Procedure with code
--------------------
## Step 1: Load R6 package
library(R6)
## Step 2: Define R6 class
HelloWorld <- R6Class(
  "HelloWorld",
  public = list(
    hello = function() {
      print("Hello, World!")
    }
  )
)
## Step 3: Create R6 object
obj <- HelloWorld$new()
## Step 4: Call method
obj$hello()


#Memory-Friendly Summary (Code Hooks)
#-----------------------------------
#Function --> function()
#S3 --> UseMethod()
#S4 --> setClass(), setMethod()
#R6 --> R6Class(), $new()

##We shall go in details in the advanced programming

#Help info
#=========
#help(print) #Getting help on a function that you know the name of ? or help
?print
example(paste) #Use the example function to see examples of how to use it.
example(`for`)

demo() #The demo function gives longer demonstrations of how to use a function.
demo(package = .packages(all.available = TRUE)) # all demos
demo(plotmath)
demo(graphics)

#functional searching
??regression #Finding a function that you don't know the name of Use ?? or, equivalently, help.search.
help.search("regression")
??"logistic regression"#Again, non-standard names and phrases need to be quoted.
apropos("a$") # apropos finds functions and variables in the current session-space (but not in installed but not-loaded packages) that match a regular expression.
RSiteSearch("logistic regression") #findFn in sos wraps RSiteSearch returning the results as a HTML table.

#packages info
View(available.packages()) #available.packages tells you all the packages that are available in the repositories that you set via setRepositories.
View(installed.packages()) # installed.packages tells you all the packages that you have installed in all the libraries specified in .libPaths
library() # library (without any arguments) is similar, returning the names and tag-line of installed packages
.libPaths() #.libPaths gets/sets the library trees within which packages are looked for.

data() #data with no arguments tells you which datasets are available on your machine.
search()#search tells you which packages have been loaded.
packageDescription("utils")    #packageDescription shows you the contents of a package's DESCRIPTION file. Likewise news read the NEWS file

ls() #ls lists the variables in an global environment
ls(all.names = TRUE) # including names beginning with '.'
ls("package:broom")     # everything for the sp package
str(a) #Most variables can be inspected using str or summary.
summary(a) #it is used for the dataframe to summarize the descriptive statistics
glimpse(a) #its is similar to summary .this package is from dplyr 

#directorys
getwd() # print the current working directory - cwd
ls()    # list the objects in the current workspace

setwd(mydirectory)      # change to mydirectory
setwd("c:/docs/mydir")  # note / instead of / in windows
setwd("/usr/rob/mydir") # on linux

# view and set options for the session
help(options) # learn about available options
options() # view current option settings
options(digits=3) # number of digits to print on output

# work with your previous commands
history() # display last 25 commands
history(max.show=Inf) # display all previous commands

# save your command history
savehistory(file="myfile") # default is ".Rhistory"

# recall your command history
loadhistory(file="myfile") # default is ".Rhistory"

# save the workspace to the file .RData in the cwd
save.image()

# save specific objects to a file
# if you don't specify the path, the cwd is assumed
save(object,list,file="myfile.RData")

# load a workspace into the current session
# if you don't specify the path, the cwd is assumed
load("myfile.RData")

q() # quit R. You will be prompted to save the workspace.

#removing the objects
rm(EX1) #remove the specific objects
rm(list=ls()) #remove all the objects
rm(list=c('EX')) #removing specific objects from workspace single objects
rm(list=c('EX','DM'))#removing specific objects from workspace for multiple objects
rm(list=ls(pattern="^IE_")) # removing all the objects starting(^ symbols denotes starting with) with letter pattern
rm(list=setdiff(ls(), "x")) #removing all the objects in workspace expect one object; 'x 'is the object
rm(list=setdiff(ls(), c("x","y"))) #same above but multiple objects
rm(list=setdiff(ls(pattern = "^edc_"), lsf.str()))# ^removing all the objects expect starting(^ symbols denotes starting with) with letter

#Note Handling files in R
#========================
#R gets confused if you use a path in your code like:
#c:\mydocuments\myfile.txt

#This is because R sees "\" as an escape character. Instead, use:
#c:\\my documents\\myfile.txt
#c:/mydocuments/myfile.txt

#Storing in RScript file and calling the script
#===============================================
#Step 1: Create an R Script
##FileName as add_numbers.R
add_numbers <- function(a, b) {
  a + b
}
print(add_numbers(10, 20))
#Step 2: Run the script with source file.
setwd("C:\\Users\\ganes\\Documents\\Kriyababa\\GitHub\\MyNotes\\R_Language\\2-Programming_Fundamentals\\script")
#add_numbers(10, 20) #Run Lines Interactively (Why It Worked Before)
source("add_numbers.R") # Run via source() 
#Rscript add_numbers.R #Running via terminal _not working
system("Rscript add_numbers.R") #advanced method  
#running from terminal 
Rscript add_numbers.R
#or you can create a batch file.
##open a notebod
#
#	@echo off
#	:: Replace the path below with your actual Rscript path if it's not in your PATH
#	Rscript "C:\path\to\your\script\your_script.R"
#	pause
#save it has run_my_analysis.bat
#If you want to save the output of your script to a text file instead of watching it in the console, use the redirection operator >:
Rscript your_script.R > log.txt 2>&1

#Quiz:
#=====

#Assignment:
#===========
#1) Write a regular function for adding the two number passing the value dynamically as a arguments
#2) Write a regular S3 Method for adding the two number passing the value dynamically as a arguments
#3) Write a regular S4 Method for adding the two number passing the value dynamically as a arguments
#4) Write a regular S4 Method for adding the two number passing the value dynamically as a arguments
#5) Wrap all the above code in add_all_methods.R and create a callerScript filename run_addition.R and call the callerscriptCode.

#Resources:
#=========
#https://www.statmethods.net/interface/workspace.html
