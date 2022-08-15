class UsersController < ApplicationController
  before_action :find_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  before_action :logged_in_user, only: %i(index edit update destroy following followers)
  def index
    @pagy, @users = pagy(
      User.all,
      page: params[:page],
      items: Settings.paginate.limit
    )
  end

  def show
    @user = User.find_by id: params[:id]
    @pagy, @microposts = pagy @user.micropost.newest,
                                page: params[:page],
                                items: Settings.paginate.limit
    return if @user

    flash[:error] = t ".not_found"
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controllers.users_controller.mail"
      redirect_to @user
    else
      flash[:error] = t "controllers.users_controller.error"
      render "new"
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = t "controllers.users_controller.update_success"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t "controllers.users_controller.delete_user"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def find_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:error] = t(".user_not_exist")
    redirect_to not_found
  end
end
