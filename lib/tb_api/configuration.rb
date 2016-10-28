module TbApi
  include ActiveSupport::Configurable
  config_accessor :user_class_name,
    :invalidate_keys_on_password_change, :attribute_refresh_interval

  # The class name of your User model
  self.user_class_name = 'User'

  # If true, api keys will be destroyed any time the user changes their password
  self.invalidate_keys_on_password_change = true

  # How often should we update the api key tracking attributes
  self.attribute_refresh_interval = 1.minute
end
