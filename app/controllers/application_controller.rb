class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def logged_in?
    session[:user_id]
  end
  helper_method :logged_in?

  def authenticate
    redirect_to new_session_path unless logged_in?
  end
end
