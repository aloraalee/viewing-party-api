require "rails_helper"

RSpec.describe MovieGateway do
  describe "get top rated movies" do
    it "calls TMDB API and returns json response" do
      response_hash = MovieGateway.get_top_rated
      first_movie = response_hash[0]

      expect(response_hash).to be_an Array
      expect(first_movie).to include("title")
      expect(first_movie).to include("vote_average")
    end
  end

  describe "get movies for a search word" do
    it "calls TMDB API with search word and returns json response" do
      response_hash = MovieGateway.search_movies_by_keyword("Lord of the Rings")
      first_movie = response_hash[0]

      expect(response_hash).to be_an Array
      expect(first_movie).to include("title")
      expect(first_movie["title"]).to be_a String
      expect(first_movie).to include("vote_average")
      expect(first_movie["vote_average"]).to be_a Float
      expect(first_movie["title"]).to include("Lord of the Rings")
    end
  end
end