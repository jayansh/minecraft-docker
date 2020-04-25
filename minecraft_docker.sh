#!/bin/bash 
usage() {
echo "$0 usage:" && grep ".)\#" $0
echo "e.g1. ./minecraft_docker.sh -c build"
echo "e.g2. ./minecraft_docker.sh start"
echo "e.g2. ./minecraft_docker.sh stop"
#echo "e.g3. ./minecraft_docker.sh start -i 2"
#echo "e.g4. ./minecraft_docker.sh stop -i 2"
 exit 0;
}

init() {
    IMAGE_NAME_OBIE_DIR="minecraft-server:latest"
}

build() {
    echo -n "do you confirm building docker y/n>"
      read response
         echo "response = $response"
     case $response in 
           n ) echo "Aborting"; exit 1
           ;;
           y ) echo "press any key to start build"
           ;;
           *) echo "Aborting"; exit 1
           ;;
        esac
        read dummy

    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

    init
    
    itpp_dir=$(pwd)
    echo  $itpp_dir
     ##WARNING Make sure you won't use docker-compose down with -v option, otherwise it will delete the mysql data volume and all data will be lost.
    docker-compose down
    docker-compose up -d
    docker images

    docker build -t=$IMAGE_NAME_OBIE_DIR .
    echo "build success"
}

start()
{
        echo "mode: ${mode} instance: ${2}"
    itpp_dir=$(pwd)
        hostname=`hostname`
        response='n'
        echo -n "do you confirm to start  docker instance: $2 on host=$hostname y/n> "
          read response
         echo "response = $response"
        case $response in
           n ) echo "Aborting"; exit 1
           ;;
           y ) echo "press any key to start the cluster"
           ;;
           *) echo "Aborting"; exit 1
           ;;
        esac
        read dummy

    init
    docker-compose up -d
    docker ps
}
stop()
{       
    echo "instance: ${2}"
    itpp_dir=$(pwd)
        echo -n "do you confirm to stop  docker instance: $2 on host=$hostname y/n> "
          read response
         echo "response = $response"
        case $response in
           n ) echo "Aborting"; exit 1
           ;;
           y ) echo "press any key to start the cluster"
           ;;
           *) echo "Aborting"; exit 1
           ;;
        esac
    read dummy

    init
    docker-compose down -v
    docker ps
}

restart()
{       
    echo "instance: ${2}"
    itpp_dir=$(pwd)
        echo -n "do you confirm to restart  docker instance: $2 on host=$hostname y/n> "
          read response
         echo "response = $response"
        case $response in
           n ) echo "Aborting"; exit 1
           ;;
           y ) echo "press any key to start the cluster"
           ;;
           *) echo "Aborting"; exit 1
           ;;
        esac
    read dummy
    init
    docker-compose down -v
    docker-compose up -d
        docker ps
}

ps()
{
    docker-compose ps
}

delete() {
    #!/bin/bash
    echo -n "do you confirm to delete all docker containers and images y/n> "
        read response
        echo "response = $response"
        case $response in
           n ) echo "Aborting"; exit 1
           ;;
           y ) echo "press any key to start the cluster"
           ;;
           *) echo "Aborting"; exit 1
           ;;
        esac
    # Delete all containers
    docker rm $(docker ps -a -q)
    # Delete all images
    docker rmi $(docker images -q)
}

while getopts "c:h:m:g" arg; do
  case $arg in
    c) # Specify the command you want to execute: build/start/stop/restart/ps`
      command=${OPTARG}
      [ $command == "build" ] || [ $command == "start" ] || [ $command == "stop" ] || [ $command == "restart" ] || [ $command == "delete" ]|| [ $command == "ps" ]\
        && echo "command  is $command  " \
        || echo "command  must be either build or start/stop/restart/delete/ps " 
      ;;
    m) # Specify the mode you want to execute: test/prod`
      mode=${OPTARG}
      [ $mode == "test" ] || [ $mode == "prod" ]\
        && echo "mode  is $mode  " \
        || echo "mode  must be either test or prod " 
      ;;
    h | *) # Display help.
      usage
      exit 0
      ;;
  esac
done

case $command in
     build) build $mode;
     ;;
     start) start $mode $inst
     ;;
     stop) stop $mode $inst
     ;;
     restart) restart $mode $inst
     ;;
     delete) delete $mode $inst
     ;;
     ps) ps
     ;;
     logs) logs $inst
     ;;
esac


