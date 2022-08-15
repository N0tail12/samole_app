class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      flash[:success] = t ".login_success"
      handle_login user
    else
      flash.now[:danger] = t ".login_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
  def handle_login user
    if user.activated
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash[:danger] = t ".not_actived"
      redirect_to root_path
    end
  end
end
