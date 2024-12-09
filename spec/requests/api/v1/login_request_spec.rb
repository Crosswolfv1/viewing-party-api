# frozen_string_literal: true

require 'rails_helper'

describe 'Sessions API' do
  describe '#create action (login)' do
    context 'request is valid' do
      before do
        User.create(name: 'Me', username: 'its_me', password: 'reallyGoodPass')
      end

      it 'returns 200 and provide the appropriate data' do
        user_params = { username: 'its_me', password: 'reallyGoodPass' }

        post api_v1_sessions_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).not_to have_key(:password)
      end
    end

    context 'request is invalid' do
      it 'returns error for bad credentials' do
        user_params = { email: 'me@turing.edu', password: 'diffPass' }

        post api_v1_sessions_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:unauthorized)
        expect(json[:message]).to eq('Invalid login credentials')
        expect(json[:status]).to eq(401)
      end
    end
  end
end
