# Download hive
wget https://ftp.heanet.ie/mirrors/www.apache.org/dist/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz
tar -xvzf apache-hive-3.1.2-bin.tar.gz

# Set hive home
export HIVE_HOME=$(pwd)/hive-3.1.2

# Copy default config file
cp $HIVE_HOME/conf/hive-default.xml.template $HIVE_HOME/conf/hive-site.xml

# Replace wonky values in config
sed -i 's/system:user.name/user.name/g' $HIVE_HOME/conf/hive-site.xml
sed -i 's/system:java.io.tmpdir/java.io.tmpdir/g' $HIVE_HOME/conf/hive-site.xml
sed -i 's/&#8;/ /' $HIVE_HOME/conf/hive-site.xml


# Replace guava jar
rm $HIVE_HOME/lib/guava*.jar
cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava*.jar $HIVE_HOME/lib/

# Init database
$HIVE_HOME/bin/schematool –initSchema –dbType derby