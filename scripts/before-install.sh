command_exists() {
        command -v "$@" > /dev/null 2>&1
}
if command_exists docker; then
                version="$(docker -v | awk -F '[ ,]+' '{ print $3 }')"
                MAJOR_W=1
                MINOR_W=10
		echo 'Docker is already installed'

else
		echo 'Installing Docker'
                sudo yum update -y
                sudo yum install -y docker
                sudo service docker start
fi

echo 'Start Docker if not already running'
service=docker

if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
then
echo "$service is running!!!"
else
sudo service docker start
fi

echo 'Killing any container of the old Docker image'
if [[ $(sudo docker ps -a -q --filter ancestor=njetty/registry --format="{{.ID}}") ]]; then
	docker rm $(docker stop $(docker ps -a -q --filter ancestor=njetty/registry --format="{{.ID}}"))
fi
	
echo 'Pulling a new image from docker'
docker pull njetty/registry

echo 'Removing the previous image'
sleep 30
sudo docker rmi $(sudo docker images | grep "^<none>" | awk '{print $3}')