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

  private

  def self.conn
    conn = Faraday.new(
      url: 'https://api.themoviedb.org/3',
      params: {api_key: Rails.application.credentials.tmdb[:key]}
    )
  end
end