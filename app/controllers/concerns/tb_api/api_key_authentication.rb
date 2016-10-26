# frozen_string_literal: true
module TbApi::ApiKeyAuthentication
  extend ActiveSupport::Concern

  API_KEY = 'Api-Key'
  API_SECRET = 'Api-Secret'

  # Override the default current_user functionality
  #
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = if current_user_session
                      current_user_session.spud_user
                    elsif passed_api_keys?
                      authenticate_with_api_keys
                    end
  end

  private

  # True if the api key headers are present
  #
  def passed_api_keys?
    request.headers.key?(API_KEY) && request.headers.key?(API_SECRET)
  end

  # Check the validity of the keys
  #
  def authenticate_with_api_keys
    key = TbApiKey.find_by(api_key: request.headers[API_KEY])
    unless key && key.authenticate(request.headers[API_SECRET])
      raise TbApi::ApiKeyError
    end
    key.spud_user
  end
end
