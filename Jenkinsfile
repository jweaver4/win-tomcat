#!/usr/bin/env groovy

node (label: 'win-agent-1') {
    def app

    stage('Clone repository') {
          /* Let's make sure we have the repository cloned to our workspace */
          checkout scm
    }

    stage('Test image') {
      withSonarQubeEnv('sonarqube') {
        bat "C:/sonarscanner-msbuild/sonar-scanner-3.3.0.1492/bin/sonar-scanner.bat"
      }
      timeout(time: 10, unit: 'MINUTES') {
       waitForQualityGate abortPipeline: true
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
