#!/bin/sh -ex

# Generate the zoo.cfg only if it doesn't exist
if [ ! -f "$ZOO_CONF_DIR/zoo.cfg" ]; then
    CONFIG="$ZOO_CONF_DIR/zoo.cfg"
    
    echo "dataDir=$ZOO_DATA_DIR" >> "$CONFIG"
    echo "dataLogDir=$ZOO_DATA_LOG_DIR" >> "$CONFIG"
    echo "clientPort=2181" >> "$CONFIG"
    echo "tickTime=2000" >> "$CONFIG"
    echo "initLimit=5" >> "$CONFIG"
    echo "syncLimit=2" >> "$CONFIG"

    for server in $ZOO_SERVERS; do
        echo "$server" >> "$CONFIG"
    done
fi
# Write myid only if it doesn't exist
if [ ! -f "$ZOO_DATA_DIR/myid" ]; then
    echo "${ZOO_MY_ID:-1}" > "$ZOO_DATA_DIR/myid"
fi
# Copy log4j.properties, mainly used to set zookeeper.log.dir
#cp -f $ZOO_SCONF_DIR/log4j.properties $ZOO_CONF_DIR

# Start Zookeeper Server
chmod +x $ZOOKEEPER_HOME/bin/zkServer.sh
$ZOOKEEPER_HOME/bin/zkServer.sh start