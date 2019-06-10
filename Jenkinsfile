pipeline {
    agent any
    environment {
      registry = "sudheshpn/carts"
      registryCredential = 'docker_hub_login'
} 
    tools {
      maven 'Maven 3.5.4'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'mvn -Dmaven.test.failure.ignore=true clean compile'
            }
            }

        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'mvn -Dmaven.test.failure.ignore=true test'
            }
        }
        stage('Package') {
            steps {
                echo 'Packaging....'
                sh 'mvn -DskipTests package'
                archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            }
        }
        stages {
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    checkout scm  
                    def customImage = docker.build("sudheshpn/carts:${env.BUILD_ID}", ".") 
                    customImage.push()
                    customImage.push('latest')
                    }
                }
            }
        
    stage('DeployToProduction') {
            when {
                branch 'master'
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                //implement Kubernetes deployment here
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    kubeConfig: [path: '/var/lib/jenkins/workspace/.kube/config'],
                    configs: 'carts.yaml',
                    enableConfigSubstitution: true
                )
            }
        }
    }
}
}
