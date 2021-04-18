def WEB_STATUS_CODE = 0

pipeline {
    agent any   // to run pipeline job on any Node available (incl. Master)
    
    environment {
        DEV_EMAIL = 'sarthaksharma575@gmail.com'
        ADMIN_EMAIL = 'sarthaksharma10022000@gmail.com'
    }
    
    stages {
        stage('BUILD') {
            steps {
                git branch: 'master', url: 'https://github.com/sarthakSharma5/webapp.git'
            }
            post {
                success {
                    sh '''
                        if sudo ls / | grep mdHack
    	                then
    	                    echo "dir exists, copying code"
    	                else
    	                    sudo mkdir /mdHack
    	                fi
    	                    sudo cp -rvf *.html Dockerfile /mdHack/
                    '''
                }
                failure{
	                emailext body: '''
	                    Check console output to view the results.\n\n 
	                    ${CHANGES}\n 
	                    --------------------------------------------------\n
	                    ${BUILD_LOG, escapeHtml=false}
	                ''', 
	                to: "${DEV_EMAIL}", 
	                subject: 'Build failed in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER'
	            }
            }
        }
        
        stage('TEST') {
            steps {
                sh '''
                    sudo docker build -t mdtest:latest .
                    if sudo docker ps -a | grep test-webapp
                    then
                        sudo docker stop test-webapp
                        sudo docker rm test-webapp
                    fi
                    sudo docker run -dit -p 85:80 -v /mdHack:/var/www/html --name test-webapp mdtest:latest
                '''
                sleep 5
                script {
                    WEB_STATUS_CODE = sh returnStatus: true, script: 'curl -o /dev/null -s -w "%{http_code}" -i 0.0.0.0:85'
                }
                sh '''
                    sudo docker stop test-webapp
                '''
            }
        }
        
        stage('PUBLISH') {
            when {
                expression {
                    WEB_STATUS_CODE == 0
                }
            }
            steps {
                sh '''
                    sudo docker tag mdtest:latest sarthaksharma5/mdwebapp:latest
                    sudo docker push sarthaksharma5/mdwebapp:latest
                '''
            }
            post {
                success {
                    echo 'Code Passed .. Mail Dev'
                }
                failure {
                    echo 'Code Passed .. Mail Admin'
                }
            }
        }
        
        stage('DEPLOY') {
            when {
                expression {
                    WEB_STATUS_CODE == 0
                }
            }
            agent {
                label 'AWS-MDHack'
            }
            steps {
                echo 'Deploying ...'
                sh 'date'
                sh '''
                    if docker ps -a | grep prod-mdhack
                    then
                        docker stop prod-mdhack
                        docker rm prod-mdhack
                    fi
                    docker run -dit -p 85:80 --name prod-mdhack sarthaksharma5/mdwebapp:latest
                '''
            }
        
            post{
        	   success{
        	        echo 'Deployment success'
        	   }
        	   failure{
        	        echo 'Deployment failed, mailing Admin ...'
        	        emailext body: '''
                        Deployment failed
                        Last update by: ${DEV_EMAIL}
                        Check console output to view the results.\n\n 
                        ${CHANGES}\n 
                        --------------------------------------------------\n
                        ${BUILD_LOG, escapeHtml=false}
                        \n\nPipeline failure ''',
                to: "${ADMIN_EMAIL}",
        	    subject: 'Build FAILED in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER'
        	    }
        	}
        }
    }
}
