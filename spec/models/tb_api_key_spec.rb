require 'rails_helper'

RSpec.describe TbApiKey, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:tb_api_key)).to be_valid
  end

  describe '#generate_api_key_and_secret' do
    it 'generates a key' do
      key = TbApiKey.new
      key.send(:generate_api_key_and_secret)
      expect(key.api_key).to be_a(String)
    end

    it 'generates a password' do
      key = TbApiKey.new
      key.send(:generate_api_key_and_secret)
      expect(key.password).to be_a(String)
    end
  end
end
