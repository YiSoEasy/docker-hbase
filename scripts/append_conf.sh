#!/bin/bash

# usage: append_conf.sh conf.txt
# in above conf.txt file has format:
# <property>
#     <name>hbase.region.replica.replication.enabled</name>
#     <value>true</value>
# </property>
# <property>
#     <name>hbase.meta.replica.count</name>
#     <value>3</value>
# </property>
# Notice the two space before <property>

# copy conf file to each cluster
for node in hadoop-master hadoop-slave1 hadoop-slave2
do
	scp ./$1 root@$node:/tmp
done

# append conf to hbase-site.xml
for node in hadoop-master hadoop-slave1 hadoop-slave2
do
	ssh root@$node << EOF
# remove last line of hbase-site
sed -i '\$d' /usr/local/hbase/conf/hbase-site.xml
# append conf file
cat /tmp/$1 >> /usr/local/hbase/conf/hbase-site.xml
# append </configuration>
echo '</configuration>' >> /usr/local/hbase/conf/hbase-site.xml

EOF
done