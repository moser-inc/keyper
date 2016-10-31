module TbApi::HasApiKeys
  extend ActiveSupport::Concern

  included do
    has_many :api_keys, class_name: 'TbApiKey', dependent: :destroy
    before_update :invalidate_api_keys
  end

  private

  def invalidate_api_keys
    api_keys.destroy_all if TbApi.invalidate_keys_on_password_change && password_digest_changed?
  end
end
