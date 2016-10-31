class UserSession
  attr_reader :user
  def initialize(user_id)
    @user = User.find_by(id: user_id)
  end
end
