#!/bin/bash

# the default node number is 3
N=${1:-3}

# create a bridge network
NET=hadoop
sudo docker network rm $NET
sudo docker network create --driver=bridge $NET

# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --name hadoop-master \
                --hostname hadoop-master \
                --net=$NET \
                -e ZOO_MY_ID="1" \
                -e ZOO_SERVERS="server.1=hadoop-master:2888:3888 server.2=hadoop-slave1:2888:3888 server.3=hadoop-slave2:2888:3888" \
                -e HADOOP_MASTER="hadoop-master" \
                -e HBASE_MASTER="hadoop-master" \
                -e NETWORK=$NET \
                yliangdocker/hbase:latest &> /dev/null



# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
                    --name hadoop-slave$i \
                    --hostname hadoop-slave$i \
                    --net=$NET \
                    -e ZOO_MY_ID="$(( $i + 1 ))" \
                    -e ZOO_SERVERS="server.1=hadoop-master:2888:3888 server.2=hadoop-slave1:2888:3888 server.3=hadoop-slave2:2888:3888" \
                    -e HADOOP_MASTER="hadoop-master" \
                    -e HBASE_MASTER="hadoop-master" \
                    -e NETWORK=$NET \
                    yliangdocker/hbase:latest &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash