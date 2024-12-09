# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Viewing Parties Endpoint' do
  before(:all) do
    @user1 = User.create!(name: Faker::Name.name, username: Faker::Internet.username,
                          password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
    @user2 = User.create!(name: Faker::Name.name, username: Faker::Internet.username,
                          password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
    @user3 = User.create!(name: Faker::Name.name, username: Faker::Internet.username,
                          password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
    @user4 = User.create!(name: Faker::Name.name, username: Faker::Internet.username,
                          password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
    @testing_params = {
      name: "Juliet's Bday Movie Bash!",
      start_time: '2025-02-01 10:00:00',
      end_time: '2025-02-01 14:30:00',
      movie_id: 278,
      movie_title: 'The Shawshank Redemption',
      invitees: [@user2.id, @user3.id]
    }
    @bad_invitees = {
      name: "Juliet's Bday Movie Bash!",
      start_time: '2025-02-01 10:00:00',
      end_time: '2025-02-01 14:30:00',
      movie_id: 278,
      movie_title: 'The Shawshank Redemption',
      invitees: [@user2.id, @user3.id, 300]
    }
    @missing_name = {
      start_time: '2025-02-01 10:00:00',
      end_time: '2025-02-01 14:30:00',
      movie_id: 278,
      movie_title: 'The Shawshank Redemption',
      invitees: [@user2.id, @user3.id]
    }
    @missing_start = {
      name: "Juliet's Bday Movie Bash!",
      end_time: '2025-02-01 14:30:00',
      movie_id: 278,
      movie_title: 'The Shawshank Redemption',
      invitees: [@user2.id, @user3.id]
    }
    @missing_end = {
      name: "Juliet's Bday Movie Bash!",
      start_time: '2025-02-01 10:00:00',
      movie_id: 278,
      movie_title: 'The Shawshank Redemption',
      invitees: [@user2.id, @user3.id]
    }
    @missing_movie_id = {
      name: "Juliet's Bday Movie Bash!",
      start_time: '2025-02-01 10:00:00',
      end_time: '2025-02-01 14:30:00',
      movie_title: 'The Shawshank Redemption',
      invitees: [@user2.id, @user3.id]
    }
    @missing_movie_title = {
      name: "Juliet's Bday Movie Bash!",
      start_time: '2025-02-01 10:00:00',
      end_time: '2025-02-01 14:30:00',
      movie_id: 278,
      invitees: [@user2.id, @user3.id]
    }
    @missing_invitees = {
      name: "Juliet's Bday Movie Bash!",
      start_time: '2025-02-01 10:00:00',
      end_time: '2025-02-01 14:30:00',
      movie_id: 278,
      movie_title: 'The Shawshank Redemption'
    }
    @end_before_start = {
      name: "Juliet's Bday Movie Bash!",
      start_time: '2025-02-01 14:30:00',
      end_time: '2025-02-01 10:00:00',
      movie_id: 278,
      movie_title: 'The Shawshank Redemption',
      invitees: [@user2.id, @user3.id]
    }
    @too_short = {
      name: "Juliet's Bday Movie Bash!",
      start_time: '2025-02-01 10:00:00',
      end_time: '2025-02-01 10:30:00',
      movie_id: 278,
      movie_title: 'The Shawshank Redemption',
      invitees: [@user2.id, @user3.id]
    }
    @bad_user_id = 236
  end

  after(:all) do
    User.delete_all
  end

  describe 'creating a viewing party' do
    it 'happy: can create viewing parties and Users viewing parties' do
      post "/api/v1/viewing_parties/?user_id=#{@user1.id}", params: @testing_params
      party_created = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(party_created[:data]).to have_key(:id)
      expect(party_created[:data][:id]).to be_an(String)
      expect(party_created[:data]).to have_key(:type)
      expect(party_created[:data][:type]).to eq('viewing_party')
      expect(party_created[:data]).to have_key(:attributes)
      expect(party_created[:data][:attributes]).to be_a(Hash)

      expect(party_created[:data][:attributes]).to have_key(:name)
      expect(party_created[:data][:attributes][:name]).to be_a(String)
      expect(party_created[:data][:attributes][:name]).to eq("Juliet's Bday Movie Bash!")
      expect(party_created[:data][:attributes]).to have_key(:start_time)
      expect(party_created[:data][:attributes][:start_time]).to be_a(String)
      expect(party_created[:data][:attributes][:start_time]).to eq('2025-02-01T10:00:00.000Z')
      expect(party_created[:data][:attributes]).to have_key(:end_time)
      expect(party_created[:data][:attributes][:end_time]).to be_a(String)
      expect(party_created[:data][:attributes][:end_time]).to eq('2025-02-01T14:30:00.000Z')
      expect(party_created[:data][:attributes]).to have_key(:movie_id)
      expect(party_created[:data][:attributes][:movie_id]).to be_a(Integer)
      expect(party_created[:data][:attributes][:movie_id]).to eq(278)
      expect(party_created[:data][:attributes]).to have_key(:movie_title)
      expect(party_created[:data][:attributes][:movie_title]).to be_a(String)
      expect(party_created[:data][:attributes][:movie_title]).to eq('The Shawshank Redemption')
      expect(party_created[:data][:attributes]).to have_key(:invitees)
      expect(party_created[:data][:attributes][:invitees]).to be_an(Array)

      expect(party_created[:data][:attributes][:invitees].count).to eq(2)
      expect(party_created[:data][:attributes][:invitees][0]).to be_a(Hash)

      expect(party_created[:data][:attributes][:invitees][0]).to have_key(:id)
      expect(party_created[:data][:attributes][:invitees][0][:id]).to be_a(Integer)
      expect(party_created[:data][:attributes][:invitees][0][:id]).to eq(@user2.id)
      expect(party_created[:data][:attributes][:invitees][0]).to have_key(:name)
      expect(party_created[:data][:attributes][:invitees][0][:name]).to be_a(String)
      expect(party_created[:data][:attributes][:invitees][0][:name]).to eq(@user2.name)
      expect(party_created[:data][:attributes][:invitees][0]).to have_key(:username)
      expect(party_created[:data][:attributes][:invitees][0][:username]).to be_a(String)
      expect(party_created[:data][:attributes][:invitees][0][:username]).to eq(@user2.username)
    end

    describe 'sad paths for creating a party' do
      it 'is missing required parameters' do
        post '/api/v1/viewing_parties/?user_id=', params: @testing_params

        expect(response).not_to be_successful
        error1 = JSON.parse(response.body, symbolize_names: true)
        expect(error1[:message]).to eq('User_id is invalid')
        expect(error1[:status]).to eq(400)

        post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @missing_name
        error2 = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful
        expect(error2[:message]).to eq("Validation failed: Name can't be blank")
        expect(error2[:status]).to eq(400)

        post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @missing_start
        error3 = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful
        expect(error3[:message]).to eq('Invalid or missing start_time or end_time')
        expect(error3[:status]).to eq(400)

        post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @missing_end
        error4 = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful
        expect(error4[:message]).to eq('Invalid or missing start_time or end_time')
        expect(error4[:status]).to eq(400)

        post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @missing_movie_id
        error5 = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful
        expect(error5[:message]).to eq("Validation failed: Movie can't be blank")
        expect(error5[:status]).to eq(400)

        post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @missing_movie_title
        error6 = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful
        expect(error6[:message]).to eq("Validation failed: Movie title can't be blank")
        expect(error6[:status]).to eq(400)

        post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @missing_invitees
        error7 = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful
        expect(error7[:message]).to eq("Validation failed: Invitees can't be blank")
        expect(error7[:status]).to eq(400)
      end

      it 'duration of movie is greater than duration of party' do # rubocop:disable RSpec/MultipleExpectations
        post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @too_short
        error = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful
        expect(error[:message]).to eq('Movie is too long for viewing party')
        expect(error[:status]).to eq(400)
      end

      it 'end time is before start time' do
        post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @end_before_start
        error = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful
        expect(error[:message]).to eq('End time cannot be before start time')
        expect(error[:status]).to eq(400)
      end

      it 'has an invalid user ID as one of the invitees' do
        post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @bad_invitees
        error = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful
        expect(error[:message]).to eq('Invitee:300 is invalid')
        expect(error[:status]).to eq(400)
      end
    end
  end
end
