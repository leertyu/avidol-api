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
                    sh "docker build -t avidol-app ."
                    
                    sh "docker rm -f avidol-app || true"
                    sh "docker run -d -p 3000:3000 --name avidol-app avidol-app"
                }
            }
        }       
    }
}