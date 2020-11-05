import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sn

if __name__ == '__main__':
    genre_ratings = pd.read_csv("output/genre_averages.csv", sep="\t")

    # Plot of ratings per genre
    sn.barplot(data=genre_ratings.sort_values("avg_rating"), x="avg_rating", y="genre",
               xerr=genre_ratings["std_rating"])
    plt.title("Average Movie Ratings Across Genres")
    plt.xlabel("Rating")
    plt.ylabel("Genre")
    plt.show()

    # Plot of normalised ratings per genre
    sn.barplot(data=genre_ratings.sort_values("avg_norm_rating"), x="avg_norm_rating", y="genre",
               xerr=genre_ratings["std_norm_rating"])
    plt.title("Average Movie Ratings Across Genres")
    plt.xlabel("Normalised Rating")
    plt.ylabel("Genre")
    plt.show()

    # User rating distributions
    user_ratings = pd.read_csv("output/users.csv", sep="\t")
    sn.scatterplot(data=user_ratings, x="avg_rating", y="std")
    plt.title("User Ratings")
    plt.xlabel("Average Rating")
    plt.ylabel("Standard Deviation of Rating")
    plt.show()

    # Raw vs Normalised ratings
    raw_norm_ratings = pd.read_csv("output/movie_ratings_all.csv", sep="\t")
    sn.scatterplot(data=raw_norm_ratings, x="rating", y="norm_rating", alpha=0.5)
    plt.axhline(0, c="r")
    plt.title("Raw vs Normalised User Ratings")
    plt.xlabel("Raw Rating")
    plt.ylabel("Normalised Rating")
    plt.show()
