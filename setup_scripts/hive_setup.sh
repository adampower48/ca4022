# Make folders on dfs
hdfs dfs -mkdir /tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /tmp
hdfs dfs -chmod g+w /user/hive/warehouse

# Copy default config file
cp $HIVE_HOME/conf/hive-default.xml.template $HIVE_HOME/conf/hive-site.xml

# Replace guava jar
rm $HIVE_HOME/lib/guava*.jar
cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava*.jar $HIVE_HOME/lib/
