class FollowerController < ApplicationController
  before_action :logged_in_user, only: :show
  def show
    @title = t "follower"
    @user = current_user
    @pagy, @users = pagy @user.followers, items: Settings.page_item
    render "users/show_follow"
  end
end
