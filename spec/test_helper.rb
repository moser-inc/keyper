module Keyper
  module TestHelper
    # def self.included(base)
    #   base.before do
    #     allow_any_instance_of(ApplicationController).to receive(:current_user) do
    #       current_user
    #     end
    #   end
    # end

    def activate_session
      @user = create(:user)
      controller.session[:user_id] = @user.id
      return @user
    end

    def current_user
      @user
    end
  end
end
