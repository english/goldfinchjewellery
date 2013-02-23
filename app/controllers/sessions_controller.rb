class SessionsController < ApplicationController
  def new
    redirect_to root_path if session[:user_id]
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Signed in successfully'
    else
      flash.now.alert = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash.notice = 'Signed out successfully'
    redirect_to root_path
  end
end
