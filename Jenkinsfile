pipeline {
    agent any
    environment {
        TF_HOME = tool 'terraform'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Infrastructure Provisioning') {
            steps {
                sh "${TF_HOME}/terraform init"
                sh "${TF_HOME}/terraform apply -auto-approve"
                sh "${TF_HOME}/terraform output -raw server_ip > server_ip.txt"
            }
        }
        stage('Configuration & Deploy') {
            steps {
                script {
                    def serverIp = readFile('server_ip.txt').trim()
                    sh "echo '[web_servers]\n${serverIp} ansible_connection=docker ansible_user=root' > dynamic_inventory.ini"
                    
                    ansiblePlaybook(
                        playbook: 'playbook.yml',
                        inventory: 'dynamic_inventory.ini',
                        installation: 'ansible',
                        colorized: true
                    )
                }
            }
        }
    }

    post {
        failure {
            echo "error detected!"
            sh "${TF_HOME}/terraform destroy -auto-approve"
        }
        always {
            cleanWs()
        }
    }
}