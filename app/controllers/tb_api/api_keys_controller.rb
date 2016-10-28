module Keyper
  class Authentication
    include ActiveModel::Model

    attr_reader :user, :username, :password

    validates :username, :password, presence: true
    validate :username_and_password_are_correct

    def initialize(params)
      @username = params[:username]
      @password = params[:password]
    end

    def username_and_password_are_correct
      @user = authenticate_user
      unless user
        errors.add(:base, 'Username or password are incorrect')
        false
      end
    end

    def authenticate_user
      user = Object.const_get(TbApi.user_class_name).find_by(username: @username)
      return user if user.present? && user.authenticate(@password)
      return nil
    end
  end
end

class TbApi::ApiKeysController < ApplicationController
  include TbApi::ApiKeyAuthentication
  # before_action :require_user, except: [:create]
  skip_before_action :verify_authenticity_token
  # respond_to :json

  def index
    @api_keys = TbApiKey.where(user: current_user).map do |api_key|
      {
        api_key: api_key.api_key,
        last_used_at: api_key.last_used_at
      }
    end
    render json: @api_keys
  end

  def create
    authentication = Keyper::Authentication.new(user_session_params)
    if authentication.valid?
      @api_key = TbApiKey.create(user: authentication.user)
      render json: {
        api_key: @api_key.api_key,
        api_secret: @api_key.password
      }
    else
      # respond_with authentication
      render json: {
        errors: authentication.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @api_key = TbApiKey.find_by!(
      api_key: params[:id],
      spud_user: current_user
    )
    @api_key.destroy
    head :ok
  end

  def check
    raise Spud::UnauthorizedError unless passed_api_keys?
    head :ok
  end

  private

  def user_session_params
    params.require(:user_session).permit(:username, :password)
  end
end
