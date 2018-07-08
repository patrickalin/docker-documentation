#!/bin/bash
# v0.4
DIRECTORY=$(cd `dirname $0` && pwd)
cd $DIRECTORY

set -e


SERVICE="$(basename `pwd` | cut -d'-' -f 2)"
IMAGE="$SERVICE-image"

if [ -d "$IMAGE" ]; then
source ./$IMAGE/env
FROM="($IMAGE_SRC : $TAG_SRC)"
OPTION=$(whiptail --title $SERVICE --menu "Choose your option" 15 60 4 \
"1" "Build from $FROM" \
"2" "(Re)Start service $SERVICE" \
"3" "Stop service $SERVICE" 3>&1 1>&2 2>&3)
else
OPTION=$(whiptail --title $SERVICE --menu "Choose your option" 15 60 4 \
"2" "(Re)Start service $SERVICE" \
"3" "Stop service $SERVICE" 3>&1 1>&2 2>&3)
fi

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $OPTION
else
    echo "You chose Cancel."
fi

case "$OPTION" in

1)  $IMAGE/buildImage.sh
    echo "######################"
    source $IMAGE/env
    ;;
2)  docker stack remove  $SERVICE
    sleep 3
    docker stack deploy --compose-file docker-compose.yml $SERVICE
    if [ -d "$IMAGE" ]; then
    echo "######################"
    source $IMAGE/env
    fi
    ;;
3)  docker stack remove  $SERVICE
    ;;
esac
