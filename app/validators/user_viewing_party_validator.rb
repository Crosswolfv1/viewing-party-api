# frozen_string_literal: true

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
    return if ViewingParty.find_by(id: @params[:party_id]).present?

    raise ArgumentError,
          'Validation failed: Invalid Party ID'
  end

  def validate_user
    return if User.find_by(id: @params[:viewing_party_user_id]).present?

    raise ArgumentError,
          'Validation failed: Invalid User ID'
  end

  def validate_invitees
    return if User.find_by(id: @params[:invitees_user_id]).present?

    raise ArgumentError,
          'Validation failed: Invalid Invitee ID'
  end
end
