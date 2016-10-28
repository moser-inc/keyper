class TbApi::ApiKeysController < Spud::ApplicationController
  include TbApi::ApiKeyAuthentication
  before_action :require_user, except: [:create]
  skip_before_action :verify_authenticity_token
  respond_to :json

  def index
    @api_keys = TbApiKey.where(spud_user: current_user).map do |api_key|
      {
        api_key: api_key.api_key,
        last_used_at: api_key.last_used_at
      }
    end
    render json: @api_keys
  end

  def create
    user_session = SpudUserSession.new(user_session_params)
    if user_session.valid?
      @api_key = TbApiKey.create(spud_user: user_session.attempted_record)
      render json: {
        api_key: @api_key.api_key,
        api_secret: @api_key.password
      }
    else
      respond_with user_session
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
    params.require(:user_session).permit(:login, :password)
  end
end
