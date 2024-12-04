require "rails_helper"

RSpec.describe "Movie Endpoint" do
  describe "index" do
    it "happy, can retrieve up to 20 results from top rated", :vcr do
      get "/api/v1/movies"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][0][:id]).to be_a(Integer)
      expect(json[:data][0][:type]).to eq("movie")
      expect(json[:data][0][:attributes]).to have_key(:title)
      expect(json[:data][0][:attributes]).to have_key(:vote_average)
      expect(json[:data].count).to be <= 20
    end
  end
end