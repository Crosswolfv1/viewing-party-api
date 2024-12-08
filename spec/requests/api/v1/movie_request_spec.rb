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

    it "happy when given a search param search based on that param and returns 20 or less results", :vcr do
      get "/api/v1/movies?query=pineapple"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][0][:id]).to be_a(Integer)
      expect(json[:data][0][:type]).to eq("movie")
      expect(json[:data][0][:attributes]).to have_key(:title)
      expect(json[:data][0][:attributes]).to have_key(:vote_average)
      expect(json[:data].count).to be <= 20
    end

    it "sad if param is empty returns an error" do
      get "/api/v1/movies?query="

      expect(response).not_to be_successful
      expect(response).to have_http_status(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:message]).to eq("Query cannot be empty")
    end
  end

  describe "show" do
    it "returns a specific movie" do
      get "/api/v1/movies/120"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:id]).to be_a(Integer)
      expect(json[:data][:attributes]).to have_key(:title)
      expect(json[:data][:attributes]).to have_key(:runtime)
    end
  end
end