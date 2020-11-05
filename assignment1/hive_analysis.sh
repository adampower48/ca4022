# Directory containing metastore_db folder
DB_DIR=~/Documents
# Directory containing hive scripts
WORK_DIR=$(pwd)

# Setup hdfs folders
# Make user directory
${HADOOP_HOME}/bin/hdfs dfs -mkdir /user
${HADOOP_HOME}/bin/hdfs dfs -mkdir /user/adam

# Remove existing input/output dirs
${HADOOP_HOME}/bin/hdfs dfs -rm -r input
${HADOOP_HOME}/bin/hdfs dfs -rm -r output

# Copy input files into dfs
${HADOOP_HOME}/bin/hdfs dfs -mkdir input
${HADOOP_HOME}/bin/hdfs dfs -put -f input/* input

# Run from database directory
cd $DB_DIR
hive -f $WORK_DIR/hive_analysis.sql
cd $WORK_DIR

# Bring output home
${HADOOP_HOME}/bin/hdfs dfs -get -f output .


# Import csv helpers
. ./csv_helpers.sh

# Combine outputs into tsv files
create_tsv output/movie_averages movieId title avg_rating avg_norm_rating
create_tsv output/genre_averages genre num_movies avg_rating std_rating avg_norm_rating std_norm_rating
create_tsv output/genres_split movieId genre
create_tsv output/movie_ratings_all movieId title year userId rating norm_rating
# Remove old folders
rm -r output/movie_averages
rm -r output/genre_averages
rm -r output/genres_split
rm -r output/movie_ratings_all
