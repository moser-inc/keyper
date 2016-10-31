module Keyper
  module Authentication
    class Base
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
        unless @user && authenticate_user(@user, @password)
          errors.add(:base, 'Username or password are incorrect')
          false
        end
      end

      # This method should check the user against the password
      #
      def authenticate_user(_, _)
        raise NotImplementedError
      end
    end
  end
end
