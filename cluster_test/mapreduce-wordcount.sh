#!/bin/bash

# test the hadoop cluster by running wordcount

# create input files 
mkdir input
echo "Hello Docker" >input/file2.txt
echo "Hello Hadoop" >input/file1.txt

# create input directory on HDFS
$HADOOP_HOME/bin/hadoop fs -mkdir -p input

# put input files to HDFS
$HADOOP_HOME/bin/hdfs dfs -put ./input/* input

# run wordcount 
$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/sources/hadoop-mapreduce-examples-2.7.2-sources.jar org.apache.hadoop.examples.WordCount input output

# print the input files
echo -e "\ninput file1.txt:"
$HADOOP_HOME/bin/hdfs dfs -cat input/file1.txt

echo -e "\ninput file2.txt:"
$HADOOP_HOME/bin/hdfs dfs -cat input/file2.txt

# print the output of wordcount
echo -e "\nwordcount output:"
$HADOOP_HOME/bin/hdfs dfs -cat output/part-r-00000