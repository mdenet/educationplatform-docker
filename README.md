# Dockerized Education Platform
This is a dockerized version of the education platform for trying out the platform locally.

Further details on the platform can be found on the main [platform wiki page](https://github.com/mdenet/educationplatform/wiki).

Any bugs, feature requests, or suggestions can be added to the [issue tracker](https://github.com/mdenet/educationplatform/issues).

## Prerequisites 
### Core
 1. [GIT](https://git-scm.com/)
 2. [Docker](https://www.docker.com/)
 3. [Docker Compose](https://docs.docker.com/compose/install/)

### System
1. Disk space - 20 GB 
2. Memory - 3 GB

If using a linux based virtual machine, the minimum recommended settings of 3GB system memory and 30GB virtual disk should be used.

## Checkout the repository
Use either command to clone the repository and all of its submodules.

**Via https -**
```
git clone --recurse-submodules https://github.com/mdenet/educationplatform-docker.git
```

**Via ssh -** 
```
git clone --recurse-submodules git@github.com:mdenet/educationplatform-docker.git
```

> Note that for ssh access you must [configure](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) your account with a key.

## Build and run the docker image
This builds the docker images and starts the platform servers.
```
cd ./educationplatform-docker

docker compose up --build 
```

> Note it may take approximately 10 minutes the first time the platform is built.


## Access the platform

Once docker has [started](#build-and-run-the-docker-image) the containers, the platform will be available at http://127.0.0.1:8080

**403 Error**

If a 403 forbidden permissions error is encountered, the permission of the files used in the docker volumes must be configured. For linux based system run the following command from the `educationplatform-docker` directory.

``` 
chmod -R 755 {public,educationplatform-examples} 
```

## Stopping the platform

To safely stop the platform use `ctrl - c`
