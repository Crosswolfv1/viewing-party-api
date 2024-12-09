# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewingParty do
  describe 'validations' do
    it { is_expected.to have_many :user_viewing_parties }
    it { is_expected.to have_many(:users).through(:user_viewing_parties) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:movie_id) }
    it { is_expected.to validate_presence_of(:movie_title) }
  end
end
