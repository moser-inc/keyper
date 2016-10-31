module Keyper
  class Authentication
    include ActiveModel::Model

    attr_accessor :user, :username, :password
    validates :username, :password, presence: true
    validate :username_and_password_are_correct

    def initialize(params)
      @username = params[:username]
      @password = params[:password]
    end

    def username_and_password_are_correct
      user_class = Object.const_get(TbApi.user_class_name)
      @user = user_class.find_by(
        TbApi.user_finder_field => @username
      )
      unless @user && user_authenticated?(@user, password)
        errors.add(:base, 'Username or password are incorrect')
        false
      end
    end

    def user_authenticated?(user, password)
      method_candidates = [
        :valid_password?, :authenticate
      ]
      method_candidates.each do |method|
        return true if user.respond_to?(method) && user.send(method, password)
      end
      return false
    end
  end
end
