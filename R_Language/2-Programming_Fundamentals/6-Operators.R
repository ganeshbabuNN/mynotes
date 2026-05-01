#Intro
#Type of operators
#Operator Precedence and associativity(Order of Execution)
#Operator Overloading and Overriding
#Quiz
#Assignment
#Resources

#Intro
#=====
#-The operator can be defined as a symbol which is responsible for a particular operation between two operands.
#-An operator is a symbol which tells the compiler to perform specific logical or mathematical manipulations
#-R programming is very rich in built-in operators
#Operators are used to perform operations on variables and values.

#Type of operators
#==================
#Arithmetic operators
#Assignment Operators
#Relational operators
#Logical Operators
#Special Operators
#Special Infix Operators
#Subsetting Operators
#Tidyverse Logical Helpers
#Bitwise Operators 


#Arithmetic operators 
#--------------------
#Definations :Operators used to perform mathematical calculations.
#purpose: To manipulate numeric data.
#Arithmetic operators are used to perform arithmetic operations between two operands.
#+ ( addition) 
#- (Subractions)
#* (Multiplication)
#/ (Division)
#^ or ** (Power)
#+/- uniary addition/subraction


#+ ( addition) 
5+3
#- (Subractions)
5-3
#* (Multiplication)
5*3
#/ (Division)
5/2
#^ or ** (Power)
2^3
#+/- uniary addition/subraction
x <- c(1,-2,3)
-x #unary - The unary minus is used to negate a value
+x #unary + The unary plus is less commonly used because it does not change the value of its operand. In R, it exists primarily for mathematical symmetry and completeness

#Real-World Example
basic <- 40000
hra <- 0.2 * basic
gross_salary <- basic + hra

#Common Mistakes
##Using ^ expecting XOR (it is exponent)
##Integer division confusion (%/% vs /)

#Best Practices
##Use %/% for integer division
##Use parentheses for clarity

#h. When to Use / Not Use
##Use for numeric computation
##Do not use on character data

#Assignment Operators
#--------------------
##Used to assign values to variables.

#<- = left assignment(preferred)
#= (Assignment)
#->(right assignment)
#<<- global assignment

#<- = left assignment(preferred)
x<-10
x
#= (Assignment)
x=10
#->(right assignment)
10->x
#<<- global assignment
x<<-10
x
#Note: Use <- in professional R coding

#Real-World Example
model_accuracy <- 0.89

#Common Mistakes
#Using = inconsistently
#Using <<- unintentionally

#Best Practices
##Prefer <- in scripts
##Avoid <<- unless scoping is understood

#When to Use / Not Use
##Use <- in production code
##Avoid <<- in shared codebases
 
#Relational operators
#--------------------
##Compare two values and return TRUE or FALSE.
##purpose - Decision Making
#-A relational operator is a symbol which defines some kind of relation between two entities

#== (equal to)
#!= (not equal)
#> (Greater than) 
#< (Less than)
#>= (Greater or equal)
#<=(less or equal)

#== (equal to)
5==5
#!= (not equal)
5!=3
#> (Greater than) 
5>3
#< (Less than)
5<3
#>= (Greater or equal)
5>=5
#<=(less or equal)
3<=5

#Use case: filtering data, conditions in if, filter().
age <- 25
age >= 18
#Real-World Example
purchase_amount > 5000

#Common Mistakes
##Using = instead of ==
##Comparing floating point numbers directly

#Best Practices
##Use all.equal() for numeric comparison
#Why all.equal()
(0.1+0.2)==0.3
#the system calculates internall the base 10  int their binary system base2. 0.30000000000000000000000044
all.equal((0.1+0.2),0.3)

#When to Use / Not Use
##Use in conditions
##Do not compare NA directly

#Logical Operators
#-----------------
##Used to combine conditions.
##Combine or negate logical conditions.
##Control flow and filtering.

#&(and)			This operator is known as the Element-wise Logical AND operator. This operator takes the first element of both the vector and returns TRUE if both the elements are TRUE.	 
#|(or)			This operator is called the Element-wiseLogical OR operator. This operator takes the first element of both the vector and returns TRUE if one of them is TRUE.	 
#!(not)			This operator is known as Element-wise Logical NOT operator. This operator takes the first element of the vector and gives the opposite logical value as a result.	
#&&			    called as short-circuit AND operator.This operator takes the first element of both the vector and gives TRUE as a result, only if both are TRUE.		
#|| 			called short-cuircuit OR operator.This operator takes the first element of both the vector and gives the result TRUE, if one of them is true.
#EXOR     
#EXNOR 

#the short-circuit works on scalar, normal logical works on vectors

v1<- c(TRUE,FALSE,TRUE)
v2<- c(TRUE,TRUE,FALSE)

#& AND(Vector-wise)
TRUE & TRUE
TRUE & FALSE
FALSE & TRUE
FALSE & FALSE
v1 & v2

#|(OR)
TRUE & TRUE
TRUE & FALSE
FALSE & TRUE
FALSE & FALSE
v1 & v2

#'(')
c(TRUE,FALSE)

#!(NOT)
!TRUE
!v1


#&& AND short-circuit
TRUE&&FALSE
v1 && v2 #it does not work on vector

# || OR short-circuit
TRUE||FALSE
v1 || v2 #it does not work on vector

#EXOR(Exclusive OR) returns TRUe only if two inputs are different. if both are same
#it returns false
#XOR oper
xor(TRUE , TRUE )
xor(TRUE , FALSE )
xor(FALSE , TRUE )
xor(FALSE , FALSE )

#EXNOR(Exclusive NOR) returns TRUE only if two inputs are same, if both are different
#it returns false. NOte there is no operators for EXNOR in R.
#XAND oper
!xor(TRUE , TRUE )
!xor(TRUE , FALSE )
!xor(FALSE , TRUE )
!xor(FALSE , FALSE )

#Difference:
#& and | -->element-wise for vectors
#&& and || --> it works only on scalar not vectorized operations.

x <- c(5, 10, 15)
x > 6 & x < 14

#Control flow and filtering.
age >= 18 & income > 300000

#Common Mistakes
##Using && for vectors
##Ignoring NA propagation

#Best Practices
##Use & for vectors
##Use && for if conditions

#When to Use / Not Use
##Use logical operators for filters
##Avoid mixing scalar and vector logic incorrectly

#Special Operators
------------------
#Sequence operator :
1:5

#formulae Operators(~= tidle)
#We’ll test if the weight of a car (wt) can predict its fuel efficiency (mpg).
#In this case, the formula is mpg ~ wt (Miles per gallon is modeled by weight).

#1. Fit the linear model (~ = tidle)
model <- lm(mpg ~ wt, data = mtcars)

#2. View the results
summary(model)
##When you look at the output of summary(model), 
##the formula operator helps define two key components of the linear equation $y = mx + b$:
##The Intercept ($b$): The predicted value of mpg if wt was 0.The Slope ($m$): 
##Found under the name wt. This tells you how much mpg changes for every 1-unit increase in 

#Special Infix Operators
#-----------------------
#Pipe Operator %>% 
##Used to chain functions together, passing the result of the left side as the first argument to the function on the right.
##It makes code much more readable by following a left-to-right logic rather than nested parentheses.
##Pass output as input.
library(dplyr)
library(magrittr)
student_data %>% select(student_id,student_name,student_age) %>% filter(student_age > 18 & student_age<40)
##Use case: clean, readable data pipelines.
##Real-World
###Readable data pipelines

#Nave Pip |> : 
##offical version of R not part of the magrittr package,Works in Base R (version 4.1+).
##You want your code to run as fast as possible
##You want to avoid loading extra packages
##you like clean, modern R syntax.
flights |> filter(month == 1) |> head()

#The Value Matching Operator (%in%) or membership operator
##Checks if elements of the left vector exist anywhere in the right vector. It returns a logical vector (TRUE or FALSE).
5 %in% c(1, 3, 5, 7)
##Real-World
dept<-"HR"
dept %in% c("Finance", "HR")

#Matrix Multiplication %*%
##Standard arithmetic * performs element-wise multiplication. 
##To perform actual linear algebra matrix multiplication, you must use %*%.
A <- matrix(c(1,2,3,4), nrow=2)
B <- matrix(c(5,6,7,8), nrow=2)
A %*% B

#Integer Division (%/%) 
##Integer Division (%/%): Returns only the Quotient.
10 %/% 3  #Returns 3

#Modulo (%%)
##Modulo (%%): Returns only the remainder.
10 %% 3   #Returns 1

#Custom Infix Operators
##Domain-specific readability.
`%profit%` <- function(cost, price) price - cost

#Subsetting Operators 
#---------------------
#[] ==Extact multiple elements
#[[]]== extract single element of vectors
#$ = Access column 


#[] ==Extact multiple elements#
a <- c("1","4","5","1",3)
a[1] #single index
a[c(1,2)] #mutliple index
a[1:3] # sequence operator


#[[]]== extract single element
student_data <- data.frame(
  student_id = c(14:19),
  student_name=c("ganesh","roopa","hari","swati","rudresh","vani"),
  student_gender=c("M","F","M","F","M","F"),
  student_age =c(32,44,34,56,34,23),
  student_class= c("MCA","BCA","BTECH","BE",NA,"MSC"),
  student_join=as.Date(c("2021-01-20","2022-01-22","2000-03-18","2012-01-11","2022-01-14","2000-03-24")),
  stringsAsFactors = FALSE
)

a <- list(1,"Ganesh",TRUE,3.3,5L,0+3i,as.Date("2025-01-01"),NULL,NA,c(3,2,4,3),student_data)
a
a[3]
a[[3]]
a
a[11]
a[[11]]
a[[11]][2]
a[[11]][2]
a[[11]]$student_name

#$ = Access column
student_data$student_id

#Tidyverse Logical Helpers
#-------------------------
##Used inside filter():
#is.na(x) --> check missing
#between(x,a,b)-->Range

#is.na(x) --> check missing
student_data %>% filter(is.na(student_data$student_class))
#between(x,a,b)-->Range
student_data %>% filter(between(student_age, 20, 30))

#Bitwise Operators
#-----------------
##Operate at binary level.
#xor() -->(XOR)
#bitwAnd()-->Bitwise AND
#bitwOr()-->Bitwise OR
#bitwShiftL()-->Left shift

bitwAnd(5, 3)   #101 & 011 -->001--> 1 #i shall skip this as it is involved more binary
bitwOr(5, 3)   
bitwShiftL(5, 3)
bitwXor(5,3)

#Use Case
##Low-level optimization, flags.

#Real world mapping table
#------------------------
#concept --> Real_world use case --> industry example
#Arithmetic --> finanical calculation --> payrol system
#logical --> eligibility rules --> banking
#%in% --> cateogry filtering --> marketting
#pipe --> data piplines --> data scienc
#subsetting --> column access --> reporting
#bitwsie --> flags --> embedeed systems.

#Operator Precedence and associativity(Order of Execution)
#=========================================
#Operator precedence decides which operation is evaluated first when multiple operators appear in a single expression.
#If you do not use parentheses (), R follows a fixed priority order.

#Why Operator Precedence Matters  
5 + 2 * 3 #if evaluated left to rigth.

#But R follows precedence:
5 + (2 * 3) #So multiplication happens before addition.

#General Precedence Rules (High → Low)
#-------------------------------------
#Ref : https://search.r-project.org/R/refmans/base/html/Syntax.html
#Operator --> Category
#-----------------------

#:: :::	--> access variables in a namespace
#$ @	--> component / slot extraction
#[ [[	--> indexing
#^		--> exponentiation (right to left)
#- +	--> unary minus and plus(?Right-to-Left )
#:		--> sequence operator
#%any% |>	--> special operators (including %% and %/%)
#* /	--> multiply, divide
#+ -	--> (binary) add, subtract
#< > <= >= == !=	--> ordering and comparison
#!	--> negation
#& &&	--> logical AND, Shortcurcuit AND
#| ||	--> logical OR, Shortcurcuit OR
#~	--> as in formulae (Right-to-Left)
#-> ->>	--> rightwards assignment (?Right-to-Left )
#<- <<-	--> assignment (?right to left)
#=	--> assignment (right to left)
#?	--> help (unary and binary)

##Higher priority operators are evaluated first.

#Operator Associativity in R
#-----------------------------
#Operator associativity defines the direction in which operators of the same precedence are evaluated when they appear together without parentheses.
#In simple words ,When two or more operators have the same priority, associativity decides whether evaluation happens left-to-right or right-to-left.
  
#Operator Precedence vs Associativity (Important Difference)
#-----------------------------------------------------
#Concept	Decides
#Precedence=	Which operator is evaluated first
#Associativity=Direction of evaluation when precedence is the same

#Main Associativity Rules in R
------------------------------
#R operators follow two associativity directions:
##Left-to-Right Associativity
##Right-to-Left Associativity

#Left-to-Right Associations (Most Operators)
#---------------------------------------------
#If operators are left-associative, R evaluates them from left to right.
#Common Left-Associative Operators

#Operator Type	Operators
#-----------------------
#Arithmetic--> + - * / %% %/%
#Relational-->	< <= > >= == !=
#Logical--> `&
#Sequence-->	:
#Pipe--> %>% 
#Indexing--> [

#Example 1: Arithmetic
10 - 5 - 2
#Evaluation:
#(10 - 5) - 2
#= 5 - 2
#= 3

#Example 2: Division
#20 / 5 / 2

#Evaluation:
  
#(20 / 5) / 2
#= 4 / 2
#= 2

#Example 3: Logical
TRUE & FALSE & TRUE

#Evaluation:
#(TRUE & FALSE) & TRUE
#= FALSE & TRUE
#= FALSE

#Example 4: Relational
5 < 10 < 20

#Evaluation:
#(5 < 10) < 20
TRUE < 20
1 < 20
TRUE
#Logical mistake
#This does not mean “5 is less than 10 and 10 is less than 20”.
#Correct way:
#5 < 10 & 10 < 20

#Right-to-Left Associativity (Special Operators)
-----------------------------
#If operators are right-associative, R evaluates them from right to left.
#Common Right-Associative Operators
#Operator Type -->	Operators
#Exponentiation--> 	^
#Assignment-->	<- -> = <<-
#Unary-->	+ - !
#Formula-->	~
  
#Exponentiation ^ (Right-Associative)
2 ^ 3 ^ 2
#Evaluation:
#2 ^ (3 ^ 2)
#= 2 ^ 9
#= 512

#If it were left-associative:
#(2 ^ 3) ^ 2 = 64
#But R gives 512.

#Assignment Operators (Right-to-Left)
a <- b <- c <- 10
#Evaluation: 
c <- 10
b <- c
a <- b
#Result:
a
b
c
#all are 10

#Mixed Assignment
10 -> x -> y
#Evaluation:
#y <- (x <- 10)

#Unary Operators (Right-Associative)
! ! TRUE
#Evaluation:
#!(!TRUE)
#= !FALSE
#= TRUE
#- - 5
#Evaluation:
#-(-5)
#= 5

#Sequence Operator : (Left-Associative but Tricky)
1:3:5

#Evaluation:
#(1:3):5

#But:
#1:3 --> c(1,2,3)
#This becomes invalid and causes confusion.
#Always use parentheses:
1:(3:5)

#Associativity with Operator Precedence Together
5 + 2^3^2

#Step-by-step:
#^ has higher precedence
#^ is right-associative
2^(3^2) = 2^9 = 512
5 + 512 = 517

#Associativity in Logical Expressions
TRUE | FALSE & FALSE

#& has higher precedence
#& is left-associative

TRUE | (FALSE & FALSE)
TRUE | FALSE
TRUE

#Associativity in Comparisons (Very Important Trap)
10 > 5 == 1

#Evaluation:
(10 > 5) == 1
TRUE == 1
TRUE
#Correct logic:
(10 > 5) & (5 == 1)

#Best Practices (Very Important)
#Never rely on associativity for clarity
#Always use parentheses for:
##Comparisons
##Logical expressions
##Exponentiation chains
##Sequence creation

#One-Line Memory Rule
#Same precedence → associativity decides direction
#Most operators are left-associative
#Exponent (^) and assignment (<-) are right-associative

#Final Takeway
#Associativity controls evaluation direction, not priority
#R mostly evaluates left to right
#^ and assignments go right to left
#Comparison chains can produce logical bugs
#Parentheses remove ambiguity and improve readability

#Now lets geting into eah operator precedence remember the assocativatity
#------------------------------------------------------------------------
#Parentheses () – Highest Priority

#Anything inside parentheses is executed first.
(5 + 2) * 3
#Without parentheses:
5 + 2 * 3 #Always use parentheses when logic must be explicit

#Exponentiation
---------------
#Power is evaluated before multiplication and addition.
2 + 3^2
#the above equivalent to Equivalent to:
2 + (3^2)
#But
(2 + 3)^2

#Multiplication / Division vs Addition / Subtraction
----------------------------------------------------
10 + 6 / 3

#Step-by-step:
#6 / 3 = 2
#10 + 2 = 12

#Another
20 - 4 * 3
#4*3=12
#20-12=8

#Sequence Operator
#-----------------
#The : operator has lower precedence than arithmetic, but higher than comparisons.
1:5 + 1
#Interpreted as:
(1:5) + 1
#But
1:(5 + 1) #Many beginners make mistakes here. Use parentheses for clarity.

#Relational Operators (> < == != <= >=)
---------------------------------------
#Evaluated after arithmetic but before logical operators.
5 + 2 > 6
#Step-by-step:
#5 + 2 = 7
#7 > 6 = TRUE

#Logical Operators:(!, &, |)
---------------------------
#! (Logical NOT)
##Highest among logical operators.
!TRUE == FALSE
##Interpreted as:
(!TRUE) == FALSE

# & -(logical AND)
TRUE&FALSE
FALSE&TRUE
FALSE&FALSE
TRUE&TRUE

!TRUE&TRUE

# |-(logical OR)
TRUE|FALSE
FALSE|TRUE
FALSE|FALSE
TRUE|TRUE

# & vs | (Vectorized)
TRUE | FALSE & FALSE #Precedence: & before |
Step-by-step:
FALSE & FALSE = FALSE
TRUE | FALSE = TRUE

#Assignment <- Happens Late
x <- 5 + 3 * 2
x
##Step-by-step:
##3 * 2 = 6
##5 + 6 = 11
##x <- 11

#Short cricut operator (&&, ||)
#it generally works on scalar not on vector
#&& (Logical AND)
#If the first condition is FALSE, it returns FALSE immediately without looking at the second condition.
v1 <- c(TRUE, FALSE, TRUE)
v2 <- c(TRUE, TRUE, FALSE)

v1 & v2   # Returns: TRUE FALSE FALSE (Checks every pair)
v1 && v2  # Returns: TRUE (Only checks the first pair: TRUE && TRUE)
v1[1] && v2[1] #works only on scalar not vector

#&& (Logical AND)
#If the first condition is TRUE, it returns TRUE immediately.
v1 | v2   # Returns: TRUE FALSE FALSE (Checks every pair)
v1 || v2  # Returns: TRUE (Only checks the first pair: TRUE && TRUE)
v1[1] && v2[1] #works only on scalar not vector

#difference between Logical and shorcuit operator are 
##logical operator will Compares every element in two vectors.
##whereas the short cricut operator compare first pari

#Combined Expression Walkthrough
-------------------------------
result <- 5 + 2^3 * 4 > 20 & !FALSE

#Step-by-step execution order:
#Exponent: 2^3 = 8
#Multiplication: 8 * 4 = 32
#Addition: 5 + 32 = 37
#Relational: 37 > 20 = TRUE
#Logical NOT: !FALSE = TRUE
#Logical AND: TRUE & TRUE = TRUE
#Assignment: result <- TRUE

#Precedence in Data Filtering (Real Example)
--------------------------------------------
df <- data.frame(
    age = c(18, 22, 30, 15),
    salary = c(20000, 30000, 50000, 15000)
)
df$age >= 18 & df$salary > 25000
#Execution:
#Comparisons first:
#df$age >= 18 → TRUE TRUE TRUE FALSE
#df$salary > 25000 → FALSE TRUE TRUE FALSE

#Logical AND:
#TRUE & FALSE = FALSE
#TRUE & TRUE = TRUE
#TRUE & TRUE = TRUE
#FALSE & FALSE = FALSE

#Common Mistakes
---------------
#Mistake 1: Forgetting parentheses
1:3*2
#Interpreted as:
#1:(3*2) -> 1:6
#Correct
(1:3)*2

#Mistake 2: Logical order confusion
TRUE | FALSE & FALSE
#Not left-to-right. It becomes:
TRUE | (FALSE & FALSE)

#Best Practice
--------------
#Always use parentheses when:
#Writing complex expressions
#Combining arithmetic + logical
#Creating sequences
(df$age >= 18) & (df$salary > 25000)

#One-Line Summary
----------------
#() -> ^ -> * / -> + -  -> : -> comparisons -> !-> & -> | -> && -> || -> assignment
  

5+3+4^2*3
5+3+16*3
5+3+48
56


#Operator Overloading and Overriding
#====================================
#Genearlly few languages supports operator overloading and overriding.

##using number
#a <- 3
#b <- 3
#a+b #its overides

##using string
#a <-"ganesh"
#b <- "babu"
#a|b #it does not allow overloads as it allows only numeric not string where it other languages it overloads

##using list
#l1 <- list(1,2,3,4,5)
#l2 <- list(6,7,8,9,10)
#l1+l2 #it does not allow overloads as it allows only numeric not string where it other languages it overloadsprint(s1)

#Quiz
#=====

#Assignment:
#===========
#ASSIGNMENTS ON OPERATORS IN R
#ASSIGNMENT 1: Arithmetic Operators
#Q1
#Predict the output:
10 + 4 * 2
#Q2
(10 + 4) * 2
#Q3
25 / 5 + 3^2
#Q4
17 %% 5
#Q5
17 %/% 5
#ASSIGNMENT 2: Relational (Comparison) Operators
#Q6
5 > 3
#Q7
5 == "5"
#Q8
10 != 8
#Q9
3 <= 2
#Q10
"R" < "r"
#ASSIGNMENT 3: Logical Operators
#Q11
TRUE & FALSE
#Q12
TRUE | FALSE
#Q13
!TRUE
#Q14
TRUE | FALSE & FALSE
#Q15
c(TRUE, FALSE) & c(FALSE, TRUE)
#ASSIGNMENT 4: Logical (& vs &&, | vs ||)
#Q16
c(TRUE, FALSE) && c(TRUE, TRUE)
#Q17
c(TRUE, FALSE) & c(TRUE, TRUE)
#Q18
FALSE || TRUE
#ASSIGNMENT 5: Assignment Operators
#Q19
x <- 5 + 2 * 3
x
#Q20
10 -> y
y
#Q21
z = 5
z
#ASSIGNMENT 6: Special Operators
Q22
1:5 + 1
#Q23
1:(5 + 1)
#Q24
5 %in% c(1, 3, 5, 7)
#Q25
c(2, 4, 6) %/% 4
#ASSIGNMENT 7: Vectorized Operators
#Q26
x <- c(10, 20, 30)
x + 5
#Q27
x * 2
#Q28
x > 15
#ASSIGNMENT 8: Operator Precedence
#Q29
5 + 2^3 * 4
#Q30
(5 + 2)^3 * 4
#Q31
TRUE | TRUE & FALSE
#Q32
!TRUE == FALSE
#ASSIGNMENT 9: Type Coercion + Operators
#Q33
TRUE + TRUE
#Q34
"10" + 5
#Q35
"10" == 10
#ASSIGNMENT 10: Data Frame + Operators (Real-World)
df <- data.frame(
  age = c(16, 22, 30, 15),
  salary = c(20000, 30000, 50000, 15000)
)
#Q36
df$age >= 18
#Q37
df$salary > 25000
#Q38
df$age >= 18 & df$salary > 25000
#ASSIGNMENT 11: Tricky / Interview-Level
#Q39
1:3 * 2 + 1
#Q40
(1:3) * (2 + 1)
#Q41
5 > 4 == 1
#Q42
FALSE | TRUE & TRUE | FALSE
#OPTIONAL TASKS (Write Code)
#Q43
#Write code to check if a number is even or odd using operators only.
#Q44
#Create a vector and use operators to:
#Identify values greater than 50
#Replace them with "High" and others with "Low"
#Q45
#Using operators, calculate BMI:
#BMI = weight / (height^2)

#predence
#---------
#Assignment 1: Basic Arithmetic Precedence
#Q1
5 + 2 * 3
#Q2
(5 + 2) * 3
#Q3
10 - 4 / 2
#Q4
2^3 + 4
#Q5
2^(3 + 4)
#Assignment 2: Sequence : vs Arithmetic
#Q6
1:5 + 2
#Q7
1:(5 + 2)
#Q8
(1:5) * 2
#Q9
1:3 * 2
#Q10
(1:3) * (2 + 1)
#Assignment 3: Relational vs Arithmetic
#Q11
5 + 3 > 7
#Q12
5 + (3 > 7)
#Q13
10 - 5 == 5
#Q14
10 - (5 == 5)
#Q15
8 / 4 >= 2
#Assignment 4: Logical Operator Precedence
#Q16
TRUE | FALSE & FALSE
#Q17
(TRUE | FALSE) & FALSE
#Q18
!TRUE == FALSE
#Q19
! (TRUE == FALSE)
#Q20
TRUE && FALSE | TRUE
#Assignment 5: Assignment with Precedence
#Q21
x <- 5 + 2 * 3
x
#Q22
y <- (5 + 2) * 3
y
#Q23
z <- 10 > 5 + 2
z
#Q24
a <- 10 > (5 + 2)
a
#Assignment 6: Vector & Data Examples
#Q25
x <- c(2, 4, 6)
x + 2 * 3
#Q26
x <- c(2, 4, 6)
(x + 2) * 3
#Q27
x <- c(10, 20, 30)
x > 15 & x < 30
#Q28
x <- c(10, 20, 30)
x > (15 & x < 30)
#Assignment 7: Tricky / Interview Level
#Q29
1:3 + 1:3 * 2
#Q30
(1:3 + 1:3) * 2
#Q31
5 > 4 == 1
#Q32
(5 > 4) == 1
#Q33
TRUE | TRUE & FALSE & FALSE

#Associativity
#---------
#Q1
2 ^ 3 ^ 2
#Q2
10 - 3 - 2
#Q3
5<6<7
#Q4
a <- b <- 5

#Resources:
#=========
#https://www.tutorialspoint.com/r/r_operators.htm
#https://www.w3adda.com/r-tutorial/r-operator-precedence
