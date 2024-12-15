pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "domwil1208/cw2-server:1.0"
        KUBE_DEPLOYMENT = "domwil-1208-cw2server"
        DOCKER_CREDENTIALS_ID = "dockerhub-credentials-id"
        KUBECONFIG = credentials('kubeconfig-credentials-id')
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Pull the latest code from GitHub
                git branch: 'main', url: 'https://github.com/domwil1208/Devops-Coursework-2-DW.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    // Launch a test container and verify it runs successfully
                    sh """
                    docker run --name test-container -d ${DOCKER_IMAGE}
                    sleep 5  # Wait for the container to initialize
                    docker exec test-container echo 'Container launched successfully'
                    docker stop test-container
                    docker rm test-container
                    """
                }
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    // Push the image to DockerHub
                    withDockerRegistry(credentialsId: "${DOCKER_CREDENTIALS_ID}", url: "") {
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy the image to Kubernetes
                    sh """
                    kubectl set image deployment/${KUBE_DEPLOYMENT} app-container=${DOCKER_IMAGE} --kubeconfig=${KUBECONFIG}
                    kubectl rollout status deployment/${KUBE_DEPLOYMENT} --kubeconfig=${KUBECONFIG}
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
