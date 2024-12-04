require "rails_helper"

RSpec.describe "Movies API", type: :request do
  context "request is valid" do
    it "returns 201 Created and provides expected fields" do
      get api_v1_movies_path, params: movie_params, as: :json
      
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:type]).to eq("movie")
      expect(json[:data][:id]).to eq(Movie.last.id.to_s)
      expect(json[:data][:attributes][:title]).to eq(movie_params[:title])
      expect(json[:data][:attributes][:vote_average]).to eq(movie_params[:vote_average])
    end
  end
end
