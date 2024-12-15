pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/domwil1208/Devops-Coursework-2-DW.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'docker build -t domwil1208/cw2-server:1.0 .'
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    // Run the container
                    def containerId = sh(script: 'docker run -d domwil1208/cw2-server:1.0', returnStdout: true).trim()
                    echo "Container ID: ${containerId}"
                    
                    // Test the container is running
                    def testResult = sh(script: "docker exec ${containerId} echo 'Container is running!'", returnStdout: true).trim()
                    echo "Container Test Result: ${testResult}"
                    
                    // Stop the container after testing
                    sh "docker stop ${containerId}"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Log into DockerHub and push the image
                    sh '''
                        docker login -u domwil1208 -p $DOCKER_PASSWORD
                        docker push domwil1208/cw2-server:1.0
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Run kubectl commands to deploy the app
                    sh '''
                        kubectl run domwil-1208-cw2server --image=domwil1208/cw2-server:1.0 --replicas=2 --port=80

                        kubectl expose deployment domwil-1208-cw2server --type=LoadBalancer --port=80 --name=domwil-1208-cw2server-service
                    '''
                }
            }
        }
    }
}
