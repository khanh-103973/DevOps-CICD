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

        stage('Deploy to AWS EC2') {
            steps {
                sshagent(credentials: ['aws-ec2-deploy']) {
                    sh '''
                        set -eu

                        EC2_HOST="52.62.159.59"

                        echo "Transferring Docker image to EC2..."

                        docker save devops-flask:latest | gzip | \
                          ssh -o BatchMode=yes \
                              -o StrictHostKeyChecking=yes \
                              ec2-user@$EC2_HOST \
                              'gunzip | docker load'

                        echo "Starting application on EC2..."

                        ssh -o BatchMode=yes \
                            -o StrictHostKeyChecking=yes \
                            ec2-user@$EC2_HOST \
                            'set -e
                             docker rm -f flask-app || true
                             docker run -d \
                               --name flask-app \
                               --restart unless-stopped \
                               -p 5000:5000 \
                               devops-flask:latest
                             sleep 3
                             curl --fail http://127.0.0.1:5000/health'

                        echo "Deployment completed!"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline SUCCESS!'
        }

        failure {
            echo 'CI/CD Pipeline FAILED!'
        }
    }
}