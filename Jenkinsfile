pipeline {
  agent {
    label 'jenkins-agent'
  }
  environment {
    registry = "chrisley/spring-petclinic-cleygraf"
    registryCredential = 'dockerhub'
}
  tools { maven '3.9.5' }
  stages {
    stage('Cloning Git Repo') {
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
        sh "mvn compile"
       }
    }
    stage('Test') {
      steps {
        sh "mvn test"
      }
    }
    stage('Building Container Image') {
      steps{
        sh "mvn clean install"
        script {
          dockerImage = docker.build registry + ":latest"
        }
      }
    }
    stage('Push Container Image') {
      steps{
         script {
            docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Remove Unused local docker image') {
      steps{
        sh "docker rmi $registry:latest"
      }
    }
  }
}