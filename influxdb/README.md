# Influxdb recipes

## Docker and Backup/Restore for older versions

Dealing with older versions of influxdb (i.e. 1.3) it can be a little tricky the step to restore a database.

### Create backup
```
docker exec -it *influx_container_id* influxd backup -database *db_to_backup* *backup_directory*
```

This command creates a backup of the specified *db_to_backup* in the directory inside the influx container.
In order to restore it in another influx container (or the same), it is needed that we copy the backup directory into the host machine.

```
docker cp *influx_container_id*:/*backup_directory* *local_backup_directory*
```

In our *local_backup_directory* we will have files starting with **db_to_backup**.autogen* and a meta.00 file.

### Restore backup

In older versions of influx, in order to restore a database, it is a must to stop the service. This prevents the posibility to restore from inside the container. The workaround is to stop the service and modify the image of our influx container adding a volume where the local_backup is and executing the command for restore in the same command that modifies the image.

```
docker run --rm \
 --entrypoint /bin/sh \
 -v *influx_data_dir*:/var/lib/influxdb \
 -v *backup_directory*:*/backups* \
 *influx_container_id* \
 -c "influxd restore -metadir /var/lib/influxdb/meta -datadir /var/lib/influxdb/data -database *db_name_where_restore* /backups/*backup_directory"
```
Notes about the command:
**--entrypoint**: sh or bash.
**-v influx_data_dir**: Volume where our influxdb data is stored. Be aware that docker-compose prepends directory name to named volumes. Also, remember that -v takes absolute path.


