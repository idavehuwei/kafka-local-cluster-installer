#!/usr/bin/env bash
echo "listing all topics"
echo "bin/kafka-topics.sh --list --zookeeper localhost:2181"
bin/kafka-topics.sh --list --zookeeper localhost:2181
