## Run Distributed HBase Cluster within Docker Containers


### 3 Nodes HBase Cluster

##### 1. pull docker image

```
sudo docker pull yliangdocker/hbase:latest
```

##### 2. clone github repository

```
git clone https://github.com/YiSoEasy/docker-hbase.git
```

##### 3. create hadoop network

```
sudo docker network create --driver=bridge hadoop
```

##### 4. start container

```
chmod +x start.sh
./start.sh

**output:**

```
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
```
- start 3 containers with 1 master and 2 slaves
- you will get into the /root directory of hadoop-master container

##### 5. test hadoop and hbase

```
cd ~/cluter/cluster_test
./mapreduce-wordcount.sh 	#run mapreduce job
./hbase-test.sh 	#run hbase pe tool
```