class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.all, items: Settings.settings.page_item
  end

  def new
    @user = User.new
  end

  def show
    @pagy, @microposts = pagy @user.microposts,
                              items: Settings.settings.page_item
  end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_mail_activate
      flash[:info] = t "please_check_email"
      redirect_to root_path
    else
      flash.now[:danger] = t "sign_fail"
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t "deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::PROPERTIES
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to login_url
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error.user.not_found"
    redirect_to help_url
  end
end
