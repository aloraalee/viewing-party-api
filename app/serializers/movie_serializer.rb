class MovieSerializer
  include JSONAPI::Serializer

  def self.format_movie_info(movies)
    { data:
        movies.map do |movie|
          {
            id: movie["id"].to_s,
            type: "movie",
            attributes: {
              title: movie["title"],
              vote_average: movie["vote_average"]
            }
          }
        end
    }
  end

  def self.format_runtime_conversion(minutes)
    '%d hours, %02d minutes' % minutes.divmod(60)
  end

  def self.format_movie_details(movie_details, movie_credits, movie_reviews)
    { data:
      {
        id: movie_details["id"].to_s,
        type: "movie",
        attributes: {
          title: movie_details["title"],
          release_year: movie_details["release_date"],
          vote_average: movie_details["vote_average"],
          runtime: format_runtime_conversion(movie_details["runtime"]),
          genres: movie_details["genres"].map do |genre|
            genre["name"]
          end,
          summary: movie_details["overview"],
          cast: movie_credits["cast"][0..9].map do |cast_member|
            {
              character: cast_member["character"],
              actor: cast_member["name"]
            }
            end,
          total_reviews: movie_reviews["results"].count,
          reviews: movie_reviews["results"][0..4].map do |review|
            {
              author: review["author"],
              review: review["content"]
            }
          end
        }
      }
    }
  end

end