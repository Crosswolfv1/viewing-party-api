# frozen_string_literal: true

class ViewingPartyService
  def initialize(params)
    @params = params
  end

  def create_viewing_party
    validate_params
    new_party = ViewingParty.create!(@params.permit(:name, :start_time, :end_time, :movie_id, :movie_title))
    create_joins_table_entries(new_party)
    new_party
  end

  private

  def validate_params
    ViewingPartyValidator.new(@params).validate_all
  end

  def create_joins_table_entries(new_party)
    User.find(@params[:user_id]).user_viewing_parties.create!(viewing_party_id: new_party.id, host: true)
    @params[:invitees].each do |invitee_id|
      invitee = User.find(invitee_id)
      UserViewingParty.create!(viewing_party_id: new_party.id, user_id: invitee.id, host: false)
    end
  end
end
