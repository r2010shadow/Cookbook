Unix/Linux上常见的Shell脚本解释器有bash、sh、csh、ksh等，习惯上把它们称作一种Shell。我们常说有多少种Shell，其实说的是Shell脚本解释器。

bash

**bash**

自由软件基金会(GNU)开发的一个Shell，它是Linux系统中一个默认的Shell。Bash不但与Bourne Shell兼容，还继承了C Shell、Korn Shell等优点。

是Linux标准默认的shell，本教程也基于bash讲解。bash由Brian Fox和Chet Ramey共同完成，是BourneAgain Shell的缩写，内部命令一共有40个。

Linux使用它作为默认的shell是因为它有诸如以下的特色：

可以使用类似DOS下面的doskey的功能，用方向键查阅和快速输入并修改命令。

自动通过查找匹配的方式给出以某字符串开头的命令。

包含了自身的帮助功能，你只要在提示符下面键入help就可以得到相关的帮助。

**sh** 

AT&T Bell实验室的 Steven Bourne为AT&T的Unix开发的，它是Unix的默认Shell，也是其它Shell的开发基础。Bourne Shell在编程方面相当优秀，但在处理与用户的交互方面不如其它几种Shell。

由Steve Bourne开发，是Bourne Shell的缩写，sh 是Unix 标准默认的shell。

ash shell 是由Kenneth Almquist编写的，Linux中占用系统资源最少的一个小shell，它只包含24个内部命令，因而使用起来很不方便。

**csh** 

加州伯克利大学的Bill Joy为BSD Unix开发的，与sh不同，它的语法与C语言很相似。它提供了Bourne Shell所不能处理的用户交互特征，如命令补全、命令别名、历史命令替换等。但是，C Shell与BourneShell并不兼容。

是Linux比较大的内核，它由以William Joy为代表的共计47位作者编成，共有52个内部命令。该shell其实是指向/bin/tcsh这样的一个shell，也就是说，csh其实就是tcsh。

ksh

**ksh** 

AT&T Bell实验室的David Korn开发的，它集合了C Shell和Bourne Shell的优点，并且与Bourne Shell向下完全兼容。Korn Shell的效率很高，其命令交互界面和编程交互界面都很好。

是Korn shell的缩写，由Eric Gisin编写，共有42条内部命令。该shell最大的优点是几乎和商业发行版的ksh完全兼容，这样就可以在不用花钱购买商业版本的情况下尝试商业版本的性能了。

注意：bash是 Bourne Again Shell 的缩写，是linux标准的默认shell ，它基于Bourne shell，吸收了C  shell和Korn shell的一些特性。bash完全兼容sh，也就是说，用sh写的脚本可以不加修改的在bash中执行。

## Startup Files and Variables

Students often reason that environment/shell variables disappear after logging  off, since they are stored in RAM, which is a most accurate deduction.  Their next statement is something like "isn't this a pain?", and again,  they are right on target. The workaround for this is using shell startup files to assign variables desired to maintain values between user  account logins (note this is a workaround, since RAM process space is  never saved after logging off). These startup files are also referred to as startup scripts, configuration files, or config files, which run at  login time.

Each shell variant has a predefined shell file(s) that is automatically  executed during the login sequence. The exact file names are specific to each shell flavor, and are listed below (recall these were introduced [here](http://homepages.uc.edu/~thomam/Intro_Unix_Text/Process.html#proc_startup)). A user can set environment variables in these files and these variables will be defined for every login, appearing as they don't go away. The  shell runs the files such that the variables are globally exported.  Note, each of these files are hidden files.





| shell | startup file name              |
| ----- | ------------------------------ |
| sh    | **.**profile                   |
| ksh   | **.**profile                   |
| csh   | **.**cshrc                     |
| bash  | **.**bash_profile  **.**bashrc |



An example of this is a modification to the PATH variable that is set for each login. This might look something like:

```
	$ PATH=$PATH:/home/mthomas/bin
```

which would append the /home/mthomas/bin directory to the end of the existing PATH variable.

```
$TEST="Unix Programming"
$echo $TEST
```

- /etc/profile
- 

## Setting the PATH

```
$PATH = /bin:/usr/bin
```

|  S   |        Environment Variables  Variable & Description         |
| :--: | :----------------------------------------------------------: |
|  1   | **DISPLAY**Contains the identifier for the display that **X11** programs should use by default. |
|  2   | **HOME**Indicates the home directory of the current user: the default argument for the cd **built-in** command. |
|  3   | **IFS**Indicates the **Internal Field Separator** that is used by the parser for word splitting after expansion. |
|  4   | **LANG**LANG expands to the default system locale; LC_ALL can be used to override this. For example, if its value is **pt_BR**, then the language is set to (Brazilian) Portuguese and the locale to Brazil. |
|  5   | **LD_LIBRARY_PATH**A Unix system with a dynamic linker, contains a colonseparated list of  directories that the dynamic linker should search for shared objects  when building a process image after exec, before searching in any other  directories. |
|  6   | **PATH**Indicates the search path for commands. It is a colon-separated list of directories in which the shell looks for commands. |
|  7   | **PWD**Indicates the current working directory as set by the cd command. |
|  8   | **RANDOM**Generates a random integer between 0 and 32,767 each time it is referenced. |
|  9   | **SHLVL**Increments by one each time an instance of bash is started. This variable is  useful for determining whether the built-in exit command ends the  current session. |
|  10  |             **TERM**Refers to the display type.              |
|  11  | **TZ**Refers to Time zone. It can take values like GMT, AST, etc. |
|  12  | **UID**Expands to the numeric user ID of the current user, initialized at the shell startup. |

