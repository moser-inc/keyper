class Keyper::ApiKeysController < ApplicationController
  include Keyper::ApiKeyAuthentication
  before_action :require_user, except: [:create, :check]
  skip_before_action :verify_authenticity_token

  respond_to :json if defined?(ActionController::Responder)

  def index
    @api_keys = Keyper::ApiKey.where(user: current_user).map do |api_key|
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
      @api_key = Keyper::ApiKey.create(user: authentication.user)
      render json: {
        api_key: @api_key.api_key,
        api_secret: @api_key.password
      }
    elsif defined?(ActionController::Responder)
      respond_with authentication
    else
      render json: {
        errors: authentication.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @api_key = Keyper::ApiKey.find_by!(
      api_key: params[:id],
      user: current_user
    )
    @api_key.destroy
    head :ok
  end

  def check
    key = Keyper::ApiKey.find_by(api_key: check_api_key_params[:api_key])
    if key.present? && key.authenticate(check_api_key_params[:api_secret])
      head :ok
    else
      head :unauthorized
    end
  end

  private

  def user_session_params
    params.require(:user_session).permit(:username, :password)
  end

  def check_api_key_params
    params.require(:api_key).permit(:api_key, :api_secret)
  end
end
