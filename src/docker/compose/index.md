# Docker Compose

Docker Compose is a very beloved tool among developers, in fact, many coded projects on the Internet come with a `docker-compose.yml` file already in the root of their code repository. This file contains all the information needed to start a project. This allows a developer to get started quickly without spending hours installing services such as databases.

For us, Docker Compose is going to help us automate setting up different Docker containers as well as being able to manage and document them as code.

![Docker Compose logo](./logo.png)

Docker Compose is a Docker tool that supports the [compose specification](https://compose-spec.io/). This specification has become an open standard based on [Docker Compose](https://docs.docker.com/compose/).

This course uses Docker Compose v2.
Version 2 is an enhanced version of V1, but has many differences.
Version 1 was written in Python and had the separate command `docker-compose`. Version 2 is now written in Go (just like Docker) and is a plugin for Docker itself with the command `docker compose`. Pay close attention to this when looking up information!

## Installation

New installations of Docker on Windows, Mac and Linux already include Compose v2. You should be ready to go! Execute `docker compose` and you should get some help info.

:::warning This only applies to older Docker installation, for which you had to install the `docker-compose` tool seperately.
We install Docker Compose by downloading the binary and installing it under the plugins directory of Docker:

```bash
wget https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64
chmod +x docker-compose-linux-x86_64
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo mv docker-compose-linux-x86_64 /usr/local/lib/docker/cli-plugins/docker-compose
```

Now do `docker-compose` and you should get an explanation.
:::

## docker-compose.yml

For Docker Compose, we are always going to encounter 1 file: `docker-compose.yml`. This is a [YAML](../yaml) file that is going to contain all the information for Docker Compose including: volumes, services and networks.

### Versions

docker-compose.yml has several versions, which we always specify at the beginning of the file. This is a practice we also see in many other tools such as Kubernetes so that all tooling can support multiple versions.
However with compose this is the version of the compose specification and not that can the tool!

We write all our files in version 3.x, version 2.0 we still see often and still works most of the times but is outdated.

### File

The `docker-compose.yml` file has 3 main parts:

- `version`: Version of the compose file.
- `services`: The containers to run
- `networks`: The networks to be created
- `volumes`: The volumes to use

This is an example of a Docker Compose file from last week's Wordpress setup.

```yaml
version: "3.9"
networks:
  wordpress: {}

volumes:
  db-data: {}

services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "8091:80"
    depends_on:
      - db
    networks:
      - wordpress

  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: test
      MYSQL_DATABASE: wordpress
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - wordpress
```

We take a quick look at each component:

```yaml
version: "3.9"
```

We are using version 3.9 of the Compose specification. You can see what's in here on the [Compose file reference](https://docs.docker.com/compose/compose-file/compose-file-v3/). This is a very useful reference when creating compose files.

```yaml
networks:
  wordpress: {}
```

This is a list of networks we need within Docker, which we did manually with `docker network create`. We need no further configuration so we give an empty object `{}`. This can also be omitted but is less obvious.

```yaml
volumes:
  db-data: {}
```

This is very similar to what we did with networks, this does almost the same thing for volumes.
Whereas last lesson we were mainly going to put our files in their own directory, here we are telling Docker to create its own empty volume for our data. This volume is also maintained only Docker chooses its own internal locale for this so it does not depend on the file structure of a server or laptop.

```yaml
services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "80:80"
    depends_on:
      - db
    networks:
      - wordpress
```

All of our containers are Services. In Docker Compose, we usually talk about multiple containers. Each of these has a name and properties. Here we define the containers that our container needs image `wordpress`, must expose port 80 and uses network `wordpress`. `depends_on` is new, this lets Docker Compose determine which containers to start first. For example, the database is going to be created first because WordPress is going to connect to it. With `restart: always` we set that this container should also start after a reboot.

```yaml
services:
  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: test
      MYSQL_DATABASE: wordpress
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - wordpress
```

For our database we see the same story. Only here we have added `environment` with which we can set our environment variables, also we link `volumes` to the directory where our database resides.

### Proprietary images

Docker Compose can also work with custom images, which are built at startup.

We do this by defining `build`:

```yaml
services:
  my-container:
    build: .
```

Do you need to build multiple container images? You can do that too, only you need to specify more where Docker can find the Dockerfile and files.

```yaml
services:
  my-container:
    build:
      context: ./dir
      dockerfile: Dockerfile
```

## docker compose command

Now that we know how to write our configuration we can get started!

We place our `docker-compose.yml` file in a new directory.

```bash
mkdir wordpress
cd wordpress
# Place the docker compose file here
```

The name of the folder is also going to use Docker Compose as the name of the setup.

### `docker compose up`

Now that we have our file ready we can start everything with `docker compose up`.
This is going to create and start all of our resources.

```bash
docker compose up
```

This starts up our Wordpress environment and we can start viewing it with the browser.

Like Docker itself, we can also use ``docker compose up -d`` for background startup. Docker also restarts these containers when the server reboots if `restart: always` is in the file!

```bash
$ docker ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
ed81d91b7005 wordpress:latest "docker-entrypoint.s..."   2 hours ago Up 3 seconds 0.0.0.0:8091->80/tcp, :::80->80/tcp wordpress-wordpress-1
3b3451265a84 mariadb:latest "docker-entrypoint.s..."   2 hours ago Up 4 seconds 3306/tcp wordpress-db-1
```

In `docker ps` we now see that the containers are running. They have also all been named with the directory name, container name and the number 1. We can also use Docker compose to run multiple replicas of 1 container if we want to.

> **Note:** the name you use to link containers together is simply the short name you specified in the `docker-compose.yml` file.

### `docker compose stop`

Is a Docker compose setup running in the background roof you can stop it with `docker compose stop`.

### `docker compose restart`

Is a service running and you want to load new configuration? Then you can use `docker compose restart` to restart all containers and load changes.

```bash
$ docker compose restart
[+] Running 2/2
 ⠿ Container wp-db-1 Started 0.7s
 ⠿ Container wp-wordpress-1 Started 1.5s
```

### `docker compose down`

The down command is a dangerous one, `down` stops all containers and **throws out** all data.
Use this only locally or if you want to reset everything.

### `docker compose build`

If you use custom images and want to update them you must use `docker compose build`.

## Compose files

Many projects already come with a basic compose file present. We are going to write our own compose files for the project. Don't have any inspiration yet? Then [Awesome Compose](https://github.com/docker/awesome-compose) is a good reference, here are several ready-made stacks that you can customize!

## References

- Docker Compose file v3 https://docs.docker.com/compose/compose-file/compose-file-v3/#environment
- Get started with Docker Compose https://docs.docker.com/compose/gettingstarted/
