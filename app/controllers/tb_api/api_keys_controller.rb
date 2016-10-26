class TbApi::ApiKeysController < Spud::ApplicationController
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
    session = SpudUserSession.create(user_session_params)
    if session.valid?
      @api_key = TbApiKey.create(spud_user: session.spud_user)
      render json: {
        api_key: @api_key.api_key,
        api_secret: @api_key.password
      }
    else
      respond_with session
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

  private

  def user_session_params
    params.permit(:login, :password)
  end
end
