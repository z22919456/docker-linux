imageName=linux/rockey
containerName=rockey-2
username=Arthur

build: 
	docker build -t $(imageName) .

stop: 
		docker stop  $(containerName) || true

rm:
		make stop
		docker rm  $(containerName) || true
		sed -i '' '/^\[localhost\]:8001/d' ~/.ssh/known_hosts

start: 
		docker run -d -t -p 8001:22 -p 3000:3000 --name  $(containerName) $(imageName) /bin/bash
		docker exec -d $(containerName) bash -c "sh /root/start.sh"

restart:
		docker restart $(containerName)

root: 
		make stop
		docker run -t -i -p 8001:22 --name $(containerName) $(imageName)  /bin/bash 

login: 
		ssh  ${username}@localhost -p 8001