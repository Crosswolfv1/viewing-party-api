require "rails_helper"

RSpec.describe "Viewing Parties Endpoint" do
  before(:each) do
    @user1 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
    @user2 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
    @user3 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
    @user4 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
    @testing_params = {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        invitees: [@user2.id, @user3.id]
      }
     @invitees_param = {
      "invitees_user_id": @user4.id
      }
      @bad_user_id = 515151
      @bad_party = 32513651
      @bad_invitees_param = {invitees_user_id: 3503503503}
  end

  after(:each) do
    UserViewingParty.delete_all
    ViewingParty.delete_all
    User.delete_all
  end

  describe "create" do
    it "can create a new entry" do
      post "/api/v1/viewing_parties/?user_id=#{@user1.id}", params: @testing_params 
      party_created = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(party_created[:data][:attributes][:invitees].count).to eq(2)
      expect(party_created[:data][:attributes][:invitees][0]).to be_a(Hash)

      post "/api/v1/viewing_parties/#{@user1.id}/users_viewing_party/#{party_created[:data][:id]}", params: @invitees_param
      party_updated = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(party_updated[:data]).to have_key(:id)
      expect(party_updated[:data][:id]).to be_an(String)
      expect(party_updated[:data]).to have_key(:type)
      expect(party_updated[:data][:type]).to eq("viewing_party")
      expect(party_updated[:data]).to have_key(:attributes)
      expect(party_updated[:data][:attributes]).to be_a(Hash)
      expect(party_updated[:data][:attributes][:invitees].count).to eq(3)
      expect(party_updated[:data][:attributes][:invitees][0]).to be_a(Hash)
    end

    it "sad path: invalid user ID" do
      post "/api/v1/viewing_parties/?user_id=#{@user1.id}", params: @testing_params 
      party_created = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(party_created[:data][:attributes][:invitees].count).to eq(2)
      expect(party_created[:data][:attributes][:invitees][0]).to be_a(Hash)

      post "/api/v1/viewing_parties/#{@bad_user_id}/users_viewing_party/#{party_created[:data][:id]}", params: @invitees_param

      party_updated = JSON.parse(response.body, symbolize_names: true)
      expect(response).not_to be_successful

      expect(party_updated[:status]).to eq(404)
      expect(party_updated[:message]).to eq("Validation failed: Invalid User ID")
    end

    it "sad path: invalid party id" do
      post "/api/v1/viewing_parties/?user_id=#{@user1.id}", params: @testing_params 
      party_created = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(party_created[:data][:attributes][:invitees].count).to eq(2)
      expect(party_created[:data][:attributes][:invitees][0]).to be_a(Hash)

      post "/api/v1/viewing_parties/#{@user1.id}/users_viewing_party/#{@bad_party}", params: @invitees_param

      party_updated = JSON.parse(response.body, symbolize_names: true)
      expect(response).not_to be_successful

      expect(party_updated[:status]).to eq(404)
      expect(party_updated[:message]).to eq("Validation failed: Invalid Party ID")
    end

    it "sad path: invalid invitee" do
      post "/api/v1/viewing_parties/?user_id=#{@user1.id}", params: @testing_params 
      party_created = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(party_created[:data][:attributes][:invitees].count).to eq(2)
      expect(party_created[:data][:attributes][:invitees][0]).to be_a(Hash)

      post "/api/v1/viewing_parties/#{@user1.id}/users_viewing_party/#{party_created[:data][:id]}", params: @bad_invitees_param

      party_updated = JSON.parse(response.body, symbolize_names: true)
      expect(response).not_to be_successful

      expect(party_updated[:status]).to eq(404)
      expect(party_updated[:message]).to eq("Validation failed: Invalid Invitee ID")

    end
  end
end

