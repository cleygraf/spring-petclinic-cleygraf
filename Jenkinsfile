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
        sh "mvn compile"
       }
    }
    stage('Test') {
      steps {
        sh "mvn test"      }
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