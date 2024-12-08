class UserViewingPartyValidator
  def initialize(params)
    @params = params
  end

  def validate_all
    validate_party
    validate_user
    validate_invitees
  end


  private

  def validate_party
    raise ArgumentError, "Validation failed: Invalid Party ID" unless ViewingParty.find_by(id: @params[:party_id]).present?
  end

  def validate_user
    raise ArgumentError, "Validation failed: Invalid User ID" unless User.find_by(id: @params[:viewing_party_user_id]).present?
  end

  def validate_invitees
    raise ArgumentError, "Validation failed: Invalid Invitee ID" unless User.find_by(id: @params[:invitees_user_id]).present?
  end
end