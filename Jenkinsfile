#!/usr/bin/env groovy
pipeline {
  
def BUILD_TAG="v9" 

agent any  
  
  stages {
 
	
    stage('checkout') {
		steps{
		script {
		git credentialsId: 'e0c038d8-5106-4d22-87e5-16b018816ef7', url: 'https://github.com/jvaibhav123/pythonapp.git'
		}
	   }	
	}
	
	
	stage('Build Plus Push')
	{
	  steps{
	  
	  script {
		withCredentials([usernamePassword(credentialsId: 'dockkerhub', passwordVariable: 'DOCKERPWD', usernameVariable: 'DOCKERUSER')]) {
		echo "Build tag ${env.BUILD_TAG}"
		if ("${BUILD_TAG}" != ""){
		stage('Build Docker image')
		{
			sh """
			docker login --username $DOCKERUSER --password $DOCKERPWD
			echo "Docker login successful"
		
			echo "Docker build image"
			docker build -t $DOCKERUSER/demoapp:${BUILD_TAG}
			
			
			"""
			
		}
	
		 stage('Test the image'){

                   sh """

                   echo "Run container with latest image"
                   docker run -itd --name test_image -p 6000:5000 -l app=testimage $DOCKERUSER/demoapp:${BUILD_TAG}
                   echo "docker container successfully  started"
                   if [ `curl -s -o /dev/null -w "%{http_code}\n" http://0.0.0.0:5000/` -eq 200 ]
                   then
                                        echo "Docker image successfully running"
                   else
                                        echo "Something wrong"

                   fi

                   docker stop \$(docker ps --filter="name=test_image" -q )
                   docker rm \$(docker ps --filter="name=test_image" -q )
                   """


                 }
	

		 stage('Push to docker hub'){
		 sh """
		 echo "Push docker image"
		 docker push $DOCKERUSER/demoapp:${BUILD_TAG}
		 echo "Push completed successfully"
		 """
		 }
		 
		 
		 stage('Deploy the image'){
		 
		 sh """
		 echo "Deploy Image on server"
		 docker run -itd --name app_latest_version -p 5000:5000 -l app=demoapp -l version=${BUILD_TAG} $DOCKERUSER/demoapp:${BUILD_TAG}
		 
		 docker stop \$(docker ps --filter="app=demoapp" -q | grep -v ${BUILD_TAG} )
		 docker rm \$(docker ps --filter="app=demoapp" -q | grep -v ${BUILD_TAG} )
		 
		 
		 """
		 }
		  
			
		}
		}

	}
	
	}
	
	}
	
}



}


