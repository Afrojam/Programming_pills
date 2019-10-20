# Docker recipes and tricks

## General

### Clearing docker

In order to clear unsued volumes, containers, logs, etc:
```
docker system prune --volumes --all
```

### Clearing docker logs

Some times a virtual machine used as host for docker containers can run out of space because the size of the docker logs. The following command forces to clean the logs:
```
sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log"
```

### Stop all containers

```
docker stop $(docker ps -a -q)
```

### Remove all containers
```
docker rm $(docker ps-a -q)
```

###Remove all images
```
docker rmi $(docker images -q)
```

## Docker + Make
When building a new image where our container needs to communicate with other containers we can do the following in a makefile:

1. Capture the IP of the docker bridge (docker0)
```
DOCKER_LOCALHOST=$(shell ip addr show docker0 | grep -Po 'inet \K[\d.]+')
```
2. Build our custom image
```
docker build -t $(DOCKER_CONTAINER_NAME)
```
3. Run our custom image calling *--add-host* with each of the other containers ids.
```
docker run -it \
	    --add-host container1:$(DOCKER_LOCALHOST) \
	    --add-host container2:$(DOCKER_LOCALHOST) \
	    --name $(DOCKER_CONTAINER_NAME) \
	    --env-file envfile.env \
	    --rm $(DOCKER_CONTAINER_NAME)
```
