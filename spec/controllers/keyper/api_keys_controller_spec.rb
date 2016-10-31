require 'rails_helper'

RSpec.describe Keyper::ApiKeysController, type: :controller do
  include Keyper::TestHelper
  routes { Keyper::Engine.routes }

  describe 'GET #index' do
    it 'returns http success' do
      activate_session
      get :index, params: { format: :json }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    before :each do
      @user = create(:user,
        username: 'user',
        password: 'password'
      )
    end
    it 'creates a new API key' do
      expect do
        post :create, params: { user_session: { username: 'user', password: 'password' } }
      end.to change(Keyper::ApiKey.where(user: @user), :count).by(1)
    end
    it 'returns authentication errors' do
      post :create, params: { user_session: { username: 'wrong', password: 'nope' }, format: :json }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'does not maintain a session' do
      post :create, params: { user_session: { username: 'user', password: 'password' } }
      expect(session['spud_user_credentials']).to be_nil
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the key' do
      activate_session()
      api_key = Keyper::ApiKey.create(user: current_user)
      expect do
        delete :destroy, params: { id: api_key.api_key }
      end.to change(Keyper::ApiKey, :count).by(-1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #check' do
    it 'checks the api keys and returns 200' do
      activate_session
      api_key = create(:api_key)
      post :check, params: { api_key: {
        key: api_key.api_key,
        secret: api_key.password
      } }
      expect(response).to have_http_status(:success)
    end
    it 'returns unauthorized' do
      post :check, params: { api_key: {
        key: '-',
        secret: '-'
      } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

end
