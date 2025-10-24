pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/usr/bin:$PATH"   // ensures git, docker, helm, yarn are found
        IMAGE_NAME = "my-node-app"
        IMAGE_TAG  = "v1"
        CHART_PATH = "helm/mychart"
        GIT_CRED_ID = "github-creds"
        DOCKER_CRED_ID = "dockerhub-creds"
        KUBE_CRED_ID = "kubeconfig-creds"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', 
                    url: 'https://github.com/avkhaladkar1991/k8s-node-express-mysql-api-deploy-via-helm.git', 
                    credentialsId: "${GIT_CRED_ID}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker version'
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CRED_ID}", 
                                                  usernameVariable: 'DOCKERHUB_USERNAME', 
                                                  passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                        echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} $DOCKERHUB_USERNAME/${IMAGE_NAME}:${IMAGE_TAG}
                        docker push $DOCKERHUB_USERNAME/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes using Helm') {
            steps {
                withCredentials([kubeconfigFile(credentialsId: "${KUBE_CRED_ID}", variable: 'KUBECONFIG')]) {
                    sh '''
                        # Ensure Helm repo is updated
                        helm repo update
                        # Install or upgrade the release
                        helm upgrade --install ${IMAGE_NAME} ${CHART_PATH} \
                            --set image.repository=$DOCKERHUB_USERNAME/${IMAGE_NAME} \
                            --set image.tag=${IMAGE_TAG} \
                            --wait
                    '''
                }
            }
        }

        stage('Optional Yarn Install') {
            steps {
                // Only run if yarn.lock exists
                sh '''
                    if [ -f yarn.lock ]; then
                        yarn install --production --force
                    else
                        echo "yarn.lock not found, skipping yarn install"
                    fi
                '''
            }
        }
    }

    post {
        always {
            sh 'helm list'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
