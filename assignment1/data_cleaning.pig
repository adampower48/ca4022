register file:/home/adam/Documents/pig-0.17.0/lib/piggybank.jar
DEFINE CSVLoader org.apache.pig.piggybank.storage.CSVLoader;

-- Load data
ratings = load 'input/ml-latest-small/ratings.csv' using CSVLoader(',') as (userId:int, movieId:int, rating:double, timestamp:int);
ratings = filter ratings by userId is not null; -- remove first line (headers)

movies = load 'input/ml-latest-small/movies.csv' using CSVLoader(',') as (movieId:int, title:chararray, genres:chararray);
movies = filter movies by movieId is not null; -- remove first line (headers)

tags = load 'input/ml-latest-small/tags.csv' using CSVLoader(',') as (userId:int, movieId:int, tag:chararray, timestamp:int);
tags = filter tags by userId is not null; -- remove first line (headers)

links = load 'input/ml-latest-small/links.csv' using CSVLoader(',') as (movieId:int, imdbId:int, tmdbId:int);
links = filter links by movieId is not null; -- remove first line (headers)


-- Split out year, title. Split genres (| must be escaped with \\)
movies = foreach movies generate
    movieId,
    REGEX_EXTRACT(title, '\\((\\d+)\\)', 1) as year,
    REGEX_EXTRACT(title, '([\\S ]+) \\(\\d+\\)', 1) as title,
    STRSPLIT(genres, '\\|') as genres;

-- Save csv
fs -rm -r -f output/movies -- remove old dir
store movies into 'output/movies' using PigStorage('\t', '-schema'); -- Save parts & other gunk
fs -rm -f output/movies/.pig_schema -- Remove schema file
fs -rm -f output/movies/_SUCCESS -- Remove success file
fs -getmerge output/movies output/movies.csv; -- Merge into single file
fs -rm -r -f output/movies -- remove gunk
fs -rm -f output/.movies.csv.crc; -- Remove gunk