class Api::V1::MoviesController < ApplicationController

  def index
    top_rated_movies = MovieGateway.get_top_rated
    render json: MovieSerializer.format_movie_info(top_rated_movies)
  end

  def show
    movie_id = params[:id]
    movie_details = MovieGateway.get_movie_details(movie_id)
    movie_credits = MovieGateway.get_movie_credits(movie_id)
    render json: MovieSerializer.format_movie_details(movie_details, movie_credits)
  end

  def search
    search_term = params[:query]
    search_movies = MovieGateway.search_movies_by_keyword(search_term)
    render json: MovieSerializer.format_movie_info(search_movies)
  end
end