
## How to Install JAVA 8 (JDK/JRE 8u131) on CentOS/RHEL 7/6 and Fedora 25

For 64Bit
cd /opt/
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"

# tar xzf jdk-8u131-linux-x64.tar.gz
For 32Bit
# cd /opt/
# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-i586.tar.gz"

tar xzf jdk-8u131-linux-i586.tar.gz

Install Java with Alternatives
After extracting archive file use alternatives command to install it. alternatives command is available in chkconfig package.

cd /opt/jdk1.8.0_131/
alternatives --install /usr/bin/java java /opt/jdk1.8.0_131/bin/java 2
alternatives --config java


There are 3 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
*  1           /opt/jdk1.7.0_71/bin/java
 + 2           /opt/jdk1.8.0_45/bin/java
   3           /opt/jdk1.8.0_91/bin/java
   4           /opt/jdk1.8.0_131/bin/java

Enter to keep the current selection[+], or type selection number: 4

At this point JAVA 8 has been successfully installed on your system. We also recommend to setup javac and jar commands path using alternatives

alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_131/bin/jar 2
alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_131/bin/javac 2
alternatives --set jar /opt/jdk1.8.0_131/bin/jar
alternatives --set javac /opt/jdk1.8.0_131/bin/javac

Check Installed Java Version
Check the installed Java version on your system using following command.

root@tecadmin ~# java -version

java version "1.8.0_131"
Java(TM) SE Runtime Environment (build 1.8.0_131-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.131-b11, mixed mode)
Configuring Environment Variables
Most of Java based application’s uses environment variables to work. Set the Java environment variables using following commands

export JAVA_HOME=/opt/jdk1.8.0_131
export JRE_HOME=/opt/jdk1.8.0_131/jre
export PATH=$PATH:/opt/jdk1.8.0_131/bin:/opt/jdk1.8.0_131/jre/bin

Setup JAVA_HOME Variable
Setup JRE_HOME Variable
Setup PATH Variable
Also put all above environment variables in /etc/environment file for auto loading on system boot.




vi /etc/profile
# java
JAVA_HOME=/opt/jdk1.8.0_131
JRE_HOME=/opt/jdk1.8.0_131/jre
PATH=$PATH:/opt/jdk1.8.0_131/bin:/opt/jdk1.8.0_131/jre/bin




#JVM notes
JVM是一种用于计算设备的规范，它是一个虚构出来的计算机，是通过在实际的计算机上仿真模拟各种计算机功能来实现的。
Java虚拟机有自己完善的硬件架构，如处理器、堆栈、寄存器等，还具有相应的指令系统。
Java虚拟机本质是就是一个程序，当它在命令行上启动的时候，就开始执行保存在某字节码文件中的指令。Java语言的可移植性正是建立在Java虚拟机的基础上。任何平台只要装有针对于该平台的Java虚拟机，字节码文件（.class）就可以在该平台上运行。这就是“一次编译，多次运行”。
Java虚拟机不仅是一种跨平台的语言，而且是一种新的网络计算平台。该平台包括许多相关的技术，如符合开放接口标准的各种API、优化技术等。Java技术使同一种应用可以运行在不同的平台上。Java平台可分为两部分，即Java虚拟机（Java virtual machine，JVM）和Java API类库。
  memory
X64 物理内存50% < 32Gb
X32 <4Gb
