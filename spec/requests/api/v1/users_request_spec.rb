require "rails_helper"

RSpec.describe "Users API", type: :request do
  after(:all) do
    User.delete_all
  end
    describe "Create User Endpoint" do
    let(:user_params) do
      {
        name: "Me",
        username: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end

    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_users_path, params: user_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:username]).to eq(user_params[:username])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique username" do
        User.create!(name: "me", username: "its_me", password: "abc123")

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        user_params = {
          name: "me",
          username: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        user_params[:username] = ""

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end

  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      User.create!(name: "Tom", username: "myspace_creator", password: "test123")
      User.create!(name: "Oprah", username: "oprah", password: "abcqwerty")
      User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy")

      get api_v1_users_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(3)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:username)
      expect(json[:data][0][:attributes]).to_not have_key(:password)
      expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
      expect(json[:data][0][:attributes]).to_not have_key(:api_key)
    end
  end

  describe "Get A single user's profile" do
    before(:each) do
      @user1 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user2 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user3 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))
      @user4 = User.create!(name: Faker::Name.name, username: Faker::Internet.username, password: Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true))

      @params1 = {
        name: Faker::FunnyName.name,
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        invitees: [@user2.id, @user3.id]
      }

      @params2 = {
        name: Faker::FunnyName.name,
        start_time: "2025-02-02 10:00:00",
        end_time: "2025-02-02 14:30:00",
        movie_id: 120,
        movie_title: "Lord of the rings",
        invitees: [@user2.id, @user4.id]
      }

      @params3 = {
      name: Faker::FunnyName.name,
      start_time: "2025-02-03 10:00:00",
      end_time: "2025-02-03 14:30:00",
      movie_id: 2164,
      movie_title: "Stargate",
      invitees: [@user1.id, @user4.id]
      }

      post "/api/v1/viewing_parties/?user_id=#{@user1.id}", params: @params1 
      post "/api/v1/viewing_parties/?user_id=#{@user1.id}", params: @params2 
      post "/api/v1/viewing_parties/?user_id=#{@user2.id}", params: @params3 
    end

    it "gets a user" do
      get "/api/v1/users/#{@user1.id}"
      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:type]).to eq("user")
      expect(json[:data][:id]).to be_an(Integer)
      expect(json[:data][:attributes][:name]).to eq(@user1[:name])
      expect(json[:data][:attributes][:username]).to eq(@user1[:username])

      expect(json[:data][:attributes]).to have_key(:viewing_parties_hosted)
      expect(json[:data][:attributes][:viewing_parties_hosted].count).to eq(2)

      expect(json[:data][:attributes]).to have_key(:viewing_parties_invited)
      expect(json[:data][:attributes][:viewing_parties_invited].count).to eq(1)

      expect(json[:data][:attributes]).to_not have_key(:password)
      expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
   end

   it "sadpath has bad user ID" do
    get "/api/v1/users/9999"
    json = JSON.parse(response.body, symbolize_names: true)
    expect(response).not_to be_successful
    expect(json[:message]).to eq("Record invalid")
    expect(json[:status]).to eq(400)

   end
  end
end
