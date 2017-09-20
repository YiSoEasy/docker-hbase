#!/bin/bash

# restart master
sudo /usr/local/hbase/bin/hbase-daemon.sh restart master
# restart regionserver, for some reason, can only hard-code HBASE_HOME
ssh root@hadoop-slave1 'sudo /usr/local/hbase/bin/hbase-daemon.sh restart regionserver'
ssh root@hadoop-slave2 'sudo /usr/local/hbase/bin/hbase-daemon.sh restart regionserver'