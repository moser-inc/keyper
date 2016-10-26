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
    it 'creates a new API key' do
      user = FactoryGirl.create(:spud_user,
        login: 'user',
        password: 'password'
      )
      expect do
        post :create, params: { login: 'user', password: 'password' }
      end.to change(TbApiKey.where(spud_user: user), :count).by(1)
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

end
