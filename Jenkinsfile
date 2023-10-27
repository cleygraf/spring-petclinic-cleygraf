pipeline {
  agent any
  tools { maven '3.9.5' }
  stages {
    stage('Cloning Git') {
      steps {
                git(
                    url: "https://github.com/cleygraf/spring-petclinic-cleygraf.git",
                    branch: "main",
                    changelog: true,
                    poll: true
                )
      }
    }
    stage('Compile') {
       steps {
        withMaven {
          sh "mvn compile"
        } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
       }
    }
    stage('Test') {
      steps {
        sh '''
        mvn clean install
        ls
        pwd
        ''' 
        //if the code is compiled, we test and package it in its distributable format; run IT and store in local repository
      }
    }
    stage('Building Image') {
      steps{
        script {
          dockerImage = docker.build registry + ":latest"
        }
      }
    }
    stage('Deploy Image') {
      steps{
         script {
            docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:latest"
      }
    }
  }
}