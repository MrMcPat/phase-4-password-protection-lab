class UsersController < ApplicationController
    before_action :authorize, only: [:show]
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def create
      user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end
  
    def show
      user = User.find(session[:user_id])
      render json: user
    end
  
    private
  
    def authorize
      return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    end
  
    def user_params
      params.permit(:username, :password, :password_confirmation)
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
end