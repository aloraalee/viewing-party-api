class MovieGateway
  def self.get_top_rated
    conn = Faraday.new(
      url: 'https://api.themoviedb.org/3',
      params: {api_key: Rails.application.credentials.tmdb[:key]}
    )

    response = conn.get("movie/top_rated") 

    JSON.parse(response.body)["results"].first(20)
  end

  def self.search_movies_by_keyword(search_term)
    conn = Faraday.new(
      url: 'https://api.themoviedb.org/3',
      params: {api_key: Rails.application.credentials.tmdb[:key]}
    )

    response = conn.get("search/movie") do |req| 
      req.params["query"] = search_term

    end
    JSON.parse(response.body)["results"].first(20)
  end
end