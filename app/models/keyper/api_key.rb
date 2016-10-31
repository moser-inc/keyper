module Keyper
  class ApiKey < ApplicationRecord
    self.table_name = :keyper_api_keys
    has_secure_password
    belongs_to :user,
      class_name: Keyper.user_class_name

    before_validation :generate_api_key_and_secret, on: :create
    validates :api_key, :user, presence: true

    def should_update_attributes?
      return last_used_at.nil? || last_used_at < Keyper.attribute_refresh_interval.ago
    end

    private

    def generate_api_key_and_secret
      self.api_key = loop do
        key = SecureRandom.hex(16)
        break key unless Keyper::ApiKey.exists?(api_key: key)
      end
      self.password = SecureRandom.hex(16)
    end
  end
end
