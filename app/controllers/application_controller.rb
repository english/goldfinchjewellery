class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_expires_in

  private

  def set_expires_in
    expires_in 10.minutes, public: true
  end
end
