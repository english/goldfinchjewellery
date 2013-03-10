class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def logged_in?
    session[:user_id]
  end
  helper_method :logged_in?
end
