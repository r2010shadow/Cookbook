#!/bin/bash
echo "starting to deploy the PROD_be_Java_0001"
function to_package_java(){

cd $WORKSPACE
mvn clean
if [[ $? -eq 0 ]]; then
	echo "mvn clean is finished"
else
	echo "mvn clean is failed,please check it again."
	exit 0
fi

mvn install -Dmaven.test.skip=true
if [[ $? -eq 0 ]]; then
	echo "mvn install is finished"
else
	echo "mvn install is failed,please check it again."
	exit 1
fi

cd $WORKSPACE/starrai-living
echo "update images"
docker build -t harbor.CN.com/COM/COM-stage:1.0.$BUILD_ID .
if [[ $? -eq 0 ]]; then
	echo "docker build is finished"
else
	echo "docker build is failed,please check it again."
	exit 2

fi


docker login -u USER -p PWD harbor.CN.com
if [[ $? -eq 0 ]]; then
	echo "docker login is finished"
else
	echo "docker login is failed,please check it again."
	exit 2

fi

docker push harbor.CN.com/COM-stage:1.0.$BUILD_ID
if [[ $? -eq 0 ]]; then
	echo "Push is finished"
else
	echo "Push is failed,please check it again."
	exit 3
fi
}

function to_deploy_living1(){
ansible living-0001 -m shell -a "docker rm -f living-stage"
ansible living-0001 -m shell -a " docker images|grep living-stage|awk '{ print $3 }'|xargs docker rmi  -f "
ansible living-0001 -m shell -a "docker login -u USER -p PWD harbor.CN.com"
ansible living-0001 -m shell -a "docker pull harbor.CN.com/living-stage:1.0.$BUILD_ID"
if [[ $? -eq 0 ]]; then
	echo "Pull is finished"
else
	echo "Pull is failed,please check it again."
	exit 3
fi


ansible living-0001 -m shell -a "docker run -it -d --name living-stage --restart=always -p 8001:8001 -v /root/java/log:/logs --network host --privileged=true  harbor.CN.com/living-stage:1.0.$BUILD_ID"
if [[ $? -eq 0 ]]; then
	echo "Run is finished"
else
	echo "Run is failed,please check it again."
	exit 3
fi
}

function to_rollback_living1(){
ansible living-0001 -m shell -a "docker rm -f  living-stage"
ansible living-0001 -m shell -a "docker login -u USER -p PWD harbor.CN.com"
ansible living-0001 -m shell -a "docker pull harbor.CN.com/$DOCKER_IMAGE"
if [[ $? -eq 0 ]]; then
	echo "Pull is finished"
else
	echo "Pull is failed, please check it again."
	exit 3
fi

ansible living-0001 -m shell -a "docker run -it -d --name living-stage --restart=always -p 8001:8001 -v /root/java/log:/logs --network host  --privileged=true  harbor.CN.com/$DOCKER_IMAGE"
if [[ $? -eq 0 ]]; then
	echo "Run is finished"
else
	echo "Run is failed,please check it again."
	exit 3
fi
}

main(){
	if [[ $Develop_flag == 'deploy' ]]; then
    to_package_java
		to_deploy_living1
	else
		to_rollback_living1
	fi
}
main
