FROM  mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR /Users/ContainerAdministrator/Downloads

# INSTALL JDK
RUN (new-object System.Net.WebClient).DownloadFile('http://10.20.1.4:8081/artifactory/windows-server-local/test/jdk-11.0.6_windows-x64_bin.exe','jdk.exe'); \
    Start-Process '.\jdk.exe' '/s' -Wait; \
    Remove-Item jdk.exe; 

# UNCOMPRESS APACHE TOMCAT 8 TO C:\tomcat
RUN (new-object System.Net.WebClient).DownloadFile('http://10.20.1.4:8081/artifactory/windows-server-local/test/apache-tomcat-8.5.51-windows-x64.zip','tomcat8.zip'); \
    Expand-Archive -Path tomcat8.zip -DestinationPath c:\tomcat\ -Force;
COPY ["config", "c:/tomcat/apache-tomcat-8.5.51/conf/"]
COPY ["config/Catalina/localhost", "c:/tomcat/apache-tomcat-8.5.51/conf/Catalina/localhost/"]
COPY ["webapps/manager/META-INF", "c:/tomcat/apache-tomcat-8.5.51/webapps/manager/META-INF/"]
COPY ["webapps/host-manager", "c:/tomcat/apache-tomcat-8.5.51/webapps/host-manager/"]
COPY ["webapps/host-manager/META-INF", "c:/tomcat/apache-tomcat-8.5.51/webapps/host-manager/META-INF/"]

# INSTALL TOMCAT SERVICE
RUN cd 'C:\tomcat\apache-tomcat-8.5.51\bin'; \
    Start-Process "service.bat install" -Wait;
RUN Set-Service -name tomcat8 -startuptype Automatic; \
    Start-Service Tomcat8;
