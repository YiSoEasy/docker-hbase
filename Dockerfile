FROM ubuntu:14.04

# specify hadoop/zookeeper/hbase version
ARG ZOOKEEPER_VERSION=3.4.10
ARG HADOOP_VERSION=2.7.1
ARG HBASE_VERSION=1.2.6

# install openssh-server, openjdk and wget
RUN apt-get -y update && apt-get install -y openssh-server

RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get -y update && \
    apt-get install -y openjdk-8-jdk && \
    update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java && \
    update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac

# install zookeeper 
RUN wget http://supergsego.com/apache/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz && \
    tar -xzvf zookeeper-$ZOOKEEPER_VERSION.tar.gz && \
    mv zookeeper-$ZOOKEEPER_VERSION /usr/local/zookeeper && \
	rm zookeeper-$ZOOKEEPER_VERSION.tar.gz

# install hadoop
RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -xzvf hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION /usr/local/hadoop && \
	rm hadoop-$HADOOP_VERSION.tar.gz

# install hbase
RUN wget https://archive.apache.org/dist/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz && \
	tar -xzvf hbase-$HBASE_VERSION-bin.tar.gz && \
	mv hbase-$HBASE_VERSION /usr/local/hbase && \
	rm hbase-$HBASE_VERSION-bin.tar.gz

# set environment variable
ENV CLUSTER_HOME=/root/cluster
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop 
ENV ZOOKEEPER_HOME=/usr/local/zookeeper
ENV HBASE_HOME=/usr/local/hbase
ENV PATH="$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HBASE_HOME/bin:$ZOOKEEPER_HOME/bin:$JAVA_HOME/bin"

# set work directory
WORKDIR $CLUSTER_HOME

# ssh without key
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
ADD conf/ssh_config /root/.ssh/config


# set zookeeper default env
ENV ZOO_CONF_DIR=$ZOOKEEPER_HOME/conf
ENV ZOO_USER_DIR=$CLUSTER_HOME/zookeeper
ENV ZOO_SCONF_DIR=$ZOO_USER_DIR/setConf
#ENV ZOO_LOG_DIR=$ZOO_USER_DIR/log
ENV ZOO_DATA_DIR=$ZOO_USER_DIR/data
ENV ZOO_DATA_LOG_DIR=$ZOO_USER_DIR/datalog


# set hadoop default env
ENV HADOOP_COMMON_HOME=/usr/local/hadoop
ENV HADOOP_HDFS_HOME=/usr/local/hadoop
ENV HADOOP_MAPRED_HOME=/usr/local/hadoop
ENV HADOOP_YARN_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_USER_DIR=$CLUSTER_HOME/hadoop
ENV HADOOP_SCONF_DIR=$HADOOP_USER_DIR/setConf

# set hbase default env
ENV HBASE_CONF_DIR=$HBASE_HOME/conf
ENV HBASE_USER_DIR=$CLUSTER_HOME/hbase
ENV HBASE_SCONF_DIR=$HBASE_USER_DIR/setConf
#ENV HBASE_LOG_DIR=$HBASE_USER_DIR/log

# make home dir
run mkdir -p $CLUSTER_HOME

# make zookeeper dirs
RUN mkdir -p $ZOO_USER_DIR  && \
    mkdir -p $ZOO_DATA_LOG_DIR && \ 
    mkdir -p $ZOO_DATA_DIR && \ 
    mkdir -p $ZOO_SCONF_DIR

# make hadoop dir
RUN mkdir -p $HADOOP_USER_DIR && \
    mkdir -p $HADOOP_USER_DIR/namenode && \
    mkdir -p $HADOOP_USER_DIR/datanode && \
    mkdir -p $HADOOP_SCONF_DIR

# make hbase dir
RUN mkdir -p $HBASE_USER_DIR && \
    mkdir -p $HBASE_SCONF_DIR


# move config file into docker
COPY cluster_test/* $CLUSTER_HOME/cluster_test/
COPY conf/zk_conf/* $ZOO_SCONF_DIR/
COPY conf/hadoop_conf/* $HADOOP_SCONF_DIR/
COPY conf/hbase_conf/* $HBASE_SCONF_DIR/


# zookeeper ports
EXPOSE 2181 2888 3888
# hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# mapred ports
EXPOSE 10020 19888
# yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
# hbase ports
EXPOSE 16000 16010 16020 16030
# other ports
EXPOSE 49707 22

# TODO: maybe we need VOLUME some related hadoop and hbase dir
# so everytime we restart container, existing data will persist
#VOLUME ["$ZOO_DATA_DIR", "$ZOO_DATA_LOG_DIR"]

# copy to workdir
COPY docker-entrypoint.sh .
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]
