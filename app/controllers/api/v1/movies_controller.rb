# frozen_string_literal: true

module Api
  module V1
    class MoviesController < ApplicationController # rubocop:disable Style/Documentation
      rescue_from ArgumentError, with: :invalid_parameters
      def index
        if params.key?(:query)
          validate_params(params)
          json = MovieGateway.search_movies(params[:query])
        else
          json = MovieGateway.get_movies
        end
        render json: MovieSerializer.format_movie(json)
      end

      def show
        json = MovieGateway.get_one_movie(params[:id])
        render json: MovieSerializer.movie_details(json)
      end

      private

      def validate_params(params)
        raise ArgumentError, 'Query cannot be empty' if params[:query].blank?
      end

      def invalid_parameters(exception)
        render json: ErrorSerializer.format_error(ErrorMessage.new(exception, 400)), status: :bad_request
      end
    end
  end
end
