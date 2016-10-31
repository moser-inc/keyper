module Keyper
  include ActiveSupport::Configurable
  config_accessor :user_class_name, :user_finder_field,
    :invalidate_keys_on_password_change, :attribute_refresh_interval

  # The class name of your User model
  self.user_class_name = 'User'.freeze

  # What field should we use in the finder
  self.user_finder_field = :username

  # If true, api keys will be destroyed any time the user changes their password
  self.invalidate_keys_on_password_change = true

  # How often should we update the api key tracking attributes
  self.attribute_refresh_interval = 1.minute
end
