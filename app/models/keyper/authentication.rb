module Keyper
  class Authentication
    include ActiveModel::Model

    attr_accessor :user, :username, :password
    validates :username, :password, presence: true
    validate :username_and_password_are_correct

    def username_and_password_are_correct
      user_class = Object.const_get(Keyper.user_class_name)
      @user = user_class.find_by(
        Keyper.user_finder_field => @username
      )
      unless @user && user_authenticated?(@user, password)
        errors.add(:base, I18n.t(:login_failed, scope: [:keyper, :errors]))
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
