module Keyper
  module Authentication
    class Authlogic < Base
      def authenticate_user
        @user.valid_password?(@password)
      end
    end
  end
end
