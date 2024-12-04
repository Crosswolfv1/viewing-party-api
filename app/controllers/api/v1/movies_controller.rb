class Api::V1::MoviesController < ApplicationController
  rescue_from ArgumentError, with: :invalid_parameters
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org")
    if !params.key?(:query)
      response = conn.get("/3/movie/top_rated", {api_key: Rails.application.credentials.moviedb[:key]})
      json = JSON.parse(response.body, symbolize_names: true)
      render json: {data: present_list(json)}
    else
      raise ArgumentError, "Query cannot be empty" unless params[:query].present?
      search = params[:query]
      response = conn.get("/3/search/movie", {query: search, api_key: Rails.application.credentials.moviedb[:key]})
      json = JSON.parse(response.body, symbolize_names: true)
      render json: {data: present_list(json)}
    end
  end

  private

  def present_list(json)
    top_twenty = json[:results].first(20)
    top_twenty.map do |result|
      {
        id: result[:id],
        type: "movie",
        attributes: {
          title: result[:original_title],
          vote_average: result[:vote_average]
      }}
    end
  end

  def invalid_parameters(exception)
    render json: ErrorSerializer.format_errors(exception, 400), status: :bad_request
  end
end