# Deploy _Spring PetClinic Sample Application_ with Jenkins

## Overview
The purpose of this project is to show, how easily Jenkins can be used to build container images of the [Spring PetClinic Sample Application](https://github.com/spring-projects/spring-petclinic). These images are pushed to a [hub.docker.com](https://hub.docker.com/repository/docker/chrisley/spring-petclinic-cleygraf/) repository. 

This repository contains all the configuration files to set up your own Jenkins server in a docker container.

There are a few requirements:

- A docker host: This is typically an x86 LINUX system running `dockerd`. You should also be able to use MacOS (x86/arm) or Windows. But this hasn't been tested.
- Credentials for "hub.docker.com". If you prefer to use a different container registry, please adjust the `Jenkinsfile` and use the appropriate credentials.   


### Technical overview
The standard Jenkins image comes without docker support to build docker images locally. To build docker images locally, a "sidecar" container is used. This container is configured to use "Docker IN Docker" ("dind" in short) to start, stop and build containers.

Furthermore, there is no `docker` command available in the standard Jenkins image. A custom Jenkins image with the docker-cli installed is required.

Reference: [Jenkins - Docker ](https://www.jenkins.io/doc/book/installing/docker/#docker)

### Install Jenkins

The files required to start Jenkins on a host that has docker installed (a x86 VM with NixOS is used in my case) are in the `jenkins` directory`:

- `Dockerfile`: This file is used to build a custom Jenkins image
- `docker-compose.yml`: This file is used to spin up all the two containers, including all resources (network & volumes).

First, login into your docker host. This is usually a LINUX host with `dockerd` running.

Run `git clone https://github.com/cleygraf/spring-petclinic-cleygraf.git` to clone the repository. Change into the newly created directory with `cd spring-petclinic-cleygraf/`.

Go into the `jenkins` directory with `cd jenkins` and run `docker build -t myjenkins-blueocean:2.414.3-1 .`. This will build the Jenkins container for you.

The next step is to start the containers. Please execute `docker compose up -d`.

The Jenkins webui is now available on port 8080 of your docker host. Open `http://DOCKER_HOST_IP:8080` in your browser (Change "DOCKER_HOST_IP" to the hostname or ip of your docker host). If you like, you can add a loadbalancer like NGINX to achieve TLS termination and routing, but this is optional.

In the webui you first have to log in with the admin password. You have to retrieve this password by running `docker exec jenkins-jenkins-1 cat /var/jenkins_home/secrets/initialAdminPassword`. Follow the initial steps to set up Jenkins.

To later push docker images to [hub.docker.com](https://hub.docker.com/), we need to configure your credentials first. Goto "Manage Jenkins" -> "Credentials" -> "System" -> "Global credentials (unrestricted)" and create a credential of the type "Username with password". Enter your "Username" and "Password". The "ID" has to be `dockerhub`. Leave the rest and save.

By default, the `mvn` command is not available for the pipelines. To fix this, we need to go to "Dashboard" -> "Manage Jenkins" -> "Tools". Click "Add Maven" and enter `3.9.5` as the "Name". Check if "Version" is "3.9.5". That's the default as of the time of writing. Choose "3.9.5" if your version differs. Leave the rest and click "Save".

### Create a project and run the pipeline

Go back to the "Dashboard" and choose "New item" to configure your first project. Enter a name, select "Pipeline" and click "OK". On the next page, go to "Pipeline" and select "Pipeline script from SCM". Select "Git" as "SCM". Enter the "Repository URL": `https://github.com/cleygraf/spring-petclinic-cleygraf` and change the "Branch Specifier" to `*/main`. That's all we need to change. Click "Save". As result the Jenkins that is part of the repository is used for the pipeline.

Go back to the "Dashboard" and select the "spring-petclinic-cleygraf" project we have created before. Click on "Build Now" on the left side of the screen. The pipeline will kick off. 

### Run _Spring PetClinic Sample Application_ container

Once the pipeline has finished successfully, you can start the resulting container with `docker run -p 8888:8888 chrisley/spring-petclinic-cleygraf -d`. The _Spring PetClinic Sample Application_ is now available: http://DOCKER_HOST_IP:8080 (Change "DOCKER_HOST_IP" to the hostname or ip of your docker host).

Use `docker pull chrisley/spring-petclinic-cleygraf` to just pull the image for inspection.


#### Addendum

#### Additions to the _Spring PetClinic Sample Application_

I have added the following files:

- `Jenkinsfile`: The pipeline definition
- `README.md`: This file
- `jenkins/Dockerfile`: The docker file for the custom Jenkins container
- `jenkins/docker-compose.yml`: File to use with `docker compose` to start two containers and the required ressources.