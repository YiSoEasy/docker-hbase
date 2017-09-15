#!/bin/sh -ex

mv $HBASE_SCONF_DIR/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml
mv $HBASE_SCONF_DIR/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh
# start hbase-master in master and hbase-regionserver in slaves
THISHOST=$(hostname)
if [ "$THISHOST" = "$HBASE_MASTER" ]; then
	sudo $HBASE_HOME/bin/hbase-daemon.sh start master
else
	# bug, container's hostname has network as suffix, need to 
	# fix the regionserver hostname, or master will hang
	sed -i '$d' $HBASE_HOME/conf/hbase-site.xml  
	echo "  <property>" >> $HBASE_HOME/conf/hbase-site.xml
	echo "    <name>hbase.regionserver.hostname</name>" >> $HBASE_HOME/conf/hbase-site.xml
	echo "    <value>$THISHOST.$NETWORK</value>" >> $HBASE_HOME/conf/hbase-site.xml
	echo "  </property>" >> $HBASE_HOME/conf/hbase-site.xml
	echo "</configuration>" >> $HBASE_HOME/conf/hbase-site.xml
	sudo $HBASE_HOME/bin/hbase-daemon.sh start regionserver
fi