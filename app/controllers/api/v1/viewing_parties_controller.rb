class Api::V1::ViewingPartiesController < ApplicationController

  def create
    viewing_party = ViewingParty.create!(viewing_party_params.except(:invitees))
    
    if viewing_party_params[:invitees].present?
      viewing_party_params[:invitees].map do |invitee_id|
        attendee = Attendee.create!(viewing_party_id: viewing_party.id, user_id: invitee_id)
      end
    end
  
    render json: ViewingPartySerializer.new(viewing_party), status: :created
  end

private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, invitees: [])
  end

end