# DEMO IMPLEMENTATION

<<<<<<< HEAD
To be able to run this Demo, follow the instructions for the correct implementation of all the requeriments:
=======
To be able to run this project ensure the following is installed on the **Windows VSTS Agent**
>>>>>>> 515b832e0112d9c1266d44733f184df5f474239d

1. Create a Service Principal on your Azure Account.
2. Create a WebApp Service on your Azure Account.
3. Create a Windows VSTS Agent with necesary requirements to run the Demo.
4. Import Git repository to VSTS.
5. Import Build and Release definitions on VSTS and link them to the VSTS Agent created on step 3.
6. Run the Demo.

## 3. Requirements VSTS Agent Installation

Create an 

To be able to run this project ensure the following is installed:

1. Download and install **.Net Framework 3.5** 
    
    1. Install with .exe from Microsoft Download Center 
        
        [Download .Net Framework 3.5](https://www.microsoft.com/en-us/download/details.aspx?id=21)
        
    2. Install with Powershell
        ```
        Get-WindowsFeature NET-Framework-Features
        Install-WindowsFeature NET-Framework-Features
        ```

2. Download and install the **Java JDK** latest version
   
   [Download Java JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
    
    1. Configure the **JAVA_HOME** variable, with **Environment Variables** tool.
    Open **Control Panel >> System and Security >> System**, click on **Advanced system settings** and then click on **Environment Variables**. On **System variables** section, add **JAVA_HOME**.

        Example:

            Variable: JAVA_HOME
            Value: C:\Program Files\Java\jdk1.7.0_65 

    2. Test configuration runing `java -version` on cmd.

3. Download and install the **Java JRE** latest version

    [Download Java JRE](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
    
    1. Configure the **JRE_HOME** variable, with **Environment Variables** tool.
    Open **Control Panel >> System and Security >> System**, click on **Advanced system settings** and then click on **Environment Variables**. On **System variables** section, add **JRE_HOME**.

        Example:

            Variable: JRE_HOME
            Value: C:\Program Files\Java\jre-10.0.1

    2. Test configuration runing `java -version` on cmd.

4. Download **Maven** latest version, for example **apache-maven-3.5.-bin.zip**

    [Download Apache Maven](http://maven.apache.org/download.cgi)

    1. Unzip it to the folder **C:\java\maven**.

    2. Configure the **M2_HOME** and **MAVEN_HOME** variables, with **Environment Variables** tool.
    Open **Control Panel >> System and Security >> System**, click on **Advanced system settings** and then click on **Environment Variables**. On **System variables** section, add **M2_HOME** and **MAVEN_HOME**.

        Example:

            Variable: M2_HOME
            Value: C:\java\maven\apache-maven-3.5.4\bin

            Variable: MAVEN_HOME
            Value: C:\java\maven\apache-maven-3.5.4\bin

    3. Test configuration runing `maven -version` on cmd.