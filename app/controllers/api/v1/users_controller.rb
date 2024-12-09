# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

      def index
        render json: UserSerializer.format_user_list(User.all)
      end

      def show
        raise ActiveRecord::RecordInvalid unless User.find_by(id: params[:id])

        render json: UserSerializer.user_details(params[:id])
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: UserSerializer.new(user), status: :created
        else
          render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)),
                 status: :bad_request
        end
      end

      private

      def user_params
        params.permit(:name, :username, :password, :password_confirmation)
      end

      def record_invalid(exception)
        render json: ErrorSerializer.format_error(ErrorMessage.new(exception, 400)), status: :bad_request
      end
    end
  end
end
