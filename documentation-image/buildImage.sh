#!/bin/bash
DIRECTORY=$(cd `dirname $0` && pwd)
cd $DIRECTORY

set -e
source ./env

echo "##################################"
echo -e "$BLUE Test internet / proxy $NC"

status=$(curl -s -o /dev/null -w "%{http_code}" http://www.google.be)
if [ $status != 200 ]; then echo $status; echo -e "\e[1;31m $REGISTRY down \e[0m"; exit 1;fi;
echo -e "\e[1;32m $status \e[0m"

echo -e "$BLUE Test registry $NC"

status=$(curl -s -o /dev/null -w "%{http_code}" http://$REGISTRY)
if [ $status != 200 ]; then echo $status; echo -e "\e[1;31m $REGISTRY down \e[0m"; exit 1;fi;
echo -e "\e[1;32m $status \e[0m"

echo "\n##################################"
echo -e "$BLUE Image to pull : $GREEN" $IMAGE_SRC:$TAG_SRC "$NC"
docker pull $IMAGE_SRC:$TAG_SRC

echo "##################################"
echo -e "$BLUE Tag Image : $GREEN" $REGISTRY/$IMAGE_SRC:$TAG_SRC "$NC"
docker tag $IMAGE_SRC:$TAG_SRC $REGISTRY/$IMAGE_SRC:$TAG_SRC

echo "##################################"
echo -e "$BLUE Push : $GREEN" $REGISTRY/$IMAGE_SRC:$TAG_SRC "$NC"
docker push $REGISTRY/$IMAGE_SRC:$TAG_SRC

echo "##################################"
echo -e "$BLUE Remove : $GREEN" $IMAGE_SRC:$TAG_SRC "$NC"
docker rmi $IMAGE_SRC:$TAG_SRC

echo "##################################"
echo -e "$BLUE Generate Dockerfile $NC"
echo "# Don't edit this file, user DockerfileTemplate and buildImage.sh" > Dockerfile
echo "###############################################" >> Dockerfile
$(REGISTRY=$REGISTRY IMAGE_SRC=$IMAGE_SRC TAG_SRC=$TAG_SRC envsubst < DockerfileTemplate >> Dockerfile)

echo "##################################"
echo -e "$BLUE Build and push $GREEN $REGISTRY/$IMAGE_DEST-$POSTFIX:$TAG_DEST $NC"
docker build -t $REGISTRY/$IMAGE_DEST-$POSTFIX:$TAG_DEST .
docker push $REGISTRY/$IMAGE_DEST-$POSTFIX:$TAG_DEST

echo "##################################"
echo -e "$BLUE Remove : $GREEN" $IMAGE_SRC:$TAG_SRC "$NC"
docker rmi $REGISTRY/$IMAGE_SRC:$TAG_SRC

echo "##################################"
echo -e "$BLUE List images $NC"
docker images | grep $IMAGE_DEST
