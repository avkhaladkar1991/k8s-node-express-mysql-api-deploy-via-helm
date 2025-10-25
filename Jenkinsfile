pipeline {
    agent any

    environment {
        // Add brew path so helm and other tools are found
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/avkhaladkar1991/k8s-node-express-mysql-api-deploy-via-helm.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'echo Installing dependencies...'
                // Use npm since yarn was not available in PATH earlier
                sh 'npm install'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'echo Building Docker image...'
                sh 'docker build -t my-node-app:latest .'
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh 'echo Deploying to Kubernetes using Helm...'
                // Print Helm version to confirm it's visible
                sh 'helm version'
                // Upgrade or install Helm chart
                sh 'helm upgrade --install my-node-app ./helm/mychart --namespace default --create-namespace'
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'echo Checking deployed Helm releases...'
                sh 'helm list --namespace default'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up temporary workspace...'
            cleanWs()
        }
    }
}
