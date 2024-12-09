# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_viewing_parties
  has_many :viewing_parties, through: :user_viewing_parties

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key

  def hosted_viewing_party
    ViewingParty.joins(:user_viewing_parties).where(user_viewing_parties: { user_id: id, host: true }).map do |party|
      {
        id: party[:id],
        name: party[:name],
        start_time: party[:start_time],
        end_time: party[:end_time],
        movie_id: party[:movie_id],
        movie_title: party[:movie_title],
        host_id: id
      }
    end
  end

  def invited_viewing_party
    ViewingParty.joins(:user_viewing_parties).where(user_viewing_parties: { user_id: id, host: false }).map do |party|
      {
        id: party[:id],
        name: party[:name],
        start_time: party[:start_time],
        end_time: party[:end_time],
        movie_id: party[:movie_id],
        movie_title: party[:movie_title],
        host_id: UserViewingParty.where(viewing_party_id: party[:id], host: true).pluck(:user_id)
      }
    end
  end
end
