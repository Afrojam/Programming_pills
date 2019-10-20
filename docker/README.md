# Docker recipes and tricks

## Clearing docker

In order to clear unsued volumes, containers, logs, etc:
```
docker system prune --volumes --all
```

## Clearing docker logs

Some times a virtual machine used as host for docker containers can run out of space because the size of the docker logs. The following command forces to clean the logs:
```
sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log"
```

## Stop all containers

```
docker stop $(docker ps -a -q)
```

## Remove all containers
```
docker rm $(docker ps-a -q)
```

##Remove all images
```
docker rmi $(docker images -q)
```


