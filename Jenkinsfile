pipeline {
    agent {
        label 'ubuntu-docker'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/khanh-103973/DevOps-CICD.git'
            }
        }

        stage('Test Flask') {
            steps {
                sh '''
                    docker run --rm \
                    -v "$WORKSPACE:/app" \
                    -w /app \
                    python:3.11-slim \
                    sh -c "pip install --no-cache-dir -r requirements.txt && python -m unittest discover -v"
                '''
            }
        }

        stage('Build Docker') {
            steps {
                sh 'docker build -t devops-flask:latest .'
            }
        }
    }

    post {
        success {
            echo 'CI Pipeline SUCCESS!'
        }

        failure {
            echo 'CI Pipeline FAILED!'
        }
    }
}