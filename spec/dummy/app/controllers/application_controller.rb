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
    if current_user_session
      @_current_user = current_user_session.user
      @_current_user
    end
  end
end
