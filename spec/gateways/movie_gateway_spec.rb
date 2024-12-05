require "rails_helper"

RSpec.describe MovieGateway do
  it "calls the movie API and returns 20 results" do
    response_array = MovieGateway.get_movies



    expect(response_array).to be_a(Array)
    first_movie = response_array[0]
    expect(first_movie.id).to be_an(Integer)
    expect(first_movie.title).to be_a(String)
    expect(first_movie.vote_average).to be_a(Float)
  end
end