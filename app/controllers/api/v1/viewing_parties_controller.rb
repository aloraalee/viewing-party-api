class Api::V1::ViewingPartiesController < ApplicationController

  def create
    viewing_party = ViewingParty.new(viewing_party_params.except(:invitees))
    
    if viewing_party.save
      if viewing_party_params[:invitees].present?
        viewing_party_params[:invitees].each do |invitee_id|
          Attendee.create!(viewing_party_id: viewing_party.id, user_id: invitee_id)
        end
      end
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end
  

private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, invitees: [])
  end

end