#!/bin/bash

running_container_id=`echo $(docker ps -qa --no-trunc -f 'ancestor=enda-api' -f 'status=running') | sed -e "s/[\r\n]\+/ /g"`

docker build -t enda-api .
docker run -d \
  -e VIRTUAL_HOST=api.enda.local,api.endaaman.me \
  -e MONGO_HOST='172.17.0.1:27017' \
  -v /var/uploaded/enda:/var/uploaded/enda \
  enda-api

if [ -n "$running_container_id" ]; then
  echo 'Stopping/removing old container...'
  docker stop $running_container_id
  docker rm $running_container_id
  echo 'Done!'
fi
