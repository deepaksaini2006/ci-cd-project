pipeline {
    agent {
        label 'amazon-worker'
    }

    environment {
        DOCKER_IMAGE = "deepaksaini98/jenkins-cicd-app"
        AWS_REGION   = "ap-east-1"
        AMI_ID       = "ami-0332d564d76dbd8d6"
    }

    stages {
        stage('Build & Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        # Build image using default Dockerfile
                        docker build -t $DOCKER_IMAGE:$BUILD_NUMBER -t $DOCKER_IMAGE:latest .
                        
                        # Login and Push
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE:$BUILD_NUMBER
                        docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy with Terraform') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']
                ]) {
                    dir('terraform') {
                        sh '''
                            terraform init
                            terraform apply -auto-approve \
                                -var="ami_id=$AMI_ID" \
                                -var="docker_image=$DOCKER_IMAGE:latest"
                        '''
                        script {
                            def appUrl = sh(
                                script: 'terraform output -raw application_url',
                                returnStdout: true
                            ).trim()
                            echo "Application deployed successfully at: ${appUrl}"
                        }
                    }
                }
            }
        }
    }
}
    
