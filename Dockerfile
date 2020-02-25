# SPECIFY THE CONTAINER IMAGE
FROM  mcr.microsoft.com/windows/servercore:ltsc2019

# Install Chocolatey
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin" -Y

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR /Users/ContainerAdministrator/Downloads

RUN choco install jdk8 -params "source=false" -y
RUN refreshenv

RUN choco install tomcat --version 9.0.30 -Y
RUN refreshenv

COPY ["config", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-9.0.30/conf/"]
COPY ["config/Catalina/localhost", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-9.0.30/conf/Catalina/localhost/"]
COPY ["webapps/manager/META-INF", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-9.0.30/webapps/manager/META-INF/"]
COPY ["webapps/host-manager", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-9.0.30/webapps/host-manager/"]
COPY ["webapps/host-manager/META-INF", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-9.0.30/webapps/host-manager/META-INF/"]

RUN Set-Service -name tomcat9

RUN powershell.exe -Command \
    Set-Service -name tomcat9 -startuptype Automatic; \
    Start-Service Tomcat9
