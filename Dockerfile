# escape=`
FROM microsoft/windowsservercore

RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin" -Y
RUN choco install tomcat --version 8.5.12 -Y
RUN refreshenv

COPY ["config", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-8.5.12/conf/"]
COPY ["config/Catalina/localhost", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-8.5.12/conf/Catalina/localhost/"]
COPY ["webapps/manager/META-INF", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-8.5.12/webapps/manager/META-INF/"]
COPY ["webapps/host-manager", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-8.5.12/webapps/host-manager/"]
COPY ["webapps/host-manager/META-INF", "c:/Program Files/Apache Software Foundation/tomcat/apache-tomcat-8.5.12/webapps/host-manager/META-INF/"]

RUN powershell.exe -Command `
    Set-Service -name tomcat8 -startuptype Automatic; `
    Start-Service Tomcat8
