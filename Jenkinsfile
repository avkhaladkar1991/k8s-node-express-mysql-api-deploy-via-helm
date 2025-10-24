pipeline{
    agent any
    environment {
        IMAGE_NAME = "my-node-app"
        IMAGE_TAG  = "v1"
        CHART_PATH = "helm/mychart"
        GIT_CRED_ID = "github-creds"                 // change to your Jenkins credential id (or remove)
      
    }
    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/avkhaladkar1991/k8s-node-express-mysql-api-deploy-via-helm.git', credentialsId: 'github-creds'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker version'
                sh 'docker build -t my-node-app:v1 .'
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                        echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                        docker tag $IMAGE_NAME:$IMAGE_TAG $DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG
                        docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes using Helm') {
            steps {
                withCredentials([kubeconfigFile(credentialsId: 'kubeconfig-creds', variable: 'KUBECONFIG')]) {
                    sh '''
                        helm upgrade --install $ IMAGE_NAME $CHART_PATH --set image.repository=$DOCKERHUB_USERNAME/$IMAGE_NAME --set image.tag=$IMAGE_TAG
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'helm list'
        }
    }
}
