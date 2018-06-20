module Keyper::HasApiKeys
  extend ActiveSupport::Concern

  included do
    has_many :api_keys,
      class_name: 'Keyper::ApiKey',
      foreign_key: :user_id,
      dependent: :destroy,
      inverse_of: :user
    before_update :invalidate_api_keys
  end

  private

  def invalidate_api_keys
    return unless Keyper.invalidate_keys_on_password_change
    method_candidates = [
      :password_digest_changed?, :password_changed?
    ]
    method_candidates.each do |method|
      if respond_to?(method, true) && send(method)
        api_keys.destroy_all
        break
      end
    end
  end
end
