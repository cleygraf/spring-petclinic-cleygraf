FROM openjdk:22-bullseye

EXPOSE 8888

# copy jar into image
COPY target/spring-petclinic-3.1.0-SNAPSHOT.jar /usr/bin/spring-petclinic-cleygraf.jar

# run application with this command line 
ENTRYPOINT ["java","-jar","/usr/bin/spring-petclinic-cleygraf.jar","--server.port=8888"]