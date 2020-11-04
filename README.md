# Setup Scripts
**Run all of these scripts from the folder you want to install to.**  
**Restart your terminal after installing each program.**  


## Hadoop
Run [hadoop_install.sh](setup_scripts/hadoop_install.sh)  
Configure etc/core-site.xml and etc/hdfs-site.xml as described in the configuration section [here](https://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-common/SingleCluster.html)  
Verify the install (restart the terminal before this):
- `ssh localhost` should work  
- The [start_hadoop.sh](setup_scripts/start_hadoop.sh) script should run successfully  
- `hdfs` and `hadoop` should be available  

## Hive
Run [hive_install.sh](setup_scripts/hive_install.sh)  
Verify that it installed correctly by running `hive`  

## Pig
Run [pig_install.sh](setup_scripts/pig_install.sh)  
Verify that it installed correctly by running `pig -x local`  
Verify that everything else is connected properly by running [mapreduce_pig.sh](mapreduce/mapreduce_pig.sh)  

# Examples
## [mapreduce_hadoop.sh](mapreduce/mapreduce_hadoop.sh)  
MapReduce using hadoop and jar file  

## [mapreduce_pig.sh](mapreduce/mapreduce_pig.sh)  
MapReduce using pig  
