# 由来
```
Maven的创始人是Jason Van Zyl，诞生时间大概在2001年3月。Maven起源于Jakarta Alexandria项目，在2002年10月份左右Maven迁移到Turbine项目中继续发展。

Jason Van Zyl发现按下面的方式管理项目更好：
  这样的项目的模型，你在一个地方可以查找属于这个项目的所有内容
  一个标准的目录结构，以便你不必去库，资源和文档中到处寻找
于是，Jason Van Zyl发明了Maven用于简化项目的建设。
```
# 何为Maven
```
Maven是一个项目管理工具，它包含了一个项目对象模型 (POM：Project Object Model)，一组标准集合，一个项目生命周期(Project Lifecycle)，一个依赖管理系统(Dependency Management System)，和用来运行定义在生命周期阶段(phase)中插件(plugin)目标(goal)的逻辑。

```

# 为何Maven
```
众所周知，在软件项目管理当中，所有项目都要经历构建，测试，打包，记录和部署这几个步骤。当然，上述每个步骤都存在无限的变化，但这种变化仍然发生在明确定义的路径的范围内，而Maven试图以明确的方式向每个人呈现这条路径。明确路径的最简单方法是为人们提供一组模式，这些模式可以由参与项目的任何人共享。
```
* 依赖库管理，减小工程体积
```
通过在pom.xml文件中添加所需jar包的坐标，这样就很好的避免了jar直接引入进来，在需要用到jar包的时候，只要查找pom.xml文件，再通过pom.xml文件中的坐标，到一个专门用于”存放jar包的仓库”(maven仓库)中根据坐标从而找到这些jar包，再把这些jar包拿去运行。
```
---
# Maven 3 in Action

* get
```
wget -c -t 0 -O /opt/apache-maven-3.5.2.tar.gz https://apache.osuosl.org/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
tar xvf /opt/apache-maven-3.5.2.tar.gz 

wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz


cat >> /etc/profile <<EOF
# maven profiles
MAVEN_HOME=/opt/apache-maven-3.5.2
PATH=${PATH}:${MAVEN_HOME}/bin
EOF

source /etc/profile
mvn -v
```

## start first mession
```
mvn help:system
## download maven-help-plugin to user local repository.
/root/.m2/repository/org/apache/maven/plugins/maven-help-plugin

# http proxy

# Best Deploy
MAVEN_OPTS  
  -Xms128m -Xmx512m
settings.xml
  cp /opt/apache-maven-3.5.2/conf/settings.xml /root/.m2/
Updata
  cd /opt && ln -s apache-maven-3.5.2 apache-maven
  vi /etc/profile 
  # maven
  MAVEN_HOME=/opt/apache-maven
  PATH=${PATH}:${MAVEN_HOME}/bin
  # when update
  rm apache-maven && ln -s apache-maven-3.X
Center repository
  http://repo1.maven.org/

# helloworld 
##  src/main/java is maven main code menu 
## pom.xml  #/root/hello-world/
<?xml version = "1.0" encoding = "UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
   http://maven.apache.org/xsd/maven-4.0.0.xsd">
   <modelVersion>4.0.0</modelVersion>
   <groupId>com.juvenxu.mvnbook</groupId>
   <artifactId>hello-world</artifactId>
   <version>1.0-SNAPSHOT</version>
</project>

mkdir -p /root/hello-world/src/main/java/com/$USER/mvnbook/helloworld
## HelloWorld.java
package com.juvenxu.mvnbook.helloworld;

public class HelloWorld
{
	public String sayHello()
	{
		return "Hello Maven";
	}

	public static void main(String[] args)
	{
		System.out.print(new HelloWorld().sayHello());
	}
}

mvn clean compile   #/root/hello-world/
# clean target  && compile *.java
.
├── pom.xml
├── src
│   └── main
│       └── java
│           └── com
│               └── juvenxu
│                   └── mvnbook
│                       └── helloworld
│                           └── HelloWorld.java
└── target
    ├── classes
    │   └── com
    │       └── juvenxu
    │           └── mvnbook
    │               └── helloworld
    │                   └── HelloWorld.class
    └── maven-status
        └── maven-compiler-plugin
            └── compile
                └── default-compile
                    ├── createdFiles.lst
                    └── inputFiles.lst


## Edit Test Code
## Add JUnit dependency
## pom.xml  #/root/hello-world/
<?xml version = "1.0" encoding = "UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
   http://maven.apache.org/xsd/maven-4.0.0.xsd">
   <modelVersion>4.0.0</modelVersion>
   <groupId>com.juvenxu.mvnbook</groupId>
   <artifactId>hello-world</artifactId>
   <version>1.0-SNAPSHOT</version>
   <name>Maven hello Project </name>
   <dependencies>
      <dependency>
         <groupId>junit</groupId>
         <artifactId>junit</artifactId>
         <version>4.7</version>
         <scope>test</scope>
      </dependency>
   </dependencies>
</project>

mkdir -p src/test/java/com/juvenxu/mvnbook/helloworld
cat >  src/test/java/com/juvenxu/mvnbook/helloworld/HelloWorldTest.java <<EOF
package com.juvenxu.mvnbook.helloworld;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class HelloWorldTest
{
   @ Test
   public void testSayHello()
   {
      HelloWorld helloWorld = new HelloWorld();
      String result = helloWorld.sayHello();
      assertEquals("Hello Maven", result);
   }
}
EOF

mvn clean test

##-
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.juvenxu.mvnbook.helloworld.HelloWorldTest
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.019 sec

Results :

Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
##-

├── pom.xml
├── src
│   ├── main
│   │   └── java
│   │       └── com
│   │           └── juvenxu
│   │               └── mvnbook
│   │                   └── helloworld
│   │                       └── HelloWorld.java
│   └── test
│       └── java
│           └── com
│               └── juvenxu
│                   └── mvnbook
│                       └── helloworld
│                           └── HelloWorldTest.java
└── target
    ├── classes
    │   └── com
    │       └── juvenxu
    │           └── mvnbook
    │               └── helloworld
    │                   └── HelloWorld.class
    ├── maven-status
    │   └── maven-compiler-plugin
    │       ├── compile
    │       │   └── default-compile
    │       │       ├── createdFiles.lst
    │       │       └── inputFiles.lst
    │       └── testCompile
    │           └── default-testCompile
    │               ├── createdFiles.lst
    │               └── inputFiles.lst
    ├── surefire-reports
    │   ├── com.juvenxu.mvnbook.helloworld.HelloWorldTest.txt
    │   └── TEST-com.juvenxu.mvnbook.helloworld.HelloWorldTest.xml
    └── test-classes
        └── com
            └── juvenxu
                └── mvnbook
                    └── helloworld
                        └── HelloWorldTest.class


# package && run
mvn clean package
##-
[INFO] Building jar: /root/hello-world/target/hello-world-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
##-

# other project use && copy this jar
mvn clean install


#  Run 
## maven-shade-plugin
## pom.xml  #/root/hello-world/  
<?xml version = "1.0" encoding = "UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
   http://maven.apache.org/xsd/maven-4.0.0.xsd">
   <modelVersion>4.0.0</modelVersion>
   <groupId>com.juvenxu.mvnbook</groupId>
   <artifactId>hello-world</artifactId>
   <version>1.0-SNAPSHOT</version>
   <name>Maven hello Project </name>
   <dependencies>
      <dependency>
         <groupId>junit</groupId>
         <artifactId>junit</artifactId>
         <version>4.7</version>
         <scope>test</scope>
      </dependency>
   </dependencies>
   <build>
      <plugins>
         <plugin>
    	  <groupId>org.apache.maven.plugins</groupId>
    	   <artifactId>maven-shade-plugin</artifactId>
    	   <version>2.4.3</version>
    	   <executions>
            <execution>
             <phase>package</phase>
              <goals>
               <goal>shade</goal>
              </goals>
	      <configuration>
	       <transformers>
	        <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
	         <mainClass>com.juvenxu.mvnbook.helloworld.HelloWorld</mainClass>
	        </transformer>
	       </transformers>
	      </configuration>
            </execution>
	   </executions>
	 </plugin>
      </plugins>
   </build>
</project>


mvn clean package
└── target
    ├── classes
    │   └── com
    │       └── juvenxu
    │           └── mvnbook
    │               └── helloworld
    │                   └── HelloWorld.class
    ├── hello-world-1.0-SNAPSHOT.jar
    ├── maven-archiver
    │   └── pom.properties
    ├── maven-status
    │   └── maven-compiler-plugin
    │       ├── compile
    │       │   └── default-compile
    │       │       ├── createdFiles.lst
    │       │       └── inputFiles.lst
    │       └── testCompile
    │           └── default-testCompile
    │               ├── createdFiles.lst
    │               └── inputFiles.lst
    ├── original-hello-world-1.0-SNAPSHOT.jar

jar xvf target/hello-world-1.0-SNAPSHOT.jar
cat target/META-INF/MANIFEST.MF
Manifest-Version: 1.0
Archiver-Version: Plexus Archiver
Built-By: root
Created-By: Apache Maven 3.5.2
Build-Jdk: 1.8.0_131
Main-Class: com.juvenxu.mvnbook.helloworld.HelloWorld

java -jar target/hello-world-1.0-SNAPSHOT.jar
#-
Hello Maven
#-



#Maven Quick Start
mkdir hello-world && cd hello-world
mvn archetype:generate
.
└── hello-world
    ├── pom.xml
    └── src
        ├── main
        │   └── java
        │       └── com
        │           └── will
        │               └── mvnbook
        │                   └── helloworld
        │                       └── App.java
        └── test
            └── java
                └── com
                    └── will
                        └── mvnbook
                            └── helloworld
                                └── AppTest.java





```




## Maven Wrapper       
```
#保证Java编译的一致性
	https://github.com/takari/maven-wrapper
#set
mvn -N io.takari:maven:wrapper
mvn -N io.takari:maven:0.7.6:wrapper

	ls ./.mvn/wrapper/         #生成3个文件
-rw-rw-r-- 1 root root 4.9K Jun 24 15:44 MavenWrapperDownloader.java
-rw-rw-r-- 1 root root  50K Jun 24 15:44 maven-wrapper.jar
-rw-rw-r-- 1 root root  218 Jun 24 15:44 maven-wrapper.properties	
```
