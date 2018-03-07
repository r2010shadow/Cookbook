
## How to Install JAVA 8 (JDK/JRE 8u131) on CentOS/RHEL 7/6 and Fedora 25

For 64Bit
# cd /opt/
# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"

# tar xzf jdk-8u131-linux-x64.tar.gz
For 32Bit
# cd /opt/
# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-i586.tar.gz"

# tar xzf jdk-8u131-linux-i586.tar.gz
Install Java with Alternatives
After extracting archive file use alternatives command to install it. alternatives command is available in chkconfig package.

# cd /opt/jdk1.8.0_131/
# alternatives --install /usr/bin/java java /opt/jdk1.8.0_131/bin/java 2
# alternatives --config java


There are 3 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
*  1           /opt/jdk1.7.0_71/bin/java
 + 2           /opt/jdk1.8.0_45/bin/java
   3           /opt/jdk1.8.0_91/bin/java
   4           /opt/jdk1.8.0_131/bin/java

Enter to keep the current selection[+], or type selection number: 4

At this point JAVA 8 has been successfully installed on your system. We also recommend to setup javac and jar commands path using alternatives

# alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_131/bin/jar 2
# alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_131/bin/javac 2
# alternatives --set jar /opt/jdk1.8.0_131/bin/jar
# alternatives --set javac /opt/jdk1.8.0_131/bin/javac
Check Installed Java Version
Check the installed Java version on your system using following command.

root@tecadmin ~# java -version

java version "1.8.0_131"
Java(TM) SE Runtime Environment (build 1.8.0_131-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.131-b11, mixed mode)
Configuring Environment Variables
Most of Java based application’s uses environment variables to work. Set the Java environment variables using following commands

# export JAVA_HOME=/opt/jdk1.8.0_131
# export JRE_HOME=/opt/jdk1.8.0_131/jre
# export PATH=$PATH:/opt/jdk1.8.0_131/bin:/opt/jdk1.8.0_131/jre/bin
Setup JAVA_HOME Variable
Setup JRE_HOME Variable
Setup PATH Variable
Also put all above environment variables in /etc/environment file for auto loading on system boot.
