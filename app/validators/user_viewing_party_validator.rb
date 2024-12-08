class UserViewingPartyValidator
  def initialize(params)
    @params = params
  end

  def validate_all
    validate_party
    validate_user
  end


  private

  def validate_party
    raise ArgumentError, "Validation failed: Invalid Party ID" unless ViewingParty.find(@params[:party_id]).present?
  end

  def validate_user
    raise ArgumentError, "Validation failed: Invalid User ID" unless User.find(@params[:invitees_user_id]).present?
  end
end