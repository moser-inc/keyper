module TbApi
  include ActiveSupport::Configurable
  config_accessor :invalidate_keys_on_password_change

  # If true, api keys will be destroyed any time the user changes their password
  self.invalidate_keys_on_password_change = true
end
