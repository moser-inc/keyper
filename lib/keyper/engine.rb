require 'bcrypt'

module Keyper
  class Engine < ::Rails::Engine
    engine_name 'keyper'
    # isolate_namespace Keyper
    # config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.assets false
      g.helper true
    end

    initializer 'keyper.filter_parameters' do
      Rails.application.config.filter_parameters += [:api_secret]
    end

    initializer 'keyper.models' do |_config|
      ActiveSupport.on_load(:active_record) do
        user_class = Object.const_get(Keyper.user_class_name)
        user_class.send :include, Keyper::HasApiKeys
      end
    end
  end
end
