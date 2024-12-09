# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Users
user1 = User.find_or_create_by!(username: 'danny_de_v') do |user|
  user.name = 'Danny DeVito'
  user.password = 'jerseyMikesRox7'
end

user2 = User.find_or_create_by!(username: 'dollyP') do |user|
  user.name = 'Dolly Parton'
  user.password = 'Jolene123'
end

user3 = User.find_or_create_by!(username: 'futbol_geek') do |user|
  user.name = 'Lionel Messi'
  user.password = 'test123'
end

user4 = User.find_or_create_by!(username: 'morgan_f') do |user|
  user.name = 'Morgan Freeman'
  user.password = 'VoiceOfGod99'
end

additional_users = [
  { name: 'Emma Stone', username: 'emma_stone_94', password: 'LaLaLand@2024' },
  { name: 'Chris Hemsworth', username: 'thor_4eva', password: 'HammerTime123' },
  { name: 'Beyoncé Knowles', username: 'beyonce_queen', password: 'RunTheWorld1' },
  { name: 'Keanu Reeves', username: 'theone_keanu', password: 'MatrixRules007' },
  { name: 'Oprah Winfrey', username: 'oprah_w', password: 'YouGetACar2024' }
]

additional_users.each do |user_data|
  User.find_or_create_by!(username: user_data[:username]) do |user|
    user.name = user_data[:name]
    user.password = user_data[:password]
  end
end

party1 = ViewingParty.find_or_create_by!(name: 'Shawshank Escape Party') do |party|
  party.start_time = '2025-02-01 10:00:00'
  party.end_time = '2025-02-01 14:30:00'
  party.movie_id = 278
  party.movie_title = 'The Shawshank Redemption'
end

party2 = ViewingParty.find_or_create_by!(name: 'Ring Quest Party') do |party|
  party.start_time = '2025-02-02 10:00:00'
  party.end_time = '2025-02-02 14:30:00'
  party.movie_id = 120
  party.movie_title = 'Lord of the Rings'
end

party3 = ViewingParty.find_or_create_by!(name: 'Stargate Adventure Party') do |party|
  party.start_time = '2025-02-03 10:00:00'
  party.end_time = '2025-02-03 14:30:00'
  party.movie_id = 2164
  party.movie_title = 'Stargate'
end

UserViewingParty.find_or_create_by!(user: user1, viewing_party: party1) { |party| party.host = true }
UserViewingParty.find_or_create_by!(user: user2, viewing_party: party1) { |party| party.host = false }
UserViewingParty.find_or_create_by!(user: user3, viewing_party: party1) { |party| party.host = false }

UserViewingParty.find_or_create_by!(user: user1, viewing_party: party2) { |party| party.host = true }
UserViewingParty.find_or_create_by!(user: user4, viewing_party: party2) { |party| party.host = false }

UserViewingParty.find_or_create_by!(user: user2, viewing_party: party3) { |party| party.host = true }
UserViewingParty.find_or_create_by!(user: user1, viewing_party: party3) { |party| party.host = false }
UserViewingParty.find_or_create_by!(user: user4, viewing_party: party3) { |party| party.host = false }
