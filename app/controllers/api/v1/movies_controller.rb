class Api::V1::MoviesController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org")

    response = conn.get("/3/movie/top_rated", {api_key: Rails.application.credentials.moviedb[:key]})
    json = JSON.parse(response.body, symbolize_names: true)
    top_twenty = json[:results].first(20)
    formatted_json = top_twenty.map do |result|
      {
        id: result[:id],
        type: "movie",
        attributes: {
          title: result[:original_title],
          vote_average: result[:vote_average]
      }}
    end
    
    render json: {data: formatted_json}

  end
end