[![Code Climate](https://codeclimate.com/github/moser-inc/keyper/badges/gpa.svg)](https://codeclimate.com/github/moser-inc/keyper)
[![Build Status](https://semaphoreci.com/api/v1/moser-it/keyper/branches/master/shields_badge.svg)](https://semaphoreci.com/moser-it/keyper)

# Keyper

This engine adds basic API functionality to a Ruby on Rails application. It enables mobile apps to login to your web service, request a set of API credentials, and then authenticate subsequent requests with key and secret headers.

## Compatibility

Keyper has been built with common Rails authentication practices in mind, and can work well with tools such as [has_secure_password](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password) or [Authlogic](https://github.com/binarylogic/authlogic).

Broadly speaking, Keyper assumes your application has `User` and `UserSession` models, as well as the following controller methods:

- `require_user`
- `current_user`
- `current_user_session`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keyper'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install keyper
```

## Usage

Mount the engine in our application's `routes.rb` file. This will determine the base path for API login.

```ruby
Rails.application.routes.draw do
  mount Keyper::Engine => "/api"
end
```

API key authentication is not enabled globally. Instead, you should include the `Keyper::ApiKeyAuthentication` module selectively in any controllers you wish to expose.

```ruby
class ProtectedStuffController < ApplicationController
  include Keyper::ApiKeyAuthentication
  before_action :require_user
end
```

You can then optionally configure the engine, or leave it at the [default settings](lib/keyper/configuration.rb).

```ruby
Keyper.configure do |config|
  config.invalidate_keys_on_password_change = true
  config.attribute_refresh_interval = 1.minute
end
```

## Authentication

Your mobile application should first attempt to create an API key. Make a POST request to the `/api/api_keys` endpoint, passing `:username` and `:password` parameters.

```
curl -X POST -F 'user_session[username]=username' -F 'user_session[password]=password' http://localhost:3000/api/api_keys
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

You can hit the `/api/api_keys/check` endpoint to quickly check the validity of your keys. A 200 response means your keys are good.

```
curl --header "Api-Key: 06e374a582721189a58192413190600a" --header "Api-Secret: 6240aa5521b44041d6a6874bf1001852"  http://localhost:3000/api/api_keys/check
```

When your user logs out, it is a good idea to delete the associated API key. You can do that by making a DELETE request. Pass the key and secret headers as you normally would, then specify which key you wish to delete in the restful url parameter.

```
curl -X DELETE \
  --header "Api-Key: 06e374a582721189a58192413190600a" \
  --header "Api-Secret: 6240aa5521b44041d6a6874bf1001852"  \
  http://localhost:3000/api/api_keys/06e374a582721189a58192413190600a
```
