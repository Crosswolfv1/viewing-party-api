require "rails_helper"

RSpec.describe Movie do
  it "initializes" do
    sample_input_raw = File.read("spec/fixtures/moviedb_movie_top_rated.json")
    sample_input = JSON.parse(sample_input_raw, symbolize_names: true)
    result_movie = Movie.new(sample_input[:results][0])

    expect(result_movie.id).to eq(567904)
    expect(result_movie.title).to eq("Pineapple")
    expect(result_movie.vote_average).to eq(0.0)
  end
end