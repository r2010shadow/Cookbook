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

