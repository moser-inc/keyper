class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_user
    unless current_user
      head :unauthorized
      return false
    end
  end

  def current_user_session
    UserSession.new(session[:user_id]) if session[:user_id]
  end

  def current_user
    return @_current_user if defined?(@_current_user)
    if session[:user_id]
      @_current_user = User.find_by(id: session[:user_id])
      @_current_user
    end
  end
end
