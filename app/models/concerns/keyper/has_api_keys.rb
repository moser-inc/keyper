module Keyper::HasApiKeys
  extend ActiveSupport::Concern

  included do
    has_many :api_keys, class_name: 'Keyper::ApiKey', dependent: :destroy
    before_update :invalidate_api_keys
  end

  private

  def invalidate_api_keys
    return unless Keyper.invalidate_keys_on_password_change
    method_candidates = [
      :password_digest_changed?, :password_changed?
    ]
    method_candidates.each do |method|
      if respond_to?(method) && send(method)
        api_keys.destroy_all
        break
      end
    end
  end
end
