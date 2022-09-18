## Arithmetic Using Shell Variables

As mentioned at the beginning of this section, all shell variables are of  type string. This might lead one to conclude that arithmetic using shell variables is not possible because you can't do arithmetic on strings.  Not so fast! The standard tried and true way of doing arithmetic is  using the **expr** command. In general, expr is used as follows:

```
	expr operand1 operator operand2
```

Note the spaces on either side of the operator, 

these are mandatory and a source of frequent errors. Some of the possible operators include:

```
	addition	+
	subtraction	-
	multiplication	*			# must be written as \*, more here)
	division	/
	modulus		%
```

## Other Shell Variables

In general, there are 3 types of variables; standard variables, positional variables, and special shell variables. The discussion of variables to  this point has been about standard environment variables.

```

```

[root@localhost /]# cat > 1

\#!/bin/ksh

\# program name: hello

echo "I am program $0 and I have $# argument(s)."  

echo "Hello $*! How are you today?"

[root@localhost /]# sh 1 10 20 30I am program 1 and I have 3 argument(s).Hello 10 20 30! How are you today?

```

```

Special/Positional Variable Summary



| Variable | Description                                                  |
| -------- | ------------------------------------------------------------ |
| $*       | all parameters in the parameter list                         |
| $#       | the number of arguments passed into the shell program, in other words, the number of parameters in $* |
| $*n*     | the *nth*parameter in $*                                     |
| $0       | the name of the program being executed, i.e. the 0th parameter |
| $$       | the PID of the program being executed                        |
| $?       | the exit status of the last command executed                 |





```

```

## Command Summary



- echo

   \- display a line of text (including the contents of variables)

  

- env

   \- display the current environment (when used without a command)

  

- expr

   \- expression evaluation

  

- let

   \- alternative method for expression evaluation (see also let built-in and Arithmetic Expansion)

  

- parameter expansion

   \- see Parameter Expansion for ${parameter} syntax

  

- positional parameters

   \- description of the positional parameters, i.e. $*, $?, $#, etc.

  

- [unset](http://linux265.rwc.uc.edu/cgi-bin/htmlman?command=bash&flag=HTML#sect30) - unset the specified variable (or function)

## Special Variables

|  S   |                    Variable & Description                    |
| :--: | :----------------------------------------------------------: |
|  1   |          **$0**The filename of the current script.           |
|  2   | **$n**These variables correspond to the arguments with which a script was invoked. Here **n** is a positive decimal number corresponding to the position of an argument  (the first argument is $1, the second argument is $2, and so on). |
|  3   |     **$#**The number of arguments supplied to a script.      |
|  4   | **$\***All the arguments are double quoted. If a script receives two arguments, $* is equivalent to $1 $2. |
|  5   | **$@**All the arguments are individually double quoted. If a script receives two arguments, $@ is equivalent to $1 $2. |
|  6   |     **$?**The exit status of the last command executed.      |
|  7   | **$$**The process number of the current shell. For shell scripts, this is the process ID under which they are executing. |
|  8   |   **$!**The process number of the last background command.   |

[root@localhost ~]# cat > filename

\#!/bin/sh

echo "File Name: $0"

echo "First Parameter : $1"

echo "Second Parameter : $2"

echo "Quoted Values: $@"

echo "Quoted Values: $*"

echo "Total Number of Parameters : $#"

[root@localhost ~]# sh filename good 2017

File Name: filename

First Parameter : good

Second Parameter : 2017

Quoted Values: good 2017

Quoted Values: good 2017

Total Number of Parameters : 2

---

## Creating Functions



### Example

Following example shows the use of function −

```
#!/bin/sh

Hello () {
   echo "Hello World"
}

# Invoke your function
Hello
```



## Pass Parameters to a Function

You can define a function that will accept parameters while calling the function. These parameters would be represented by **$1**, **$2** and so on.

Following is an example where we pass two parameters *Zara* and *Ali* and then we capture and print these parameters in the function.

```
#!/bin/sh

# Define your function here
Hello () {
   echo "Hello World $1 $2"
}

# Invoke your function
Hello Zara Ali
```

Upon execution, you will receive the following result −

```
$./test.sh
Hello World Zara Ali
```

##  

## Returning Values from Functions

### Example

Following function returns a value 1 −

```
#!/bin/sh

# Define your function here
Hello () {
   echo "Hello World $1 $2"
   return 10
}

# Invoke your function
Hello Zara Ali

# Capture value returnd by last command
ret=$?

echo "Return value is $ret"
```



Upon execution, you will receive the following result −

```
$./test.sh
Hello World Zara Ali
Return value is 10
```

##  

## Nested Functions

One of the more interesting features of functions is that they can call  themselves and also other functions. A function that calls itself is  known as a***recursive function\***.

Following example demonstrates nesting of two functions −

```
#!/bin/sh

# Calling one function from another
number_one () {
   echo "This is the first function speaking..."
   number_two
}

number_two () {
   echo "This is now the second function speaking..."
}

# Calling function one.
number_one
```

Upon execution, you will receive the following result −

```
This is the first function speaking...
This is now the second function speaking...
```

##  


---


## Arithmetic Operators

|      Operator      |                         Description                          |                Example                |
| :----------------: | :----------------------------------------------------------: | :-----------------------------------: |
|    + (Addition)    |          Adds values on either side of the operator          |      `expr $a + $b` will give 30      |
|  - (Subtraction)   |     Subtracts right hand operand from left hand operand      |     `expr $a - $b` will give -10      |
| * (Multiplication) |       Multiplies values on either side of the operator       |     `expr $a \* $b` will give 200     |
|    / (Division)    |       Divides left hand operand by right hand operand        |      `expr $b / $a` will give 2       |
|    % (Modulus)     | Divides left hand operand by right hand operand and returns remainder |      `expr $b % $a` will give 0       |
|   = (Assignment)   |            Assigns right operand in left operand             | a = $b would assign value of b into a |
|   == (Equality)    |  Compares two numbers, if both are same then returns true.   |   [ $a == $b ] would return false.    |
| != (Not Equality)  | Compares two numbers, if both are different then returns true. |    [ $a != $b ] would return true.    |

## Relational Operators

| Operator |                         Description                          |          Example           |
| :------: | :----------------------------------------------------------: | :------------------------: |
| **-eq**  | Checks if the value of two operands are equal or not; if yes, then the condition becomes true. | [ $a -eq $b ] is not true. |
| **-ne**  | Checks if the value of two operands are equal or not; if values are not equal, then the condition becomes true. |   [ $a -ne $b ] is true.   |
| **-gt**  | Checks if the value of left operand is greater than the value of right operand; if yes, then the condition becomes true. | [ $a -gt $b ] is not true. |
| **-lt**  | Checks if the value of left operand is less than the value of right operand; if yes, then the condition becomes true. |   [ $a -lt $b ] is true.   |
| **-ge**  | Checks if the value of left operand is greater than or equal to the value of  right operand; if yes, then the condition becomes true. | [ $a -ge $b ] is not true. |
| **-le**  | Checks if the value of left operand is less than or equal to the value of  right operand; if yes, then the condition becomes true. |   [ $a -le $b ] is true.   |

## Boolean Operators

| Operator |                         Description                          |                Example                |
| :------: | :----------------------------------------------------------: | :-----------------------------------: |
|  **!**   | This is logical negation. This inverts a true condition into false and vice versa. |         [ ! false ] is true.          |
|  **-o**  | This is logical **OR**. If one of the operands is true, then the condition becomes true. | [ $a -lt 20 -o $b -gt 100 ] is true.  |
|  **-a**  | This is logical **AND**. If both the operands are true, then the condition becomes true otherwise false. | [ $a -lt 20 -a $b -gt 100 ] is false. |

## String Operators

| Operator |                         Description                          |         Example          |
| :------: | :----------------------------------------------------------: | :----------------------: |
|  **=**   | Checks if the value of two operands are equal or not; if yes, then the condition becomes true. | [ $a = $b ] is not true. |
|  **!=**  | Checks if the value of two operands are equal or not; if values are not equal then the condition becomes true. |  [ $a != $b ] is true.   |
|  **-z**  | Checks if the given string operand size is zero; if it is zero length, then it returns true. |  [ -z $a ] is not true.  |
|  **-n**  | Checks if the given string operand size is non-zero; if it is nonzero length, then it returns true. | [ -n $a ] is not false.  |
| **str**  | Checks if **str** is not the empty string; if it is empty, then it returns false. |   [ $a ] is not false.   |

## File Test Operators

|  Operator   |                         Description                          |          Example          |
| :---------: | :----------------------------------------------------------: | :-----------------------: |
| **-b file** | Checks if file is a block special file; if yes, then the condition becomes true. |  [ -b $file ] is false.   |
| **-c file** | Checks if file is a character special file; if yes, then the condition becomes true. |  [ -c $file ] is false.   |
| **-d file** | Checks if file is a directory; if yes, then the condition becomes true. | [ -d $file ] is not true. |
| **-f file** | Checks if file is an ordinary file as opposed to a directory or special file; if yes, then the condition becomes true. |   [ -f $file ] is true.   |
| **-g file** | Checks if file has its set group ID (SGID) bit set; if yes, then the condition becomes true. |  [ -g $file ] is false.   |
| **-k file** | Checks if file has its sticky bit set; if yes, then the condition becomes true. |  [ -k $file ] is false.   |
| **-p file** | Checks if file is a named pipe; if yes, then the condition becomes true. |  [ -p $file ] is false.   |
| **-t file** | Checks if file descriptor is open and associated with a terminal; if yes, then the condition becomes true. |  [ -t $file ] is false.   |
| **-u file** | Checks if file has its Set User ID (SUID) bit set; if yes, then the condition becomes true. |  [ -u $file ] is false.   |
| **-r file** | Checks if file is readable; if yes, then the condition becomes true. |   [ -r $file ] is true.   |
| **-w file** | Checks if file is writable; if yes, then the condition becomes true. |   [ -w $file ] is true.   |
| **-x file** | Checks if file is executable; if yes, then the condition becomes true. |   [ -x $file ] is true.   |
| **-s file** | Checks if file has size greater than 0; if yes, then condition becomes true. |   [ -s $file ] is true.   |
| **-e file** | Checks if file exists; is true even if file is a directory but exists. |   [ -e $file ] is true.   |

