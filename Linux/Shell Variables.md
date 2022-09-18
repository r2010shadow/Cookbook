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
