pipeline {
  agent {
    kubernetes {
      label 'config-slave'
      defaultContainer 'jdk'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: jdk
    image: openjdk:8
    command:
    - cat
    tty: true
  - name: docker
    image: docker
    command:
    - cat
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-socket
    tty: true
  volumes:
    - name: docker-socket
      hostPath:
        path: /var/run/docker.sock
        type: File
"""
    }
  }
  // agent {
  //     kubernetes {
  //         label 'demorest'
  //         containerTemplate {
  //             name 'jdk'
  //             image 'gradle:4.7-jdk-alpine'
  //             ttyEnabled true
  //             command 'cat'
  //         }
  //     }
  // }
  stages {
    stage('Checkout') {
      steps {
        script {
          scmVars = checkout scm
        }
      }
    }
    stage('Build') {
      steps {
        sh './gradlew build -x test'
      }
    }
    stage('Bake') {
      steps {
        container(name: 'docker', shell: '/bin/sh') {
          script {
            sh "docker build -t nexus.avenuecode.com/herbalife/config:${scmVars.GIT_COMMIT} ."
          }
        }
      }
    }
    stage('Publish') {
      // when {
      //     branch 'master'
      // }
      steps {
        container(name: 'docker', shell: '/bin/sh') {
          withDockerRegistry([credentialsId: 'nexus-docker', url: 'https://nexus.avenuecode.com']) {
            script {
              docker.image("nexus.avenuecode.com/herbalife/config:${scmVars.GIT_COMMIT}").push()
            }
          }
        }
      }
    }
  }
}
