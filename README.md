# Local kafka cluster installation and usage

Installs a local kafka cluster and provides scripts to quickly create all required directories and configurations

## Installing

run `./installer.sh` 

This is an interactive installer which downloads kafka, configures it, and provides helpers scripts. 

## Starting the installed cluster

move to the directory where you installed kafka, default:

`cd /tmp/kafka-cluster/kafka_2.12-1.1.0`

1. Open a new terminal and start zookeeper

    `./start-zookeeper.sh`

1. Open a new terminal and start kafka broker 1

    `./start-kafka-1.sh`

1. Open a new terminal and start kafka broker 2

    `./start-kafka-2.sh`

1. Open a new terminal and start kafka broker 3

    `./start-kafka-3.sh`

Kafka is now running in cluster of 3 nodes!

## Automatically creating all topics with replication, retention and partitions

1. See if any topics already exist

  `./list-topics.sh`

1. If no topics already exist or an incomplete set, run:

  `./create-topics.sh`

1. View topic details. This shows which broker is the leader, and which are replicas

  `./describe-topic.sh <topic-name>`

## Connecting to the cluster from a service

Start the service with the environment variable KAFKA_BROKER_LIST set to:

`KAFKA_BROKER_LIST=localhost:31001,localhost:31002,localhost:31003`

**This probably only works when testing locally, external IP's might not be able to connect because the ADVERTISED address is localhost (not ested, you can try). A possible solution is to alter the config/server-[1,2,3].properties files and make kafka listen on the public IP address.**

