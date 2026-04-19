pipeline {
    agent any

    environment {
        DOCKER_USER = "barsh4ec"
        IMAGE_NAME = "prikm"
        CONTAINER_NAME = "nginx-lab-container"
    }

    stages {
        stage('Start') {
            steps {
                echo 'Lab_2: started by GitHub'
            }
        }

        stage('Image build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
                
                sh "docker tag ${IMAGE_NAME}:latest ${DOCKER_USER}/${IMAGE_NAME}:latest"
                sh "docker tag ${IMAGE_NAME}:latest ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        stage('Push to registry') {
            steps {
                withDockerRegistry([ credentialsId: "ID_облікових даних", url: "" ]) {
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:latest"
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy image') {
            steps {
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"

                sh "docker run -d --name ${CONTAINER_NAME} -p 80:80 ${DOCKER_USER}/${IMAGE_NAME}:latest"
                
                echo "Додаток розгорнуто з Docker Hub і доступний на порту 80"
            }
        }
    }
}