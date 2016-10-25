$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tb_api_keys/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tb_api_keys"
  s.version     = TbApiKeys::VERSION
  s.authors     = ["Greg Woods"]
  s.email       = ["greg.woods@moserit.com"]
  s.homepage    = "https://bitbucket.org/moser-inc/tb_api_keys"
  s.summary     = "Add API keys to a twice baked application"
  s.description = "Add API keys to a twice baked application"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"

  s.add_development_dependency "sqlite3"
end
