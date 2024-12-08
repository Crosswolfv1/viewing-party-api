class Api::V1::ViewingPartiesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ArgumentError, with: :invalid_parameters
  def create
    validate_params(params)
    new_party = ViewingParty.create!(viewing_party_params)
    render json: ViewingPartySerializer.new(new_party, { params: { invitees: params[:invitees] } }), status: :created
    user = User.find(params[:user_id])
    UsersViewingParty.create!( { viewing_party_id: new_party.id, user_id: user.id, host: true} )

    params[:invitees].each do |invitee_id|
      invitee = User.find(invitee_id)
      UsersViewingParty.create!({ viewing_party_id: new_party.id, user_id: invitee.id, host: false})
    end
  end

  private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end

  def validate_params(params)
    raise ArgumentError, "Validation failed: Invitees can't be blank" unless params.has_key?(:invitees)
    validate_user(params[:user_id])
    validate_invitees(params[:invitees])
    validate_start_end_time(params)
    validate_session_length(params)
  end

  def validate_session_length(params)
    start_time = Time.parse(params[:start_time]).to_i
    end_time = Time.parse(params[:end_time]).to_i
    binding.pry
  end

  def validate_user(user_id)
    raise ArgumentError, "User_id is invalid" unless User.find_by(id: user_id)
  end

  def validate_start_end_time(params)
    raise ArgumentError, "Invalid or missing start_time or end_time" if params[:start_time].nil? || params[:end_time].nil?
    start_time = Time.parse(params[:start_time])
    end_time = Time.parse(params[:end_time])
    raise ArgumentError, "End time cannot be before start time" unless start_time < end_time
  end

  def validate_invitees(invitees)
    invitees.each do |invitee|
      raise ArgumentError, "Invitee:#{invitee} is invalid" unless User.find_by(id: invitee)
    end
  end

  def invalid_parameters(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception, 400)), status: :bad_request
  end

  def record_invalid(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception, 400)), status: :bad_request
  end
end