# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
@user1 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
@user2 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
@user3 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
@user4 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))

@party1 = ViewingParty.create!(
  name: Faker::FunnyName.name,
  start_time: "2025-02-01 10:00:00",
  end_time: "2025-02-01 14:30:00",
  movie_id: 278,
  movie_title: "The Shawshank Redemption"
)
@party2 = ViewingParty.create!(
  name: Faker::FunnyName.name,
  start_time: "2025-02-02 10:00:00",
  end_time: "2025-02-02 14:30:00",
  movie_id: 120,
  movie_title: "Lord of the rings"
)
@party3 = ViewingParty.create!(
  name: Faker::FunnyName.name,
  start_time: "2025-02-03 10:00:00",
  end_time: "2025-02-03 14:30:00",
  movie_id: 2164,
  movie_title: "Stargate"
)

UserViewingParty.create!(user: @user1, viewing_party: @party1, host: true)
UserViewingParty.create!(user: @user2, viewing_party: @party1, host: false)
UserViewingParty.create!(user: @user3, viewing_party: @party1, host: false)

UserViewingParty.create!(user: @user1, viewing_party: @party2, host: true)
UserViewingParty.create!(user: @user4, viewing_party: @party2, host: false)

UserViewingParty.create!(user: @user2, viewing_party: @party3, host: true)
UserViewingParty.create!(user: @user1, viewing_party: @party3, host: false)
UserViewingParty.create!(user: @user4, viewing_party: @party3, host: false)
User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")
User.create!(name: "Morgan Freeman", username: "morgan_f", password: "VoiceOfGod99")
User.create!(name: "Emma Stone", username: "emma_stone_94", password: "LaLaLand@2024")
User.create!(name: "Chris Hemsworth", username: "thor_4eva", password: "HammerTime123")
User.create!(name: "Beyoncé Knowles", username: "beyonce_queen", password: "RunTheWorld1")
User.create!(name: "Keanu Reeves", username: "theone_keanu", password: "MatrixRules007")
User.create!(name: "Oprah Winfrey", username: "oprah_w", password: "YouGetACar2024")
