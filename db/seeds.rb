# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")
User.create!(name: "Morgan Freeman", username: "morgan_f", password: "VoiceOfGod99")
User.create!(name: "Emma Stone", username: "emma_stone_94", password: "LaLaLand@2024")
User.create!(name: "Chris Hemsworth", username: "thor_4eva", password: "HammerTime123")
User.create!(name: "Beyoncé Knowles", username: "beyonce_queen", password: "RunTheWorld1")
User.create!(name: "Keanu Reeves", username: "theone_keanu", password: "MatrixRules007")
User.create!(name: "Oprah Winfrey", username: "oprah_w", password: "YouGetACar2024")
