require "rails_helper"

RSpec.describe "Viewing Parties Endpoint" do
  describe "post" do
    before(:all) do
      @user1 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user2 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user3 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user4 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user5 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user6 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user7 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user8 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @testing_params = {
          name: "Juliet's Bday Movie Bash!",
          start_time: "2025-02-01 10:00:00",
          end_time: "2025-02-01 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption",
          invitees: [@user2.id, @user3.id]
        }
      @bad_invitees = {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        invitees: [@user2.id, @user3.id, 300] #need to find a way this number will always be unique
      }
      @bad_user_id = 236
    end

    it "happy: can create viewing parties and Users viewing parties" do
      post "/api/v1/viewing_parties/?user_id=#{@user1.id}", params: @testing_params 

      expect(response).to be_successful
      # item_created = JSON.parse(response.body, symbolize_names: true)
      # item = item_created[:data]
      # item_id = item_created[:data][:id]
      # expect(item_created[:data]).to have_key(:id)
      # expect(item_created[:data][:id]).to be_an(String)

    end
  end
end