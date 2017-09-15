#!/bin/sh -ex

# Move config file to HADOOP_HOME
mv $HADOOP_SCONF_DIR/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
mv $HADOOP_SCONF_DIR/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
mv $HADOOP_SCONF_DIR/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
mv $HADOOP_SCONF_DIR/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
mv $HADOOP_SCONF_DIR/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
mv $HADOOP_SCONF_DIR/slaves $HADOOP_HOME/etc/hadoop/slaves 

# Change start file mode
chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
chmod +x $HADOOP_HOME/sbin/start-yarn.sh 
chmod +x $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh

# format namenode
sudo $HADOOP_HOME/bin/hdfs namenode -format


# Start hadoop cluster in master, this run namenode and secondaryNN on same 
# node, modify it if necessary
THISHOST=$(hostname)
if [ "$THISHOST" = "$HADOOP_MASTER" ]; then
    sudo $HADOOP_HOME/sbin/start-dfs.sh
    sudo $HADOOP_HOME/sbin/start-yarn.sh
    sudo $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
fi