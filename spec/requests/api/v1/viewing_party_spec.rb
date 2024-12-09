require "rails_helper"

RSpec.describe "Viewing Parties", type: :request do
  describe "Create Viewing Party Endpoint" do
    before(:each) do 
      user = User.create!(name: "Brian", username: "its_brian", password: "password123", password_confirmation: "password123", id: 11)
      user = User.create!(name: "Ellen", username: "its_ellen", password: "secureandstuff", password_confirmation: "secureandstuff", id: 7)
      user = User.create!(name: "Zach", username: "its_zach", password: "whatacrappypassword", password_confirmation: "whatacrappypassword", id: 5)
    end

    let(:viewing_party_params) do
      {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        invitees: [11, 7, 5]
      }
    end

    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_viewing_parties_path, params: viewing_party_params, as: :json
      
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:type]).to eq("viewing_party")
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:attributes]).to have_key(:name)
        expect(json[:data][:attributes]).to have_key(:start_time)
        expect(json[:data][:attributes]).to have_key(:end_time)
        expect(json[:data][:attributes]).to have_key(:movie_id)
        expect(json[:data][:attributes]).to have_key(:movie_title)
        expect(json[:data][:attributes]).to have_key(:invitees)
        expect(json[:data][:attributes][:invitees]).to eq([
          {
            "id": 11,
            "name": "Brian",
            "username": "its_brian"
          },
                  {
            "id": 7,
            "name": "Ellen",
            "username": "its_ellen"
          },
                  {
            "id": 5,
            "name": "Zach",
            "username": "its_zach"
          }
        ])
      end
    end

    let(:viewing_party_params_incomplete) do
      {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_title: "The Shawshank Redemption",
        invitees: [11, 7, 5]
      }
    end

    context "request is insufficient" do
      it "returns 400 Error " do

        post api_v1_viewing_parties_path, params: viewing_party_params_incomplete, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Movie can't be blank")
        expect(json[:status]).to eq(400)
      end
    end

    let(:viewing_party_params_insufficient_time) do
      {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 11:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        invitees: [11, 7, 5]
      }
    end

    context "request is not possible because of time constraint" do
      it "returns 400 Error " do

        post api_v1_viewing_parties_path, params: viewing_party_params_insufficient_time, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Error with the given start or end time")
        expect(json[:status]).to eq(400)
      end
    end

    let(:viewing_party_params_time_order_incorrect) do
      {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 14:30:00",
        end_time: "2025-02-01 10:00:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        invitees: [11, 7, 5]
      }
    end

    context "request is not possible because end time is before start time" do
      it "returns 400 Error " do

        post api_v1_viewing_parties_path, params: viewing_party_params_time_order_incorrect, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Error with the given start or end time")
        expect(json[:status]).to eq(400)
      end
    end

    let(:viewing_party_params_invalid_user) do
      {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        invitees: [11, 7, 5, 18]
      }
    end

    context "request is valid" do
      it "returns 201 Created, but the invalid user is excluded" do
        post api_v1_viewing_parties_path, params: viewing_party_params_invalid_user, as: :json
      
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:type]).to eq("viewing_party")
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:attributes]).to have_key(:name)
        expect(json[:data][:attributes]).to have_key(:start_time)
        expect(json[:data][:attributes]).to have_key(:end_time)
        expect(json[:data][:attributes]).to have_key(:movie_id)
        expect(json[:data][:attributes]).to have_key(:movie_title)
        expect(json[:data][:attributes]).to have_key(:invitees)
        expect(json[:data][:attributes][:invitees]).to eq([
          {
            "id": 11,
            "name": "Brian",
            "username": "its_brian"
          },
                  {
            "id": 7,
            "name": "Ellen",
            "username": "its_ellen"
          },
                  {
            "id": 5,
            "name": "Zach",
            "username": "its_zach"
          }
        ])
      end
    end
  end
end