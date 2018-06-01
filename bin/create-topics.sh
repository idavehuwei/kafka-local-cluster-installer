#!/usr/bin/env bash
set -o xtrace
echo "creating kafka flow topics"

bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 16 --config retention.ms=86400000 --topic flow-to-be-planned-shipments
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 16 --config retention.ms=86400000 --topic flow-loaded-trips
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 16 --config retention.ms=86400000 --topic flow-released-trips
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 3 --config retention.ms=86400000 --topic flow-trip-mutations
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 16 --config retention.ms=86400000 --topic flow-unit-status
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 16 --config retention.ms=86400000 --topic flow-shipment-etas
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 8 --config retention.ms=86400000 --topic flow-ht-events
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 32 --config retention.ms=86400000 --topic flow-sorting-plans
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --config retention.ms=86400000 --topic flow-dead-letter
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 8 --config retention.ms=86400000 --topic flow-storage-shipments

./list-topics.sh
