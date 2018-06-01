#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
  echo "Usage: "
  echo "./describe-topic.sh <TOPIC_NAME>"
  echo "Example:"
  echo "./describe-topic.sh flow-unit-status"
else
  echo "bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic $1"
  bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic "$1"
fi
