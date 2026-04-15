pipeline {
    agent any

    environment {
        IMAGE_NAME = "nginx/custom:latest"
        CONTAINER_NAME = "nginx-lab-container"
    }

    stages {
        stage('Start') {
            steps {
                echo "Start: ${IMAGE_NAME}"
                sh 'ls -la'
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Cleanup & Deploy') {
            steps {
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
                
                sh "docker run -d --name ${CONTAINER_NAME} -p 80:80 ${IMAGE_NAME}"
                echo "App is available on port 80"
            }
        }
    }
}