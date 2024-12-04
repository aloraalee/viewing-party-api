class Api::V1::MoviesController < ApplicationController

  def index
    render json: MovieSerializer.format_movie_info(Movie.all)
  end

  def movie_params
    params.permit(:title, vote_average)
  end

end