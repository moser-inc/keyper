require 'rails_helper'

RSpec.describe TbApi::ApiKeysController, type: :controller do
  routes { TbApi::Engine.routes }

  describe 'GET #index' do
    it 'returns http success' do
      activate_session()
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    before :each do
      @user = create(:spud_user,
        login: 'user',
        password: 'password'
      )
    end
    it 'creates a new API key' do
      expect do
        post :create, params: { user_session: { login: 'user', password: 'password' } }
      end.to change(TbApiKey.where(spud_user: @user), :count).by(1)
    end
    it 'returns authentication errors' do
      post :create, params: { user_session: { login: 'wrong', password: 'nope' }, format: :json }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'does not maintain a session' do
      post :create, params: { user_session: { login: 'user', password: 'password' } }
      expect(session['spud_user_credentials']).to be_nil
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the key' do
      activate_session()
      api_key = TbApiKey.create(spud_user: current_user)
      expect do
        delete :destroy, params: { id: api_key.api_key }
      end.to change(TbApiKey, :count).by(-1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #check' do
    it 'checks the api keys and returns 200' do
      api_key = create(:tb_api_key)
      request.headers[TbApi::ApiKeyAuthentication::API_KEY] = api_key.api_key
      request.headers[TbApi::ApiKeyAuthentication::API_SECRET] = api_key.password
      get :check, params: { format: :json }
      expect(response).to have_http_status(:success)
    end
    it 'returns unauthorized' do
      get :check, params: { format: :json }
      expect(response).to have_http_status(:unauthorized)
    end
  end

end
