#!/bin/bash
sudo service ssh start

if hostname | grep -q 'Master'; then
    hdfs --daemon start journalnode
    /usr/local/zookeeper/bin/zkServer.sh start
    Node_Number=$(hostname | tail -c 2)
    echo $Node_Number > /usr/local/zookeeper/data/myid
    if [ "$Node_Number" -eq "1" ]; then
        hdfs namenode -format 
        hdfs zkfc -formatZK
    else
        hdfs namenode -bootstrapStandby 
    fi
    
    hdfs --daemon start namenode 
    yarn --daemon start resourcemanager 
    hdfs --daemon start zkfc
else
    hdfs --daemon start datanode 
    hdfs --daemon start nodemanager 
fi

hdfs haadmin -getAllServiceState

sleep infinity