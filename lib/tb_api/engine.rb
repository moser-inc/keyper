require 'tb_core'

module TbApi
  class Engine < ::Rails::Engine
    engine_name 'tb_api'
    # isolate_namespace TbApi
    # config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper true
    end

    # initializer 'tb_redirects.models' do |_config|
    #   ActiveSupport.on_load(:active_record) do
    #     SpudUser.send :include, TbApi::HasApiKeys
    #   end
    # end
  end
end
