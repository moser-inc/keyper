module Keyper
  module Authentication
    class HasSecurePassword < Base
      def authenticate_user
        @user.authenticate(@password)
      end
    end
  end
end
