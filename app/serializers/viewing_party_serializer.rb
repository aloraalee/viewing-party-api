class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :start_time, :end_time, :movie_id, :movie_title

  attribute :invitees do |object|
    object.attendees.pluck(:user_id)
  end
end