require "rails_helper"

RSpec.describe "Attendeess", type: :request do
  describe "Create Attendee Endpoint" do
    before(:each) do 
      @user_1 = User.create!(name: "Brian", username: "its_brian", password: "password123", password_confirmation: "password123", id: 11)
      @user_2 = User.create!(name: "Ellen", username: "its_ellen", password: "secureandstuff", password_confirmation: "secureandstuff", id: 7)
      @user_3 = User.create!(name: "Zach", username: "its_zach", password: "whatacrappypassword", password_confirmation: "whatacrappypassword", id: 5)
      @user_4 = User.create!(name: "Alora", username: "its_alora", password: "dontbreakin!", password_confirmation: "dontbreakin!", id: 14)
      @viewing_party = ViewingParty.create!(
        id: 10,
        name: "Juliet's Bday Movie Bash!", 
        start_time: "2025-02-01 10:00:00", 
        end_time: "2025-02-01 14:30:00", 
        movie_id: 278, 
        movie_title: "The Shawshank Redemption"
      )
        [11, 7, 5].each do |user_id|
        user = User.find_by(id: user_id)
        if user
          Attendee.create!(viewing_party_id: @viewing_party.id, user_id: user.id)
        end
      end
    end

    let(:additional_user_params) do
      {
        invitees_user_id: 14
      }
    end

    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_viewing_party_attendees_path(viewing_party_id: @viewing_party.id), params: additional_user_params, as: :json
        
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to eq("10")
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
          },
                  {
            "id": 14,
            "name": "Alora",
            "username": "its_alora"
          }
        ])
      end
    end

    # let(:iadditional_user_params) do
    #   {
    #     invitees_user_id: 14
    #   }
    # end

    context "request is invalid" do
      it "returns 400 Error " do
        post api_v1_viewing_party_attendees_path(viewing_party_id: 999), params: additional_user_params, as: :json
        
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Viewing party does not exist")
        expect(json[:status]).to eq(400)
      end
    end

    let(:invalid_additional_user_params) do
      {
        invitees_user_id: 10
      }
    end

    context "request is invalid because user can't be found" do
      it "returns 400 Error " do
        post api_v1_viewing_party_attendees_path(viewing_party_id: @viewing_party.id), params: invalid_additional_user_params, as: :json
        
        json = JSON.parse(response.body, symbolize_names: true)
  
        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("User not found")
        expect(json[:status]).to eq(400)
      end
    end
  end
end