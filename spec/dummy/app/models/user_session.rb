class UserSession
  attr_reader :record
  alias_method :user, :record

  def initialize(user_id)
    @record = User.find_by(id: user_id)
  end
end
