[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).

# PSA: Changes are happening

From August 2018 onwards, Linuxserver are in the midst of switching to a new CI platform which will enable us to build and release multiple architectures under a single repo. To this end, existing images for `arm64` and `armhf` builds are being deprecated. They are replaced by a manifest file in each container which automatically pulls the correct image for your architecture. You'll also be able to pull based on a specific architecture tag.

TLDR: Multi-arch support is changing from multiple repos to one repo per container image.

# [linuxserver/nextcloud](https://github.com/linuxserver/docker-nextcloud)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/nextcloud.svg)](https://microbadger.com/images/linuxserver/nextcloud "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/nextcloud.svg)](https://microbadger.com/images/linuxserver/nextcloud "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/nextcloud.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/nextcloud.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-nextcloud/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-nextcloud/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/nextcloud/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/nextcloud/latest/index.html)

[Nextcloud](https://nextcloud.com/) gives you access to all your files wherever you are.

Where are your photos and documents? With Nextcloud you pick a server of your choice, at home, in a data center or at a provider. And that is where your files will be. Nextcloud runs on that server, protecting your data and giving you access from your desktop or mobile devices. Through Nextcloud you also access, sync and share your existing data on that FTP drive at the office, a Dropbox or a NAS you have at home.


[![nextcloud](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/nextcloud-icon.png)](https://nextcloud.com/)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list). 

Simply pulling `linuxserver/nextcloud` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v6-latest |


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=nextcloud \
  -e PUID=1001 \
  -e PGID=1001 \
  -e TZ=Europe/London \
  -p 443:443 \
  -v </path/to/appdata>:/config \
  -v <path/to/data>:/data \
  --restart unless-stopped \
  linuxserver/nextcloud
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  nextcloud:
    image: linuxserver/nextcloud
    container_name: nextcloud
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Europe/London
    volumes:
      - </path/to/appdata>:/config
      - <path/to/data>:/data
    ports:
      - 443:443
    mem_limit: 4096m
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 443` | WebUI |
| `-e PUID=1001` | for UserID - see below for explanation |
| `-e PGID=1001` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-v /config` | Nextcloud configs. |
| `-v /data` | Your personal data. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```
  $ id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```


&nbsp;
## Application Setup

Access the webui at `<your-ip>:443`, for more information check out [Nextcloud][appurl].

Please note you will need a MySQL/MariaDB or other backend database to set this up.  Also please look [here](https://docs.nextcloud.com/server/11/admin_manual/installation/system_requirements.html#database-requirements-for-mysql-mariadb) for how to configure your database with regard to binlog format and installation.

If updating to nextcloud 12 you will need to comment out line `add_header X-Frame-Options "SAMEORIGIN";` in the file /config/nginx/site-confs/default



## Support Info

* Shell access whilst the container is running: `docker exec -it nextcloud /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f nextcloud`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' nextcloud`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/nextcloud`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/nextcloud`
* Stop the running container: `docker stop nextcloud`
* Delete the container: `docker rm nextcloud`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start nextcloud`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update the image: `docker-compose pull linuxserver/nextcloud`
* Let compose update containers as necessary: `docker-compose up -d`
* You can also remove the old dangling images: `docker image prune`

## Versions

* **28.01.19:** - Add pipeline logic and multi arch.
* **25.01.19:** - Add php7-phar for occ upgrades.
* **05.09.18:** - Rebase to alpine 3.8.
* **11.06.18:** - Use latest rather than specific version for initial install.
* **26.04.18:** - Bump default install to 13.0.1.
* **06.02.18:** - Bump default install to 13.0.0.
* **26.01.18:** - Rebase to alpine 3.7, bump default install to 12.0.5.
* **12.12.17:** - Bump default install to 12.0.4, fix continuation lines.
* **15.10.17:** - Sed php.ini for opcache requirements in newer nextcloud versions.
* **20.09.17:** - Bump default install to 12.0.3.
* **19.08.17:** - Bump default install to 12.0.2.
* **25.05.17:** - Rebase to alpine 3.6.
* **22.05.17:** - Update to nextcloud 12.0, adding required dependecies and note about commenting out SAMEORIGIN; line.
* **03.05.17:** - Use community repo of memcache.
* **07.03.17:** - Release into main repository and upgrade to php7 and Alpine 3.5.
