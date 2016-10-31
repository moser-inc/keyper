# frozen_string_literal: true
module Keyper::ApiKeyAuthentication
  extend ActiveSupport::Concern

  API_KEY = 'Api-Key'
  API_SECRET = 'Api-Secret'

  # Override the default current_user functionality
  #
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = if passed_api_keys?
                      authenticate_with_api_keys
                    elsif current_user_session && current_user_session.record
                      current_user_session.record
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
    key = Keyper::ApiKey.find_by(api_key: request.headers[API_KEY])
    unless key && key.authenticate(request.headers[API_SECRET])
      raise Keyper::ApiKeyError, I18n.t(:api_key, scope: [:keyper, :errors])
    end
    if key.should_update_attributes?
      key.update(
        last_used_at: Time.zone.now,
        last_used_ip: request.remote_ip,
        last_used_ua: request.user_agent
      )
    end
    key.user
  end
end
