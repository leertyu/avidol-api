pipeline {
    agent any
    tools {
        nodejs 'node20'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner'
                    withSonarQubeEnv('sonarqube-server') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
        stage('Build & Deploy') {
            steps {
                script {
                    sh "ls -R"
                    sh "docker build -t avidol-api ."
                    
                    sh "docker rm -f avidol-api || true"
                    sh "docker run -d -p 3001:3001 --name avidol-api avidol-api"
                }
            }
        }       
    }
}