pipeline {
    agent { label 'docker' }  

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '992382545251.dkr.ecr.us-east-1.amazonaws.com/meshy-repo'
        AWS_CREDENTIALS_ID = 'aws-jenkins-creds'  
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clone the GitHub repository
                git 'https://github.com/meshyharel3/FP-statuspage.git'
            }
        }

        stage('Build Statuspage Image') {
            steps {
                script {
                    // Log in to ECR
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                        sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO'
                        
                        // Build the statuspage Docker image
                        sh 'docker build -t statuspage:latest ./statuspage'  
                        // Tag and push the image to ECR
                        sh 'docker tag statuspage:latest $ECR_REPO:statuspage'
                        sh 'docker push $ECR_REPO:statuspage'
                    }
                }
            }
        }

        stage('Build Nginx Image') {
            steps {
                script {
                    // Log in to ECR (optional as already done in the previous stage, but kept for clarity)
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                        sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO'

                        // Build the Nginx Docker image
                        sh 'docker build -t nginx:latest -f Dockerfile-nginx .'  // Adjust the path as necessary

                        // Tag and push the image to ECR
                        sh 'docker tag nginx:latest $ECR_REPO:nginx'
                        sh 'docker push $ECR_REPO:nginx'
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    // Deploy the statuspage image to EKS
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                        // Update kubeconfig to access EKS
                        sh 'aws eks --region $AWS_REGION update-kubeconfig --name meshy-eks-cluster'  
                        
                        // Update the deployment for statuspage
                        sh "kubectl set image deployment/statuspage statuspage=$ECR_REPO:statuspage"
                        sh "kubectl rollout restart deployment/statuspage"
                    }
                }
            }
        }

        stage('Deploy Nginx') {
            steps {
                script {
                    // Deploy the Nginx image to EKS
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID]]) {
                        // Update the deployment for Nginx
                        sh "kubectl set image deployment/nginx nginx=$ECR_REPO:nginx"
                        sh "kubectl rollout restart deployment/nginx"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
