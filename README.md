
### Description
This is a basic nginx container built upon the alpine:latest image. You can use this container as a reverse proxy or to convert your connection into SSL. It supports a recent openssl version so you are able to use most, if not all, recent openssl features even if your base OS does not support it. I use this docker container myself for access to different web tools I host both internet and locally connectable. It also prevents you from having to expore multiple ports and/or IP addresses for every single site running in Docker.

### Sources
Base image: [ubuntu:focal](https://hub.docker.com/_/ubuntu/)  
Main software: [nginx](https://www.nginx.com/)
Packages: nginx, openssl, shadow, tzdata

### Usage

#### Docker Compose example
```
services:
  proxy:
    image: jerheij/proxy:stable
    container_name: proxy
    restart: always
    ports:
      - 80:80
      - 443:443
    environment:
      TZ: 'Europe/Amsterdam'
      UUID: 2002
      GUID: 2002
    volumes:
      - proxy/conf.d:/etc/nginx/conf.d
      - proxy/ssl:/etc/nginx/ssl
      - proxy/logs:/var/log/nginx
```
#### Volumes
The volumes mounted in the example above are to provide easy access to log files, easy access to the local SSL directory and easy access to configuration files without having to map every single file by itself. The only mount required is one that provides a basic configuration file.

#### Configuration
This container supports all basic functionality provided by nginx and configurable by nginx. 

#### SSL
In the example above I have mapped a volume to /etc/nginx/ssl in the container to be able to add all certificates to my SSL folder and link them through the configuration.

### Variables
| Variable | Function | Optional |
| --- | --- | --- |
| `TZ` | Timezone for PHP configuration | no |
|`UUID`| UID of the apache user, for mount and persistence compatibility | yes |
|`GUID`| GID of the apache group, for mount and persistence compatibility| yes |

### Changes
I have introduced a "stable" tag instead of the "latest". The "latest" tag will be the git "master" branch while the "stable" tag will be the latest git tag.

For changes in the different versions see my [github](https://github.com/jerheij/docker-proxy) repo's commit messages.

### Author
Jerheij
