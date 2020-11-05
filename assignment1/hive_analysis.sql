-- Create database
drop database if exists movielens cascade;
create database if not exists movielens;
use movielens;

show databases;
show tables from movielens;

-- Configuration options to show table headers
set hive.cli.print.header=true;
set hive.resultset.use.unique.column.names=false;

-- Create Tables
--      User ratings
create table user_rating_stats
(
    userId int,
    avg    double,
    std    double,
    n      int
)
    row format delimited fields terminated by "\t"
    tblproperties ("skip.header.line.count" = "1");

--      Movies
create table movies
(
    movieId int,
    year    int,
    title   string,
    genres  string
)
    row format delimited fields terminated by "\t"
    tblproperties ("skip.header.line.count" = "1");

--      User Ratings
create table ratings
(
    userId      int,
    movieId     int,
    rating      double,
    `timestamp` int
)
    row format delimited fields terminated by ","
    tblproperties ("skip.header.line.count" = "1");

-- Load data into tables
load data inpath "/user/adam/input/pig_output_data/users.csv" overwrite into table user_rating_stats;
load data inpath "/user/adam/input/clean_data/movies.csv" overwrite into table movies;
load data inpath "/user/adam/input/ml-latest-small/ratings.csv" overwrite into table ratings;

-- View rows
-- select * from user_rating_stats limit 10;
-- select * from movies limit 10;
-- select * from ratings limit 10;


-- Normalise user ratings
create table norm_user_ratings as
select ratings.userid,
       movieid,
       if(std == 0, 0, (rating - avg) / std) as norm_rating
from ratings
         join user_rating_stats urs
              on ratings.userId = urs.userId;

-- Add ratings & normalised ratings to movies
create table all_ratings as
select movies.*, r.userId, r.rating, nur.norm_rating
from movies
         join norm_user_ratings nur on movies.movieId = nur.movieid
         join ratings r on nur.userid = r.userId and
                           nur.movieid = r.movieId;

-- Save normalised ratings
insert overwrite directory "/user/adam/output/movie_ratings_all"
    row format delimited fields terminated by '\t'
select movieId, title, year, userId, rating, norm_rating
from all_ratings;

-- Calculate average of ratings
create table movie_averages as
select movieId,
       title,
       avg(rating)      as avg_rating,
       avg(norm_rating) as avg_norm_rating
from all_ratings
group by movieId, title;

-- Save averages
insert overwrite directory "/user/adam/output/movie_averages"
    row format delimited fields terminated by '\t'
select *
from movie_averages;


-- Genres: split into rows
create table genres as
select movieId, genre
from movies lateral view explode(split(regexp_replace(genres, "[\(\)]", ""), ",")) genres as genre;

-- Save genres
insert overwrite directory "/user/adam/output/genres_split"
    row format delimited fields terminated by '\t'
select *
from genres;

-- Get average & std rating per genre
create table genre_ratings as
select genre,
       count(*)             as num_movies,
       avg(avg_rating)      as avg_rating,
       std(avg_rating)      as std_rating,
       avg(avg_norm_rating) as avg_norm_rating,
       std(avg_norm_rating) as std_norm_rating
from genres
         join movie_averages on genres.movieId = movie_averages.movieId
group by genres.genre;

-- Save genre ratings
insert overwrite directory "/user/adam/output/genre_averages"
    row format delimited fields terminated by '\t'
select *
from genre_ratings;
