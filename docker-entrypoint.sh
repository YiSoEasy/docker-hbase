#!/bin/sh -ex

# Start ssh service
/etc/init.d/ssh start

#------------Configure Zookeeper#------------#
$ZOO_SCONF_DIR/zkSet.sh

#--------------Configure Hadoop--------------#
$HADOOP_SCONF_DIR/hadoopSet.sh


#---------------Configure HBase---------------#
$HBASE_SCONF_DIR/hbaseSet.sh

# Since Docker need to has a running thread, or it will stop
while true; do sleep 1000; done
