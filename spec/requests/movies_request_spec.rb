require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "Get Top Rated Movie Endpoint" do
    context "when request is valid" do
      it "returns 201 OK and provides expected fields" do
        json_response = File.read("spec/fixtures/top_rated_movies.json")
        stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=3c80aae3b943fcf5c5811e84b5258a1f").
          to_return(status: 200, body: json_response, headers: {})

        get api_v1_movies_path
        
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data]).to be_an(Array)
        expect(json[:data].first[:type]).to eq("movie")
        expect(json[:data].first[:id]).to be_present
        expect(json[:data].first[:attributes][:title]).to eq("The Shawshank Redemption")
        expect(json[:data].first[:attributes][:vote_average]).to eq(8.708)
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
