# frozen_string_literal: true

class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :start_time, :end_time, :movie_id, :movie_title
  attribute :invitees do |_viewing_party, params|
    params[:invitees].map do |invitee|
      user = User.find(invitee)
      {
        id: user.id,
        name: user.name,
        username: user.username
      }
    end
  end

  set_type :viewing_party
end
