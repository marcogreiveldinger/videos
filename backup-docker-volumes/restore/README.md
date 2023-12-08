## Docker volume restore after backup 

How to restore docker volumes. Docker volumes can be a hassle to back up to another place.
I implemented my backup strategy with the help of the docker-volume-backup container.
Check out the offen/docker-volume-backup [github page](https://github.com/offen/docker-volume-backup).
To restore them into new docker volumes, just follow some easy steps explained in the video and below.
You can also check out the official documentation [here](https://offen.github.io/docker-volume-backup/how-tos/restore-volumes-from-backup.html).

[Link to the YouTube video](https://youtu.be/FPiS6Cck4l0)

Project structure:
```
.
├── README.md
└── docker-compose.yml
```

### Prerequisites:
- [Docker](https://www.docker.com/)
- Existing docker volume backups (Check out the folder [../../backup-docker-volumes](../../backup-docker-volumes))


[_docker-compose.yml_](docker-compose.yml)
```
...

version: "3"
services:

  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime
    ports:
      - "3001:3001"
    volumes:
      - uptime-kuma:/app/data


# this section has to be changed after the restore to use an external docker volume
volumes:
  uptime-kuma:
    driver: local
    
###
# volumes:
#   uptime-kuma:
#     external: true

```


--------
My volume which I want to recover is named uptime-kuma in my original docker-compose file, so at step 4. you have to match this name.

1. Download backup from your remote storage
2. (optional)Decrypt backup with:
    1. `gpg -o backup.tar.gz -d backup.tar.gz.gpg`
3. Untar the backup you want to restore
    1. `tar -C . -xvf  backup.tar.gz`
        1. -C to create a new folder from the archive at my current working directory
        2. -x extract from archive
        3. -v verbose
        4. -f which file
4. Use a temp alpine container with the extracted volume mounted (pay attention to the volume name
    1. `docker run -d --name temp_restore_container -v uptime-kuma:/backup_restore alpine`
5. Copy the data into a volume
    1. `docker cp /path/to/your/files temp_restore_container:/backup_restore`
6. Stop and remove the restore container
    1. `docker stop temp_restore_container && docker rm temp_restore_container`
7. Restart your containers, with the restored backups and correct docker-compose file.

Congrats! You restored your docker volume with a backup successfully.