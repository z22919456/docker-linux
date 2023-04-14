imageName=linux/rockey
containerName=rockey

build: 
	docker build -t $(imageName) .

stop: 
		docker stop  $(containerName) || true

rm:
		make stop
		docker rm  $(containerName) || true

start: 
		docker run -d -t -p 8001:22 -p 3000:3000 --name  $(containerName) $(imageName) /bin/bash
		docker exec -d $(containerName) bash -c "sh /root/start.sh"

restart:
		docker restart $(containerName)

root: 
		make stop
		docker run -t -i -p 8001:22 --name $(containerName) $(imageName)  /bin/bash 

login: 
		ssh  z01241@localhost -p 8001