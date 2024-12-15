pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'domwil1208/cw2-server:1.0'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials-id'
        KUBECONFIG = credentials('kubeconfig-credentials-id')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/domwil1208/Devops-Coursework-2-DW.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    def containerId = sh(script: 'docker run -d domwil1208/cw2-server:1.0', returnStdout: true).trim()
                    echo "Container ID: ${containerId}"

                    def result = sh(script: "docker exec ${containerId} echo 'Container is running!'", returnStdout: true).trim()
                    echo "Container Test Result: ${result}"

                    sh "docker stop ${containerId}"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withDockerRegistry(credentialsId: "${DOCKERHUB_CREDENTIALS}", url: "") {
                        sh "docker push ${DOCKER_IMAGE_NAME}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Run kubectl commands to deploy the app
                    sh '''
                        kubectl delete deployment domwil-1208-cw2server --ignore-not-found=true
                        
                        kubectl create deployment domwil-1208-cw2server --image=domwil1208/cw2-server:1.0

                        kubectl expose deployment domwil-1208-cw2server --type=LoadBalancer --port=80 --name=domwil-1208-cw2server-service
                    '''
                }
            }
        }
    }
}
