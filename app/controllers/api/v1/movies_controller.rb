class Api::V1::MoviesController < ApplicationController

  def index
    conn = Faraday.new(
      url: 'https://api.themoviedb.org/3',
      params: {api_key: Rails.application.credentials.tmdb[:key]}
    )
    response = conn.get("movie/top_rated") 
    movies = JSON.parse(response.body)["results"].first(20)
    render json: MovieSerializer.format_movie_info(movies)
  end

  # def search
  #   # movie = params[:movie]

  #   render json: MovieSerializer.format_movie_info(Movie.all)
  # end

  # def movie_params
  #   params.permit(:title, :vote_average)
  # end

end