pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'domwil1208/cw2-server:1.0'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials-id'
        KUBE_CONFIG_PATH = '~/.kube/config'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the 'main' branch from the GitHub repository
                git branch: 'main', url: 'https://github.com/domwil1208/Devops-Coursework-2-DW.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    // Run the container in detached mode and capture the container ID
                    def containerId = sh(script: 'docker run -d domwil1208/cw2-server:1.0', returnStdout: true).trim()
                    echo "Container ID: ${containerId}"
                    
                    // Run a simple command inside the container to ensure it is running
                    def result = sh(script: "docker exec ${containerId} echo 'Container is running!'", returnStdout: true).trim()
                    echo "Container Test Result: ${result}"
                    
                    // Stop the container after the test
                    sh "docker stop ${containerId}"
                }
            }
        }

       stage('Push to DockerHub') {
            steps {
                script {
                    // Log in and push the image to DockerHub
                    withDockerRegistry(credentialsId: "${DOCKERHUB_CREDENTIALS}", url: "") {
                        sh "docker push ${DOCKER_IMAGE_NAME}"
                    }
                }
            }
        }


       stage('Deploy to Kubernetes') {
            steps {
                script {

                    // Apply the deployment YAML file to Kubernetes
                    sh 'kubectl apply -f k8s/deployment.yaml'
                }
            }
        }
    }

    post {
        success {
            echo 'Build, Test, and Deploy Successful!'
        }
        failure {
            echo 'Something went wrong, please check the logs.'
        }
    }
}
