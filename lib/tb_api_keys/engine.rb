require 'tb_core'

module TbApiKeys
  class Engine < ::Rails::Engine
    isolate_namespace TbApiKeys

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper true
    end
  end
end
