# frozen_string_literal: true

class Movie
  attr_reader :id,
              :title,
              :vote_average

  def initialize(movie_json)
    @id = movie_json[:id]
    @title = movie_json[:original_title]
    @vote_average = movie_json[:vote_average]
  end
end
