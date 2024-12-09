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
      expect(json[:data][:id]).to be_an(Integer) 
      expect(json[:data][:type]).to eq("movie")
      
      expect(json[:data][:attributes]).to have_key(:title)
      expect(json[:data][:attributes][:title]).to be_a(String)

      expect(json[:data][:attributes]).to have_key(:release_year)
      expect(json[:data][:attributes][:release_year]).to be_a(Integer)
      
      expect(json[:data][:attributes]).to have_key(:vote_average)
      expect(json[:data][:attributes][:vote_average]).to be_a(Float)
      
      expect(json[:data][:attributes]).to have_key(:runtime)
      expect(json[:data][:attributes][:runtime]).to be_a(String)
      
      expect(json[:data][:attributes]).to have_key(:genres)
      expect(json[:data][:attributes][:genres]).to be_an(Array)
      
      expect(json[:data][:attributes]).to have_key(:summary)
      expect(json[:data][:attributes][:summary]).to be_a(String)
      
      expect(json[:data][:attributes]).to have_key(:cast)
      expect(json[:data][:attributes][:cast].length).to be <= 10
      expect(json[:data][:attributes][:cast].first).to have_key(:character)
      expect(json[:data][:attributes][:cast].first).to have_key(:actor)
      
      expect(json[:data][:attributes]).to have_key(:total_reviews)
      expect(json[:data][:attributes][:total_reviews]).to be_an(Integer)
      
      expect(json[:data][:attributes]).to have_key(:reviews)
      expect(json[:data][:attributes][:reviews].length).to be <= 5
      expect(json[:data][:attributes][:reviews].first).to have_key(:author)
      expect(json[:data][:attributes][:reviews].first).to have_key(:review)
    end
  end
end