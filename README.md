# TbApi

This engine adds basic API functionality to a [twice baked](https://bitbucket.org/moser-inc/tb_core) rails application. It enables mobile apps to login to your web service, request a set of API credentials, and then authenticate subsequent requests with key and secret headers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tb_api'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install tb_api
```

## Usage

Mount the engine in our application's `routes.rb` file. This will determine the base path for API login.

```ruby
Rails.application.routes.draw do
  mount TbApi::Engine => "/api"
end
```

API key authentication is not enabled globally. Instead, you should include the `TbApi::ApiKeyAuthentication` module selectively in any controllers you wish to expose.

```ruby
class ProtectedStuffController < ApplicationController
  include TbApi::ApiKeyAuthentication
  before_action :require_user
end
```

You can then optionally configure the engine, or leave it at the [default settings](lib/tb_api/configuration.rb).

```ruby
TbApi.configure do |config|
  config.invalidate_keys_on_password_change = true
end
```

## Authentication

Your mobile application should first attempt to create an API key. Make a POST request to the `/api/api_keys` endpoint, passing `:login` and `:password` parameters.

```
curl -X POST -F 'login=username' -F 'password=password' http://localhost:3000/api/api_keys
```

Sample response:

```json
{
  "api_key":"06e374a582721189a58192413190600a",
  "api_secret":"6240aa5521b44041d6a6874bf1001852"
}
```

Store those values securely in your application. You can then make authenticated requests by passing those values as `Api-Key` and `Api-Secret` headers, respectively.

```
curl --header "Api-Key: 06e374a582721189a58192413190600a" --header "Api-Secret: 6240aa5521b44041d6a6874bf1001852"  http://localhost:3000/protected_stuff
```

When your user logs out, it is generally a good idea to delete the associated API key. You can do that by making a DELETE request. Pass the key and secret headers as you normally would, then specify which key you wish to delete in the restful url parameter.

```
curl -X DELETE \
  --header "Api-Key: 06e374a582721189a58192413190600a" \
  --header "Api-Secret: 6240aa5521b44041d6a6874bf1001852"  \
  http://localhost:3000/api/api_keys/06e374a582721189a58192413190600a
```
