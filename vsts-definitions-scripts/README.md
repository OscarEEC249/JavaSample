# Requirements on VSTS Agent

To be able to run this project ensure the following is installed on the **Windows VSTS Agent**:

## Requirements Installation

To be able to run this project ensure the following is installed:

1. Download and install the Java JDK latest version:
[Download Java JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
    
    1. Configure the **JAVA_HOME** variable, with **Environment Variables** tool.
    Open **Control Panel\System and Security\System**, click on **Advanced system settings** and then click on **Environment Variables**. On **System variables** section, add **JAVA_HOME**.

        Example:

            Variable: JAVA_HOME
            Value: C:\Program Files\Java\jdk1.7.0_65 

    2. Test configuration runing `java -version` on cmd.

2. Download and install the Java JRE latest version:
[Download Java JRE](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
    
    1. Configure the **JRE_HOME** variable, with **Environment Variables** tool.
    Open **Control Panel\System and Security\System**, click on **Advanced system settings** and then click on **Environment Variables**. On **System variables** section, add **JRE_HOME**.

        Example:

            Variable: JRE_HOME
            Value: C:\Program Files\Java\jre-10.0.1

    2. Test configuration runing `java -version` on cmd.

3. Download Maven latest version, for example **apache-maven-3.5.-bin.zip**:
[Download Apache Maven](http://maven.apache.org/download.cgi)

    1. Unzip it to the folder **C:\java\maven**.

    2. Configure the **M2_HOME** and **MAVEN_HOME** variables, with **Environment Variables** tool.
    Open **Control Panel\System and Security\System**, click on **Advanced system settings** and then click on **Environment Variables**. On **System variables** section, add **M2_HOME** and **MAVEN_HOME**.

        Example:

            Variable: M2_HOME
            Value: C:\java\maven\apache-maven-3.5.4\bin

            Variable: MAVEN_HOME
            Value: C:\java\maven\apache-maven-3.5.4\bin

    3. Test configuration runing `maven -version` on cmd.
