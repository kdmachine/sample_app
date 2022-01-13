class FollowingController < ApplicationController
  before_action :logged_in_user, only: :show
  def show
    @title = t "following"
    @user = current_user
    @pagy, @users = pagy @user.following, items: Settings.page_item
    render "users/show_follow"
  end
end
