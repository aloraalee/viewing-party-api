class Api::V1::AttendeesController < ApplicationController
  def create
    viewing_party = ViewingParty.find(params[:viewing_party_id])
    
    user_id = params[:invitees_user_id]
    
    if User.exists?(id: user_id)
      attendee = Attendee.create!(viewing_party: viewing_party, user_id: user_id)

      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new("User not found", 400)), status: :bad_request
    end
  end
end