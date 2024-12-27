class ViewingPartyGateway
  def self.fetch_movie_runtime(movie_id)
    conn = Faraday.new(
      url: 'https://api.themoviedb.org/3',
      params: {api_key: Rails.application.credentials.tmdb[:key]}
    )
    response = conn.get("movie/#{movie_id}") 
    JSON.parse(response.body)["runtime"]
  end
end