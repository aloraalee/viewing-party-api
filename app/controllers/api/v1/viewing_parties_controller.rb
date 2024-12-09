class Api::V1::ViewingPartiesController < ApplicationController

  def create
    viewing_party = ViewingParty.new(viewing_party_params.except(:invitees))
    runtime = fetch_movie_runtime(viewing_party.movie_id)

    if runtime && (viewing_party_params[:end_time].to_time - viewing_party_params[:start_time].to_time) / 60 < runtime
      return render json: ErrorSerializer.format_error(ErrorMessage.new("Error with the given start or end time", 400)), status: :bad_request
    end

    if viewing_party.save
      host_id = viewing_party_params[:invitees].first
      if User.exists?(id: host_id)
        Attendee.create!(viewing_party_id: viewing_party.id, user_id: host_id, is_host: true)
      end
      viewing_party_params[:invitees][1..-1].each do |invitee_id|
        if User.exists?(id: invitee_id)
          Attendee.create!(viewing_party_id: viewing_party.id, user_id: invitee_id, is_host: false)
        end
      end
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def fetch_movie_runtime(movie_id)
    conn = Faraday.new(
      url: 'https://api.themoviedb.org/3',
      params: {api_key: Rails.application.credentials.tmdb[:key]}
    )
    response = conn.get("movie/#{movie_id}") 
    JSON.parse(response.body)["runtime"]
  end
  

private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, invitees: [])
  end

end