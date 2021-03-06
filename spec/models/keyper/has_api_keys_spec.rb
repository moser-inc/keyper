require 'rails_helper'

RSpec.describe Keyper::HasApiKeys, type: :model do

  before :each do
    @user = FactoryBot.create(:user)
    @count = 3
    @count.times { create(:api_key, user: @user) }
  end

  describe 'has_many' do
    it 'should have many keys' do
      expect(@user.api_keys.count).to eq(@count)
    end

    context 'when the user is deleted' do
      it 'should delete associated keys' do
        expect do
          @user.destroy
        end.to change(Keyper::ApiKey, :count).by(-@count)
      end
    end
  end

  describe '#invalidate_api_keys' do
    context 'when the user changes their password' do
      it 'should delete associated keys' do
        expect do
          @user.update(password: 'new-password', password_confirmation: 'new-password')
        end.to change(Keyper::ApiKey, :count).by(-@count)
      end
    end
  end
end
