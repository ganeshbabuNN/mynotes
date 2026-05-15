#Intro
#Packages in R
#Library in R
#Modules in R(Script)
#Namespaces in Packages
#Difference Between Package vs Library vs Module
#Quiz
#Assignment
#Resources

#Packages
#========
#A package is a collection of:
##Functions
##Datasets
##Documentation
##Compiled code

#It extends base R functionality.
#Think of a package like a toolbox.

#Official packages and modules
#https://cran.r-project.org/web/packages/
#The basic information about a package is provided in the DESCRIPTION file, 
#where you can find out what the package does, who the author is, what version the documentation belongs to, the date, the type of license its use, and the package dependencies

#Get all packages currently loaded in the R environment
#When we execute the below code, it produces the following result. It may vary depending on the local settings of your pc.
search()

#To check what packages are installed on your computer, you can use:
installed.packages()

#Uninstalling a package is straightforward with the function remove.packages(), in your case:
remove.packages("vioplot")

#You can check what packages need an update with a call to the function:
old.packages()

#You can update all packages by using:
update.packages()

#But for a specific package, just use once again:
install.packages("vioplot")

#Install a New Package
#---------------------
#There is something called repository where Packages are located so you can install from it.
#Three of the most popular repositories for R packages are:
##CRAN:the official repository, it is a network of ftp and web servers maintained by the R community around the world
##Bioconductor:this is a topic specific repository, intended for open source software for bioinformatics. 
#As CRAN, it has its own submission and review processes, and its community is very active having several conferences and meetings per year
#Github:although this is not R specific, Github is probably the most popular repository for open source projects. 
#Its popularity comes from the unlimited space for open source, the integration with git, a version control software

#There are two ways to add new R packages. 
#One is installing directly from the CRAN directory and another is downloading the package to your local system and installing it manually.

#Install directly from CRAN
#--------------------------
#The following command gets the packages directly from CRAN webpage and installs the package in the R environment
#You may be prompted to choose a nearest mirror. Choose the one appropriate to your location.

install.packages("Package Name")
 
# Install the package named "XML".
 install.packages("XML")


#install directly to custom path
#-------------------------------
#to install the package in custom path
install.packages("nycflights23",lib="C:\\Users\\ganes\\Documents\\R_lib")
#to add the cutom path in .libpath()
.libPaths(c("C:\\Users\\ganes\\Documents\\R_lib",.libPaths())) 
#to check
.libPaths() 
#load the library
library(nycflights23)


#Manual Installation from Source (.tar.gz or .zip)
#--------------------------------------------------
#Sometimes you need a specific version of a package, or you're on a machine with no internet access.
#Go to the link R Packages to download the package needed. 
#https://cran.r-project.org/web/packages/available_packages_by_name.html

#Save the package as a .zip file(for windows) or tar (for linux or mac)in a suitable location in the local system.
#Now you can run the following command to install this package in the R environment.
 install.packages(file_name_with_path, repos = NULL, type = "source")

# Install the package named "XML"
install.packages("E:/XML_3.98-1.3.zip", repos = NULL, type = "source")

#Installation via Terminal/Command Line
#---------------------------------------
#If you aren't inside an R session and want to install it directly from your computer's terminal:
#Windows: Open Command Prompt and type:
Rscript -e "install.packages('reshape2')"
#Mac/Linux: Open Terminal and type:
R -e "install.packages('reshape2')"

#install the package is not available using require()
#---------------------------------------------------
if (!require(reshape2)){ 
install.packages('reshape2')
library(reshape2)
}

#de-install the Packages
#------------------------
# Check which packages are currently loaded
pacman::p_loaded()

#detach() functions
#The detach() function is your go-to tool for unloading packages. 
detach("package:package_name", unload=TRUE)
detach("package:nycflights13", unload=TRUE)

#for multiple packages
# Create a character vector containing the names of the packages to be detached
packages <- c("ggplot2", "dplyr")
# Detach each package from the search path
for (pkg in packages) {
  detach(paste0("package:", pkg), character.only = TRUE)
}
# Unload all currently loaded packages using pacman
pacman::p_unload(pacman::p_loaded(), character.only = TRUE)

#Base Packages (Loaded Automatically)
#-----------------------------------
#Package-->Purpose
#base-->Core R functions
#stats-->Statistical functions
#utils-->Utility functions
#graphics-->Basic plotting
#grDevices-->Graphics devices
#methods	OOP-->(S4 system)
#datasets-->Built-in datasets

#Recommended Packages (Installed but not auto-loaded)
#Package-->Use
#MASS-->Statistical methods
#Matrix-->Matrix computations
#survival-->Survival analysis
#nlme-->Mixed models
#mgcv-->GAM models
#lattice-->Advanced plotting

#Mostly Used Packages in SDTM / ADaM World
#Now coming to your clinical programming domain.
#In SDTM/ADaM, the focus is:
##Data manipulation
##Metadata handling
##Validation
##Reporting
##Define.xml generation
##Submission-ready datasets

#Library in R
#============
#A library is a directory (folder) on your system where packages are stored.
#It is NOT the same as a package.

#When you run:
library(dplyr)
#You are loading the package from a library location.

#Check Available R Packages. Get library locations containing R packages
When we execute the above code, it produces the following result. It may vary depending on the local settings of your pc.
.libPaths()
#These are library folders.
#in R studio , you can see in the  packages panel

#Get the list of all the packages installed
library()

#A package is loaded using the following command −
library("package Name", lib.loc = "path to library")

#Install package to specific library
install.packages("data.table", lib="C:/MyCustomLibrary")

#Load the package named "XML"
install.packages("E:/XML_3.98-1.3.zip", repos = NULL, type = "source")

#Modules in R(Script)
====================
#R does not have a formal "module" system like Python.
#But conceptually, a module in R means:
##A script file (.R)
##A group of related functions
##Or a package acting as modular code
 
#Ex1: Script as Module
##Create file: math_functions.R
add_numbers <- function(x, y) {
  return(x + y)
}

square_number <- function(x) {
  return(x^2)
}

#Use it in another script:
source("math_functions.R")
add_numbers(5, 10)
square_number(5)
 
#Namespaces in Packages
#----------------------
#Each package has a namespace to avoid conflicts.

dplyr::filter()
stats::filter()

Here :: specifies which package (namespace).
 
#Difference Between Package vs Library vs Module
#-----------------------------------------------
#Concept-->Meaning-->Example
#Package-->Collection of functions-->dplyr
#Library-->Folder storing packages-->win-library/4.3
#Module-->Script/group of functions-->source("file.R")

Quiz:
=====

Assignment:
===========

Resources
=========
https://intro2r.com/dir-struct.html
https://wahani.github.io/modules/
https://www.datacamp.com/community/tutorials/r-packages-guide
https://www.tutorialspoint.com/r/r_packages.htm
