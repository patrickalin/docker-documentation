#!/bin/bash

SERVICE="documentation"

OPTION=$(whiptail --title $SERVICE --menu "Choose your option" 15 60 4 \
"1" "Start service $SERVICE"  \
"2" "Restart service $SERVICE" \
"3" "Stop service $SERVICE" 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $OPTION
else
    echo "You chose Cancel."
fi

case "$OPTION" in

1)  docker stack deploy --compose-file docker-compose.yml $SERVICE
    ;;
2)  docker stack remove  $SERVICE
    sleep 3
    docker stack deploy --compose-file docker-compose.yml $SERVICE
    ;;
3)  docker stack remove  $SERVICE
    ;;
esac
