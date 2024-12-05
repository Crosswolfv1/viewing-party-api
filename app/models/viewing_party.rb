class ViewingParty < ApplicationRecord
  has_one :users_viewing_party

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :movie_id, presence: true
  validates :movie_title, presence: true
  validates :invitees, presence: true
end