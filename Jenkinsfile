pipeline {
    agent any
    environment { TF_HOME = tool 'terraform' }
    stages {
        stage('Checkout') { steps { checkout scm } }
        
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh "${TF_HOME}/terraform init"
                    sh "${TF_HOME}/terraform apply -auto-approve"
                    sh "${TF_HOME}/terraform output -raw app_node_name > ../app_name.txt"
                    sh "${TF_HOME}/terraform output -raw monitor_node_name > ../mon_name.txt"
                }
            }
        }

        stage('Dynamic Inventory') {
            steps {
                script {
                    def app = readFile('app_name.txt').trim()
                    def mon = readFile('mon_name.txt').trim()
                    def inventory = "[app_node]\n${app} ansible_connection=docker\n\n[monitor_node]\n${mon} ansible_connection=docker\n"
                    writeFile file: 'inventory.ini', text: inventory
                }
            }
        }

        stage('Ansible Deployment') {
            steps {
                ansiblePlaybook(
                    playbook: 'ansible/playbook.yml',
                    inventory: 'inventory.ini',
                    extraVars: [ app_node_name: readFile('app_name.txt').trim() ]
                )
            }
        }

        stage('Smoke Test') {
            steps {
                sh "curl -f http://localhost:9090" // Перевірка застосунку
                sh "curl -f http://localhost:3000" // Перевірка Grafana
            }
        }
    }
    post {
        failure {
            echo "error detected!"
            dir('terraform') {
                sh "${TF_HOME}/terraform destroy -auto-approve"
            }
        }
        always {
            cleanWs()
        }
    }
}