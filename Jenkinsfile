#!/usr/bin/env groovy

node (label: 'win-agent-1') {
    def app

    stage('Clone repository') {
          /* Let's make sure we have the repository cloned to our workspace */
          checkout scm
    }

    stage('Test image') {
    /* Sonarqube at http://fsxopsx1548.edc.ds1.usda.gov:9090*/
    withSonarQubeEnv('SonarServer Windows') {
    bat "C:/sonar-scanner-4.2.0.1873-windows/bin/sonar-scanner.bat"
      }
    }

    stage('Build container') {
      /* This builds the actual image; synonymous to
      * docker build on the command line. Copies image to DTR */
      docker.withRegistry('http://pe-201642-agent.puppetdebug.vlan:5000', 'portus_registry') {
          app = docker.build("pe-201642-agent.puppetdebug.vlan:5000/windows/win_tomcat:${env.BUILD_NUMBER}", '--no-cache --pull .')
          app.push("${env.BUILD_NUMBER}")
      }
   }

   stage('Remove existing container') {
    sh 'docker rm -f tomcat || true'
  }

   stage('Deploy new container') {
     docker.image("pe-201642-agent.puppetdebug.vlan:5000/windows/win_tomcat:${env.BUILD_NUMBER}").run("--name tomcat -t -d -p 8080:8080")
   }
}
