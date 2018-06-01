#!/usr/bin/env bash
echo "interactive kafka local cluster installer"

printf "enter location on disk [default: /tmp/kafka-cluster]: "
read INSTALL_LOCATION
if [[ -z "$INSTALL_LOCATION" ]]; then
  INSTALL_LOCATION="/tmp/kafka-cluster"
fi

if [[ -e "$INSTALL_LOCATION" ]]; then
  BACKUP_LOCATION="/tmp/backup/$RANDOM"
  printf "Seems like there is already something installed at ${INSTALL_LOCATION}, backup installation to ${BACKUP_LOCATION}? (y/n) [default n]: "
  read PURGE_EXISTING

  if [[ "$PURGE_EXISTING" == "y" ]]; then
    if [[ -e "$BACKUP_LOCATION" ]]; then
      echo "backup location $BACKUP_LOCATION exists as well, exiting for safety"
      exit
    fi

    echo "moving existing installation ($INSTALL_LOCATION) to backup $BACKUP_LOCATION"
    mkdir -p $BACKUP_LOCATION
    mv $INSTALL_LOCATION $BACKUP_LOCATION/
  else
    echo "Stopping..."
    exit
  fi
fi
echo "creating $INSTALL_LOCATION"
mkdir -p $INSTALL_LOCATION


printf "Enter kafka version [default: 1.1.0]: "
read KAFKA_VERSION
if [[ -z "$KAFKA_VERSION" ]]; then
  KAFKA_VERSION="1.1.0"
fi
DOWNLOAD_LOCATION="http://apache.mirror.triple-it.nl/kafka/${KAFKA_VERSION}/kafka_2.12-${KAFKA_VERSION}.tgz"
TARGET_LOCATION="$INSTALL_LOCATION/kafka_2.12-${KAFKA_VERSION}.tgz"
echo "Downloading kafka version $KAFKA_VERSION ... "
curl $DOWNLOAD_LOCATION -o $TARGET_LOCATION

echo "Unpacking kafka ..."
tar -xvzf $TARGET_LOCATION -C $INSTALL_LOCATION

printf "Enter zookeeper port [default 2181]: "
read ZOOKEEPER_PORT
if [[ -z "$ZOOKEEPER_PORT" ]]; then
  ZOOKEEPER_PORT="2181"
fi

printf "Enter kafka-broker-1 port [default 31001]: "
read KAFKA_BROKER_1
if [[ -z "$KAFKA_BROKER_1" ]]; then
  KAFKA_BROKER_1="31001"
fi

printf "Enter kafka-broker-2 port [default 31002]: "
read KAFKA_BROKER_2
if [[ -z "$KAFKA_BROKER_2" ]]; then
  KAFKA_BROKER_2="31002"
fi

printf "Enter kafka-broker-3 port [default 31003]: "
read KAFKA_BROKER_3
if [[ -z "$KAFKA_BROKER_3" ]]; then
  KAFKA_BROKER_3="31003"
fi

echo "Setting zookeeper port to ${ZOOKEEPER_PORT}"
echo "Setting kafka-broker-1 port to ${KAFKA_BROKER_1}"
echo "Setting kafka-broker-2 port to ${KAFKA_BROKER_2}"
echo "Setting kafka-broker-3 port to ${KAFKA_BROKER_3}"

KAFKA_HOME="$INSTALL_LOCATION/kafka_2.12-${KAFKA_VERSION}"

ZOOKEEPER_DATA_DIR="${KAFKA_HOME}/storage/zookeeper"
BROKER_1_DATA_DIR="${KAFKA_HOME}/storage/broker-1"
BROKER_2_DATA_DIR="${KAFKA_HOME}/storage/broker-2"
BROKER_3_DATA_DIR="${KAFKA_HOME}/storage/broker-3"


echo "Creating data dir $ZOOKEEPER_DATA_DIR"
mkdir -p $ZOOKEEPER_DATA_DIR
echo "Creating data dir $BROKER_1_DATA_DIR"
mkdir -p $BROKER_1_DATA_DIR
echo "Creating data dir $BROKER_2_DATA_DIR"
mkdir -p $BROKER_2_DATA_DIR
echo "Creating data dir $BROKER_3_DATA_DIR"
mkdir -p $BROKER_3_DATA_DIR

echo "Creating config files"
# remove the file that kafka ships with
rm -f "$KAFKA_HOME/config/zookeeper.properties"
cp config-templates/* "$KAFKA_HOME/config/"

sed -i "s/ZOOKEEPER_PORT/${ZOOKEEPER_PORT}/g" "$KAFKA_HOME/config/zookeeper.properties"
sed -i "s|ZOOKEEPER_DATA_DIR|${ZOOKEEPER_DATA_DIR}|g" "$KAFKA_HOME/config/zookeeper.properties"

sed -i "s/BROKER_1_PORT/${KAFKA_BROKER_1}/g" "$KAFKA_HOME/config/server-1.properties"
sed -i "s|BROKER_1_DATA_DIR|${BROKER_1_DATA_DIR}|g" "$KAFKA_HOME/config/server-1.properties"
sed -i "s/ZOOKEEPER_PORT/${ZOOKEEPER_PORT}/g" "$KAFKA_HOME/config/server-1.properties"

sed -i "s/BROKER_2_PORT/${KAFKA_BROKER_2}/g" "$KAFKA_HOME/config/server-2.properties"
sed -i "s|BROKER_2_DATA_DIR|${BROKER_2_DATA_DIR}|g" "$KAFKA_HOME/config/server-2.properties"
sed -i "s/ZOOKEEPER_PORT/${ZOOKEEPER_PORT}/g" "$KAFKA_HOME/config/server-2.properties"

sed -i "s/BROKER_3_PORT/${KAFKA_BROKER_3}/g" "$KAFKA_HOME/config/server-3.properties"
sed -i "s|BROKER_3_DATA_DIR|${BROKER_3_DATA_DIR}|g" "$KAFKA_HOME/config/server-3.properties"
sed -i "s/ZOOKEEPER_PORT/${ZOOKEEPER_PORT}/g" "$KAFKA_HOME/config/server-3.properties"

echo "Creating utility scripts"
cp bin/* "$KAFKA_HOME/"
cp README.md "$KAFKA_HOME/"

sed -i "s/2181/${ZOOKEEPER_PORT}/g" "$KAFKA_HOME/list-topics.sh"
sed -i "s/2181/${ZOOKEEPER_PORT}/g" "$KAFKA_HOME/describe-topic.sh"
sed -i "s/2181/${ZOOKEEPER_PORT}/g" "$KAFKA_HOME/create-topics.sh"

sed -i "s/BROKER_1_PORT/${KAFKA_BROKER_1}/g" "$KAFKA_HOME/view-consumer-group-offsets.sh"
sed -i "s/BROKER_1_PORT/${KAFKA_BROKER_1}/g" "$KAFKA_HOME/view-consumer-groups.sh"

ls $KAFKA_HOME/*.sh | xargs chmod +x

echo "Opening kafka installation in terminal $KAFKA_HOME"
gnome-terminal --working-directory="$KAFKA_HOME" &

echo "Done, opening readme with further instructions"
gedit "$KAFKA_HOME/README.md" &
