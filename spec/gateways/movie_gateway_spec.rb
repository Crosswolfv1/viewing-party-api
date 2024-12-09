# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovieGateway do
  it 'calls the movie API and returns 20 results' do
    response_array = described_class.get_movies

    expect(response_array).to be_a(Array)
    first_movie = response_array[0]
    expect(first_movie.id).to be_an(Integer)
    expect(first_movie.title).to be_a(String)
    expect(first_movie.vote_average).to be_a(Float)
  end

  it 'calls the movie api with a search request' do
    response_array = described_class.search_movies('Lord of the rings')

    expect(response_array).to be_a(Array)
    first_movie = response_array[0]
    expect(first_movie.id).to be_an(Integer)
    expect(first_movie.title).to be_a(String)
    expect(first_movie.vote_average).to be_a(Float)
  end

  it 'calls the movie api and returns a requested movie' do
    response = described_class.get_one_movie(120)

    expect(response).to be_a(Hash)

    expect(response[:id]).to be_an(Integer)
    expect(response[:title]).to be_a(String)
    expect(response[:runtime]).to be_an(Integer)
  end
end
