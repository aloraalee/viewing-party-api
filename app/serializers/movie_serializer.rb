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

  def self.format_movie_details(movie)
    # binding.pry
    { data:
      {
        id: movie["id"].to_s,
        type: "movie",
        attributes: {
          title: movie["title"],
          release_year: movie["release_date"],
          vote_average: movie["vote_average"],
          runtime: movie["runtime"],
          genres: movie["genres"].map do |genre|
            genre["name"]
          end,
          summary: movie["overview"]
      #     summary:
      #     cast: [
      #     {
      #       character:
      #       actor:
      #     }
      #     ],
      #     total_reviews:
      #     reviews [
      #     {
      #       author:
      #       review:
      #     }
      #     ]
        }
      }
    }
  end

end