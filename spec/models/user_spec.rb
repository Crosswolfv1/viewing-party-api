require "rails_helper"

RSpec.describe User, type: :model do
  before(:all) do
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
  end

  after(:all) do
    UserViewingParty.delete_all
    User.delete_all
    ViewingParty.delete_all
  end
    
  describe "validations" do
    it { should have_many :user_viewing_parties }
    it { should have_many(:viewing_parties).through(:user_viewing_parties) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password }
    it { should have_secure_token(:api_key) }
  end

  describe "instance methods" do
    it "hosted_viewing_party" do
      expect(@user1.hosted_viewing_party.count).to eq(2)
    end

    it "invited_viewing_party" do
      expect(@user1.invited_viewing_party.count).to eq(1)
    end
  end
end