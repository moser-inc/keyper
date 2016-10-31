require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  include Keyper::TestHelper
  KEY = Keyper::ApiKeyAuthentication::API_KEY
  SECRET = Keyper::ApiKeyAuthentication::API_SECRET

  controller do
    include Keyper::ApiKeyAuthentication
  end

  before :each do
    @api_key = create(:api_key)
    controller.reset_session
  end

  describe '#current_user' do
    it 'falls back to normal session management' do
      activate_session()
      expect(controller.current_user).to be_a(User)
    end

    it 'returns an api key user' do
      request.headers[KEY] = @api_key.api_key
      request.headers[SECRET] = @api_key.password
      expect(controller.current_user).to be_a(User)
    end
  end

  describe '#passed_api_keys?' do
    it 'returns false' do
      expect(controller.send(:passed_api_keys?)).to eq(false)
    end

    it 'returns true' do
      request.headers[KEY] = 'some-key'
      request.headers[SECRET] = 'some-password'
      expect(controller.send(:passed_api_keys?)).to eq(true)
    end
  end

  describe '#authenticate_with_api_keys' do
    it 'raises an error when the key is not found' do
      request.headers[KEY] = 'nope'
      request.headers[SECRET] = 'wrong'
      expect do
        controller.send(:authenticate_with_api_keys)
      end.to raise_error(Keyper::ApiKeyError)
    end

    it 'raises an error when the secret is not valid' do
      request.headers[KEY] = @api_key.api_key
      request.headers[SECRET] = 'wrong'
      expect do
        controller.send(:authenticate_with_api_keys)
      end.to raise_error(Keyper::ApiKeyError)
    end

    it 'returns the user' do
      request.headers[KEY] = @api_key.api_key
      request.headers[SECRET] = @api_key.password
      result = controller.send(:authenticate_with_api_keys)
      expect(result).to be_a(User)
    end

    it 'updates the api key attributes' do
      request.headers[KEY] = @api_key.api_key
      request.headers[SECRET] = @api_key.password
      expect do
        controller.send(:authenticate_with_api_keys)
        @api_key.reload
      end.to change(@api_key, :last_used_at)
        .and change(@api_key, :last_used_ip)
        .and change(@api_key, :last_used_ua)
    end
  end
end
