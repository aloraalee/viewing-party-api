require "rails_helper"

RSpec.describe ViewingPartyGateway do
  describe "get a movie's runtime" do
    it "calls TMDB API and returns json response" do
      response_hash = ViewingPartyGateway.fetch_movie_runtime(278)

      expect(response_hash).to be_an Integer
      expect(response_hash).to eq(142)
    end
  end
end