class Api::V1::ViewingPartiesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ArgumentError, with: :invalid_parameters
  def create
    new_party = ViewingPartyService.new(params).create_viewing_party
    render json: ViewingPartySerializer.new(new_party, { params: { invitees: params[:invitees] } }), status: :created
  end

  private

  def invalid_parameters(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception, 400)), status: :bad_request
  end

  def record_invalid(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception, 400)), status: :bad_request
  end
end