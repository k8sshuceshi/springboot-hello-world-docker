pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo '运行构建自动化'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'build/libs/spring-boot-0.0.1-SNAPSHOT.jar'
            }
        }
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build("k8sshuceshi/springboot-hello-world-docker")
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
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
                withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no '$USERNAME'@$production_ip \"docker pull k8sshuceshi/springboot-hello-world-docker:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no '$USERNAME'@$production_ip \"docker stop springboot-hello-world-docker\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no '$USERNAME'@$production_ip \"docker rm springboot-hello-world-docker\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no '$USERNAME'@$production_ip \"docker run --restart always --name springboot-hello-world-docker -p 8080:8080 -d k8sshuceshi/springboot-hello-world-docker:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
    }
}
