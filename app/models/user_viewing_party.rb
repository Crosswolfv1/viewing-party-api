class UserViewingParty < ApplicationRecord
  belongs_to :user
  belongs_to :viewing_party

  validates :viewing_party_id, presence: true
  validates :user_id, presence: true
end