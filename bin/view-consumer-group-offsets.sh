#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
  echo "Usage: "
  echo "./view-consumer-group-offsets.sh <TOPIC_NAME>"
  echo "Example:"
  echo "./view-consumer-group-offsets.sh loading-service"
else
  echo "bin/kafka-consumer-groups.sh --describe --bootstrap-server localhost:BROKER_1_PORT --group $1"
  bin/kafka-consumer-groups.sh --describe --bootstrap-server localhost:BROKER_1_PORT --group $1
fi
