$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'keyper/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'keyper'
  s.version     = Keyper::VERSION
  s.authors     = ['Greg Woods']
  s.email       = ['greg.woods@moserit.com']
  s.homepage    = 'https://github.com/moser-inc/keyper'
  s.summary     = 'Add API keys to a Ruby on Rails application'
  s.description = 'Add API keys to a Ruby on Rails application'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'bcrypt'
  s.add_dependency 'rails', '~> 5.0', '< 6'

  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'pg', '>= 0.15'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
end
