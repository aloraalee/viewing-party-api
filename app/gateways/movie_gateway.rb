class MovieGateway
  def self.get_top_rated
    response = conn.get("movie/top_rated") 
    JSON.parse(response.body)["results"].first(20)
  end

  def self.search_movies_by_keyword(search_term)
    response = conn.get("search/movie") do |req| 
      req.params["query"] = search_term
    end
    JSON.parse(response.body)["results"].first(20)
  end

  def self.get_movie_details(movie_id)
    response = conn.get("movie/#{movie_id}") 
    JSON.parse(response.body)
  end

  def self.get_movie_credits(movie_id)
    response = conn.get("movie/#{movie_id}/credits")
    JSON.parse(response.body)
  end

  def self.get_movie_reviews(movie_id)
    response = conn.get("movie/#{movie_id}/reviews")
    JSON.parse(response.body)
  end

  private

  def self.conn
    conn = Faraday.new(
      url: 'https://api.themoviedb.org/3',
      params: {api_key: Rails.application.credentials.tmdb[:key]}
    )
  end
end