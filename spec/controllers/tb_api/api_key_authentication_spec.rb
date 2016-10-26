require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  KEY = TbApi::ApiKeyAuthentication::API_KEY
  SECRET = TbApi::ApiKeyAuthentication::API_SECRET

  controller do
    include TbApi::ApiKeyAuthentication
  end

  describe '#current_user' do
    it 'falls back to normal session management' do
      activate_session()
      expect(controller.current_user).to be_a(SpudUser)
    end

    it 'returns an api key user' do
      api_key = FactoryGirl.create(:tb_api_key)
      request.headers[KEY] = api_key.api_key
      request.headers[SECRET] = api_key.password
      expect(controller.current_user).to be_a(SpudUser)
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
      request.headers[TbApi::ApiKeyAuthentication::API_KEY] = 'nope'
      request.headers[TbApi::ApiKeyAuthentication::API_SECRET] = 'wrong'
      expect do
        controller.send(:authenticate_with_api_keys)
      end.to raise_error(TbApi::ApiKeyError)
    end

    it 'raises an error when the secret is not valid' do
      api_key = FactoryGirl.create(:tb_api_key)
      request.headers[TbApi::ApiKeyAuthentication::API_KEY] = api_key.api_key
      request.headers[TbApi::ApiKeyAuthentication::API_SECRET] = 'wrong'
      expect do
        controller.send(:authenticate_with_api_keys)
      end.to raise_error(TbApi::ApiKeyError)
    end

    it 'returns the user' do
      api_key = FactoryGirl.create(:tb_api_key)
      request.headers[TbApi::ApiKeyAuthentication::API_KEY] = api_key.api_key
      request.headers[TbApi::ApiKeyAuthentication::API_SECRET] = api_key.password
      result = controller.send(:authenticate_with_api_keys)
      expect(result).to be_a(SpudUser)
    end
  end
end
