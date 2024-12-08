class ViewingPartyValidator
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ArgumentError, with: :invalid_parameters

  def initialize(params)
    @params = params
  end

  def validate_all
    validate_invitees
    validate_user_id
    validate_start_end_time
    validate_session_length
  end

  private

  def validate_invitees
    raise ArgumentError, "Validation failed: Invitees can't be blank" unless @params.has_key?(:invitees)
    @params[:invitees].each do |invitee|
      raise ArgumentError, "Invitee:#{invitee} is invalid" unless User.find_by(id: invitee)
    end
  end

  
end