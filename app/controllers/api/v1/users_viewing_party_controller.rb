class Api::V1::UsersViewingPartyController < ApplicationController
  rescue_from ArgumentError, with: :invalid_parameters
  def create
    UserViewingPartyValidator.new(params).validate_all

    UserViewingParty.create!(viewing_party_id: ViewingParty.find(params[:party_id]).id, user_id: User.find(params[:invitees_user_id]).id, host: false)

    invitees = User.joins(:user_viewing_parties)
    .where(user_viewing_parties: { viewing_party_id: params[:party_id] })
    .where.not(user_viewing_parties: { host: true }).pluck(:id)

    render json: ViewingPartySerializer.new(ViewingParty.find(params[:party_id]),
     { params: { invitees: invitees } }
     ), status: :created
  end

  private

  def invalid_parameters(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception, 404)), status: :not_found
  end
end

