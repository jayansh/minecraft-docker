FROM openjdk:8-jdk-alpine
#LABEL maintainer="jayanshs@jayanshs@jaysan.in"
MAINTAINER Jayansh Shinde "jayanshs@jaysan.in"
VOLUME /tmp
EXPOSE 25565
# The server's jar file
ARG JAR_FILE=target
# Add the application's jar to the container
ADD ${JAR_FILE} target
ENTRYPOINT ["java","-jar", "-Xmx1024M", "-Xms1024M","target/minecraft_server.1.15.2.jar", "nogui"]
