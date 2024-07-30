pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('nassim-dockerhub')
        APP_NAME = "nassim1102/flask"
    }
    stages {
        stage('SCM Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/lily4499/lil-node-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${env.BUILD_NUMBER}-${env.BUILD_ID}"
                    def imageName = "${APP_NAME}:${imageTag}"
                    sh "docker build -t ${imageName} ."
                }
            }
        }
        stage('Login to DockerHub') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }
        stage('Push Image to DockerHub') {
            steps {
                script {
                    def imageTag = "${env.BUILD_NUMBER}-${env.BUILD_ID}"
                    def imageName = "${APP_NAME}:${imageTag}"
                    sh "docker push ${imageName}"
                }
            }
        }
        stage('Scan Docker Image') {
            steps {
                script {
                    def imageTag = "${env.BUILD_NUMBER}-${env.BUILD_ID}"
                    def imageName = "${APP_NAME}:${imageTag}"
                    def trivyOutput = sh(script: "trivy image --severity HIGH,CRITICAL ${imageName}", returnStdout: true).trim()
                    println trivyOutput
                    if (!trivyOutput.contains("Total: 0")) {
                        echo "Vulnerabilities found in the Docker image."
                        error "Vulnerabilities found in the Docker image."
                    } else {
                        echo "No vulnerabilities found in the Docker image."
                    }
                }
            }
        }
    }
    post {
        always {
            // Nettoyer et déconnexion DockerHub
            sh "docker logout"
        }
        success {
            echo 'Pipeline terminé avec succès !'
        }
        failure {
            echo 'Pipeline a échoué !'
        }
    }
}
