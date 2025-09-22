pipeline {
    agent any

    tools {
        jdk 'jdk-17'
        maven 'maven3'
    }

    environment {
        IMAGE_NAME = "antonio667/calculator-app"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-credentials',
                    url: 'https://github.com/Antonio-user/calculator-app.git',
                    branch: 'main'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests=false'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build ${env.BUILD_NUMBER} succeeded and Docker image pushed!"
            emailext(
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Le build ${env.BUILD_NUMBER} a réussi ✅.\nVoir les détails : ${env.BUILD_URL}",
                to: "reseaua73@gmail.com"
            )
        }
        failure {
            echo "❌ Build ${env.BUILD_NUMBER} failed!"
            emailext(
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Le build ${env.BUILD_NUMBER} a échoué ❌.\nVoir les logs : ${env.BUILD_URL}",
                to: "reseaua73@gmail.com"
            )
        }
    }
}
