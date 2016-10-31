module Keyper
  module Adapters
    class Authlogic

      def authenticate_user(user, password)
        user.valid_password?(password)
      end

      def password_changed?(user)
        user.password_changed?
      end
    end
  end
end
