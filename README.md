## Run Distributed HBase Cluster within Docker Containers

### 3 Nodes HBase Cluster

##### 1. pull/build docker image

```
sudo docker pull yliangdocker/hbase:latest

you can also run command below to build image: 
sudo docker build -t yliangdocker/hbase:latest .
```

##### 2. clone github repository

```
git clone https://github.com/YiSoEasy/docker-hbase.git
```

##### 3. start container

```
chmod +x start.sh
./start.sh

**output:**
.....
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 

- start 3 containers with 1 master and 2 slaves
- you will get into the /root directory of hadoop-master container
```

##### 4. test hadoop and hbase

```
cd ~/cluter/cluster_test
./mapreduce-wordcount.sh 	#run mapreduce job
./hbase-test.sh 	#run hbase pe tool
```

##### 5. limitations
```
1. These code can run multiple hbase containers on only single host. I am now working on
how to depoly multiple hbase containers on multiple nodes using Kubernetes

2. Because of the docker network issues, we need to take care of hbase-site.xml.
Try to ping hadoop-slave1 from hadoop-master, you can see the real hadoop-slave1 hostname,
The real host name may have following format: [$container-name.$network-name]
Specify hbase.regionserver.hostname in hbase-site.xml, see HBASE-12954
```