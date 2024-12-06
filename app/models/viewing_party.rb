class ViewingParty < ApplicationRecord
  has_many :users_viewing_parties
  has_many :users, through: :users_viewing_parties

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true
  validates :movie_title, presence: true
end