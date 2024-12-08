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

  def validate_user_id
    raise ArgumentError, "User_id is invalid" unless User.find_by(id: @params[:user_id])
  end

  def validate_start_end_time
    raise ArgumentError, "Invalid or missing start_time or end_time" if @params[:start_time].nil? || params[:end_time].nil?
    start_time = Time.parse(@params[:start_time])
    end_time = Time.parse(@params[:end_time])
    raise ArgumentError, "End time cannot be before start time" unless start_time < end_time
  end
end