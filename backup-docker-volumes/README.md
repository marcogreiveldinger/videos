## Docker volume backup 

How to backup docker volumes. Docker volumes can be a hassle to back up to another place.
I implemented my backup strategy with the help of the docker-volume-backup container.
Check out the offen/docker-volume-backup [github page](https://github.com/offen/docker-volume-backup).

My implementation is running just next to my other docker-compose stacks and from there it can access the volumes to be backed up, syncs them into another remote storage and also encrypts them with GPG.

[Link to the YouTube video](https://youtu.be/qlo0Z1I1DD0)

Project structure:
```
.
├── README.md
├── backup-configuration
│   ├── mongo-dump.env
│   └── uptime-kuma.env
├── backup.env
└── docker-compose.yml
```

### Prerequisites:
- [Docker](https://www.docker.com/)


[_docker-compose.yml_](docker-compose.yml)
```
...

  backup:
    image: offen/docker-volume-backup:v2
    container_name: backup
    restart: always
    env_file:
      - ./backup.env
    volumes:
      - ./backup-configuration:/etc/dockervolumebackup/conf.d
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - mongo-data:/backup/mongo-data-backup:ro
      - uptime-kuma:/backup/uptime-kuma-backup:ro

volumes:
  uptime-kuma:
    driver: local
  mongo-data:
    driver: local

```

- The docker container can be easily integrated into existing docker-compose files.
- The backup container needs access to the docker socket and the volumes to be backed up.
- The backup configuration is done via environment variables and a configuration file.
- The configuration file is mounted into the container via a volume.
- The configuration file is located in the backup-configuration folder.
- The environment variables are located in the backup.env file.