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
movie_groups = group ratings_counts by movieId;
movie_total_ratings = foreach movie_groups generate group as movieId, SUM(ratings_counts.num_ratings) as num_ratings;


-- Find movie with highest avg rating
groups = group ratings_counts by movieId;
movie_avg_ratings = foreach groups {
    mul = foreach ratings_counts generate rating * num_ratings;
    generate group as movieId, SUM(mul) / SUM(ratings_counts.num_ratings) as avg_rating;
};

-- Join tables together and clean up
movie_ratings = join movies by movieId, movie_avg_ratings by movieId, movie_total_ratings by movieId; -- Join with title data
movie_ratings = order movie_ratings by movie_avg_ratings::avg_rating desc; -- Sort by avg rating
movie_ratings = foreach movie_ratings generate -- Fix headers
    movies::movieId as movieId,
    movies::year as year,
    movies::title as title,
    movies::genres as genres,
    movie_avg_ratings::avg_rating as avg_rating,
    movie_total_ratings::num_ratings as num_ratings;



-- Save ratings csv
fs -rm -r -f output/movie_ratings -- remove old dir
store movie_ratings into 'output/movie_ratings' using PigStorage('\t', '-schema'); -- Save parts & other gunk
fs -rm -f output/movie_ratings/.pig_schema -- Remove schema file
fs -rm -f output/movie_ratings/_SUCCESS -- Remove success file
fs -getmerge output/movie_ratings output/movie_ratings.csv; -- Merge into single file
fs -rm -r -f output/movie_ratings -- remove gunk
fs -rm -f output/.movie_ratings.csv.crc; -- Remove gunk


---- Calculate summary statistics for user ratings
--g = group ratings by userId;
--user_avg = foreach g generate group as userId, AVG(ratings.rating) as avg_rating, COUNT(ratings) as num_ratings;  -- Get avg user rating and number of ratings
--
--
--user_ratings = join ratings by userId, user_avg by userId;
--usr_ratings = foreach user_ratings {
--    diff = ratings::rating - user_avg::avg_rating;
--    generate ratings::userId as userId,
--            diff * diff as diff_sq;
--}; -- compute standard deviation (step 1)
--
--g = group usr_ratings by userId;
--usr_ratings2 = foreach g generate group as userId, SUM(usr_ratings.diff_sq) as sum_diff_sq; -- compute standard deviation (step 2)
--
--usr_ratings3 = join usr_ratings2 by userId, user_avg by userId;
--user_rating_stats = foreach usr_ratings3 generate
--    usr_ratings2::userId as userId,
--    user_avg::avg_rating as avg_rating,
--    (
--        case user_avg::num_ratings
--        when 1 then 0
--        else SQRT(usr_ratings2::sum_diff_sq / (user_avg::num_ratings - 1)) end
--    ) as std,  -- compute standard deviation (step 3)
--    user_avg::num_ratings as num_ratings;
--
--head = limit user_rating_stats 10; dump head;
--describe user_rating_stats;
--
---- Save user aggregates csv
--fs -rm -r -f output/users -- remove old dir
--store user_rating_stats into 'output/users' using PigStorage('\t', '-schema'); -- Save parts & other gunk
--fs -rm -f output/users/.pig_schema -- Remove schema file
--fs -rm -f output/users/_SUCCESS -- Remove success file
--fs -getmerge output/users output/users.csv; -- Merge into single file
--fs -rm -r -f output/users -- remove gunk
--fs -rm -f output/.users.csv.crc; -- Remove gunk

