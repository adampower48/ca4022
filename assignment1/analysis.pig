register file:/home/adam/Documents/pig-0.17.0/lib/piggybank.jar
DEFINE CSVLoader org.apache.pig.piggybank.storage.CSVLoader;
DEFINE CSVExcelStorage org.apache.pig.piggybank.storage.CSVExcelStorage;


-- Load data
ratings = load 'input/ml-latest-small/ratings.csv' using PigStorage(',') as (userId:int, movieId:int, rating:double, timestamp:int);
ratings = filter ratings by userId is not null; -- remove first line (headers)

movies = load 'input/clean_data/movies.csv' using PigStorage('\t') as (movieId:int, year:int, title:chararray, genres:chararray);
movies = filter movies by movieId is not null; -- remove first line (headers)

tags = load 'input/ml-latest-small/tags.csv' using PigStorage(',') as (userId:int, movieId:int, tag:chararray, timestamp:int);
tags = filter tags by userId is not null; -- remove first line (headers)

links = load 'input/ml-latest-small/links.csv' using PigStorage(',') as (movieId:int, imdbId:int, tmdbId:int);
links = filter links by movieId is not null; -- remove first line (headers)




-- Aggregate ratings
agg_ratings = group ratings by (movieId, rating);
ratings_counts = foreach agg_ratings generate group.movieId, group.rating, COUNT(ratings) as num_ratings;

-- Find movie with most number of ratings
--movie_groups = group ratings_counts by movieId;
--movie_total_ratings = foreach movie_groups generate group as movieId, SUM(ratings_counts.num_ratings) as num_ratings;

--movie_total_ratings = order movie_total_ratings by num_ratings desc; -- Sort and get highest
--most_ratings = limit movie_total_ratings 1;
--
--movie_ratings = join movies by movieId, most_ratings by movieId; -- Join with title data
--dump movie_ratings;

-- Find movie with highest avg rating
groups = group ratings_counts by movieId;
movie_avg_ratings = foreach groups {
    mul = foreach ratings_counts generate rating * num_ratings;
    generate group as movieId, SUM(mul) / SUM(ratings_counts.num_ratings) as avg_rating;
};

movie_avg_ratings = order movie_avg_ratings by avg_rating desc; -- Sort and get highest
highest_ratings = limit movie_avg_ratings 1;

movie_ratings = join movies by movieId, highest_ratings by movieId; -- Join with title data
dump movie_ratings;


