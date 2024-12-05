require "rails_helper"

RSpec.describe UsersViewingParty, type: :model do
  describe "validations" do
    it { should belong_to :user}
    it { should belong_to :viewing_party}

    it { should validate_presence_of(:viewing_party_id) }
    it { should validate_presence_of(:user_id) }
  end
end