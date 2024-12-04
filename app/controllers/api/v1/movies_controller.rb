class Api::V1::MoviesController < ApplicationController

  def movie_params
    params.permit(:title, vote_average)
  end

end