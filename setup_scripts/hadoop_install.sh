# https://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-common/SingleCluster.html
# Install prerequisite software
sudo apt-get install ssh pdsh openjdk-8-jdk

# Download hadoop
wget https://ftp.heanet.ie/mirrors/www.apache.org/dist/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz
tar -zxvf hadoop-3.3.0.tar.gz

# set hadoop home
export HADOOP_HOME=$(pwd)/hadoop-3.3.0

# Add java to hadoop config
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# Add variables to bashrc
echo '
export HADOOP_HOME='$HADOOP_HOME'
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
' >> ~/.bashrc

# Set pdsh to use ssh (https://stackoverflow.com/questions/48189954/hadoop-start-dfs-sh-connection-refused)
echo '
export PDSH_RCMD_TYPE=ssh
' >> ~/.bashrc


# Set up localhost ssh key
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys


# Set up hadoop to use current user
echo '
export HDFS_NAMENODE_USER="$USER"
export HDFS_DATANODE_USER="$USER"
export HDFS_SECONDARYNAMENODE_USER="$USER"
export YARN_RESOURCEMANAGER_USER="$USER"
export YARN_NODEMANAGER_USER="$USER"
' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
