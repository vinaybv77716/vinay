
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage('Checkout SCM'){
            steps{
               sh 'pwd'
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform destroy --auto-approve'
                    }
                }
            }
        }
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the Infra using Terraform'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Creating/Destroying an EKS Cluster'){
            steps{
                script{
                    dir('eks') {
                    #############################   give your access key and secret acce key here
                         sh 'terraform apply '
                    }
                }
            }
        }
        stage('Deploying kool Application') {
            steps{
                script{
                    dir('eks') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster-1'
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f svc.yaml'
                    }
                }
            }
        }
    }
}
