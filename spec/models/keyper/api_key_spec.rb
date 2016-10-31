require 'rails_helper'

RSpec.describe Keyper::ApiKey, type: :model do

  it 'has a valid factory' do
    expect(create(:api_key)).to be_valid
  end

  describe '#should_update_attributes?' do
    it 'returns true if last_used_at is nil' do
      api_key = build(:api_key, last_used_at: nil)
      expect(api_key.should_update_attributes?).to eq(true)
    end
    it 'returns true if last_used_at is in the past' do
      api_key = build(:api_key, last_used_at: 24.hours.ago)
      expect(api_key.should_update_attributes?).to eq(true)
    end
    it 'returns false' do
      api_key = build(:api_key, last_used_at: Time.zone.now)
      expect(api_key.should_update_attributes?).to eq(false)
    end
  end

  describe '#generate_api_key_and_secret' do
    it 'generates a key' do
      key = Keyper::ApiKey.new
      key.send(:generate_api_key_and_secret)
      expect(key.api_key).to be_a(String)
    end

    it 'generates a password' do
      key = Keyper::ApiKey.new
      key.send(:generate_api_key_and_secret)
      expect(key.password).to be_a(String)
    end
  end
end
