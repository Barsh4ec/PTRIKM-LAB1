pipeline {
    agent any

    environment {
        DOCKER_USER = "barsh4ec"
        IMAGE_NAME = "prikm"
        CONTAINER_NAME = "nginx-lab-container"
    }

    parameters {
            string(name: 'VERSION', defaultValue: '1.0', description: 'app version')
            choice(name: 'ENVIRONMENT', choices: ['Dev', 'Prod'], description: 'deploy environment')
        }

    options {
        timestamps()
        office365ConnectorWebhooks([[
            name: 'Teams-O365',
            url: 'https://lpnu.webhook.office.com/webhookb2/8be437d8-8e8d-43aa-b131-6dd94f08c2f1@7631cd62-5187-4e15-8b8e-ef653e366e7a/IncomingWebhook/f01431ff220d4e96869be6a89d23bbb6/e04f73d4-2c03-4fad-80f5-976648d68832/V2s8Zm_qDAFxOQCe87mPGCT4PrIqVI9LuYYwtiztrQoN41',
            notifySuccess: true,
            notifyFailure: true,
            notifyUnstable: true,
            notifyBackToNormal: true
        ]])
    }


    stages {
        stage('Start') {
            steps {
                echo 'Lab_3: testing of logging, custom plugins'
                echo "Deploying version ${params.VERSION} to ${params.ENVIRONMENT}"
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
                withDockerRegistry([ credentialsId: "docker-hub-id", url: "" ]) {
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