class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "create_password_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("cant_be_empty")
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash.now[:success] = t("reset_success")
      redirect_to @user
    else
      flash.now[:danger] = t("reset_failed")
      render :edit
    end
  end

  private
  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t "activated_fail"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash.now[:danger] = t "reset_expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
