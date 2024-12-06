class Api::V1::MoviesController < ApplicationController
  rescue_from ArgumentError, with: :invalid_parameters
  def index
    if !params.key?(:query)
      json = MovieGateway.get_movies
      render json: MovieSerializer.format_movie(json)
    else
      validate_params(params)
      json = MovieGateway.search_movies(params[:query])
      render json: MovieSerializer.format_movie(json)
    end
  end

  private

  def validate_params(params)
    raise ArgumentError, "Query cannot be empty" unless params[:query].present?
  end
  
  def invalid_parameters(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception, 400)), status: :bad_request
  end
end