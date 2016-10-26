require 'rails_helper'

RSpec.describe SpudUser, type: :model do

  describe '#invalidate_api_keys' do
    it 'should destroy all related keys' do
      user = FactoryGirl.create(:spud_user)
      count = 3
      count.times { FactoryGirl.create(:tb_api_key, spud_user: user) }
      expect do
        user.update(password: 'new-password', password_confirmation: 'new-password')
      end.to change(TbApiKey, :count).by(-count)
    end
  end
end
