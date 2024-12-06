class Api::V1::ViewingPartiesController < ApplicationController
  rescue_from ArgumentError, with: :invalid_parameters
  def create
    validate_params(params)
    new = ViewingParty.create(viewing_party_params)
    user = User.find(params[:user_id])
    UsersViewingParty.create( { viewing_party_id: new.id, user_id: user.id, host: true} )
    params[:invitees].each do |invitee_id|
      invitee = User.find(invitee_id)
      UsersViewingParty.create({ viewing_party_id: new.id, user_id: invitee.id, host: false})
    end
  end

  private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end

  def validate_params(params)
    validate_user(params[:user_id])
    validate_invitees(params[:invitees])
  end

  def validate_user(user_id)
    raise ArgumentError, "User_id is invalid" unless User.find_by(id: user_id)
  end

  def validate_invitees(invitees)
    invitees.each do |invitee|
      raise ArgumentError, "Invitee is invalid" unless User.find_by(id: invitee)
    end
  end

  def invalid_parameters(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception, 400)), status: :bad_request
  end
end



# {
#   "data": {
#     "id": "1",
#     "type": "viewing_party",
#     "attributes": {
#       "name": "Juliet's Bday Movie Bash!",
#       "start_time": "2025-02-01 10:00:00",
#       "end_time": "2025-02-01 14:30:00",
#       "movie_id": 278,
#       "movie_title": "The Shawshank Redemption",
#       "invitees": [
#         {
#           "id": 11,
#           "name": "Barbara",
#           "username": "leo_fan"
#         },
#                 {
#           "id": 7,
#           "name": "Ceci",
#           "username": "titanic_forever"
#         },
#                 {
#           "id": 5,
#           "name": "Peyton",
#           "username": "star_wars_geek_8"
#         }
#       ]
#     }
#   }
# }