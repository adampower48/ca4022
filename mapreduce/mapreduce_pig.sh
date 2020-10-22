# Make user directory
${HADOOP_HOME}/bin/hdfs dfs -mkdir /user
${HADOOP_HOME}/bin/hdfs dfs -mkdir /user/adam


# Remove existing input/output dirs
${HADOOP_HOME}/bin/hdfs dfs -rm -r input
${HADOOP_HOME}/bin/hdfs dfs -rm -r output

# Copy input files into dfs
${HADOOP_HOME}/bin/hdfs dfs -mkdir input
${HADOOP_HOME}/bin/hdfs dfs -put -f input/* input

# Run pig command
pig -x mapreduce -f mapreduce.pig
