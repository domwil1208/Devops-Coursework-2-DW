pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'domwil1208/cw2-server:1.0'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials-id'  // Jenkins credentials for Docker Hub
        KUBE_CONFIG_PATH = '/path/to/kube/config'  // Path to kubectl config (minikube or AWS EKS)
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pull the latest code from the GitHub repository
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

        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    // Push the image to DockerHub
                    docker.withRegistry('https://hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        docker.image(DOCKER_IMAGE_NAME).push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Ensure kubectl is available (Minikube setup)
                    sh 'kubectl config use-context minikube'  // Adjust if using a different context

                    // Apply the deployment YAML file to Kubernetes
                    sh 'kubectl apply -f k8s/deployment.yaml'  // Ensure this path points to your Kubernetes YAML
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
