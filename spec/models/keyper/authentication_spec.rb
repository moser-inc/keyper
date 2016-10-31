require 'rails_helper'

RSpec.describe Keyper::Authentication, type: :model do

  let(:user) do
    create(:user, username: 'user', password: 'password')
  end

  describe 'validations' do
    it 'should require a username and password' do
      auth = Keyper::Authentication.new()
      expect(auth).to be_invalid
    end

    it 'should require the correct username' do
      auth = Keyper::Authentication.new(
        username: 'x',
        password: 'x'
      )
      expect(auth).to be_invalid
    end

    it 'should require the correct password' do
      auth = Keyper::Authentication.new(
        username: user.username,
        password: 'x'
      )
      expect(auth).to be_invalid
    end

    it 'should be valid' do
      auth = Keyper::Authentication.new(
        username: user.username,
        password: user.password
      )
      expect(auth).to be_valid
    end
  end
end
