class TbApiKey < ApplicationRecord
  has_secure_password
  belongs_to :spud_user

  before_validation :generate_api_key_and_secret, only: :create
  validates :api_key, :spud_user, presence: true

  private

  def generate_api_key_and_secret
    self.api_key = loop do
      key = SecureRandom.hex(16)
      break key unless TbApiKey.exists?(api_key: key)
    end
    self.password = SecureRandom.hex(16)
  end
end
