pipeline {
    agent any
    triggers { pollSCM('* * * * *') }
    stages {
        stage('Deploy') {
            steps {
                sh 'docker compose down || true'
                sh 'docker compose up -d --build'
            }
        }
    }
}