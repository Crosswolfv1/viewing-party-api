# frozen_string_literal: true

RSpec.describe UserViewingParty do
  describe 'validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :viewing_party }
  end
end
