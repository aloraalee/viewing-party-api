require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "Get Top Rated Movie Endpoint" do
    let(:movie_params) do
      {
        title: "The Shawshank Redemption",
        vote_average: 8.708,
      }
    end

    context "when request is valid" do
      it "returns 201 OK and provides expected fields" do
        get api_v1_movies_path
        
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data]).to be_an(Array)
        expect(json[:data].first[:type]).to eq("movie")
        expect(json[:data].first[:id]).to be_present
        expect(json[:data].first[:attributes][:title]).to eq(movie_params[:title])
        expect(json[:data].first[:attributes][:vote_average]).to eq(movie_params[:vote_average])
      end
    end
  end

  describe "Get Movie Search Endpoint" do
    let(:movie_params) do
      {
        title: "The Lord of the Rings: The Fellowship of the Ring",
        vote_average: 8.415
      }
    end

    context "when request is valid" do
      it "returns 201 OK and provides expected fields" do
        get "/api/v1/search/movie", params: { query: "Lord of the Rings" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data]).to be_an(Array)
        expect(json[:data].first[:type]).to eq("movie")
        expect(json[:data].first[:id]).to be_present
        expect(json[:data].first[:attributes][:title]).to eq(movie_params[:title])
        expect(json[:data].first[:attributes][:vote_average]).to eq(movie_params[:vote_average])        
      end
    end
  end
end
