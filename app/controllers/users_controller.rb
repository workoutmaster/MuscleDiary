class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @muscles = current_user.muscles.includes([:part])
  end

  def follows
    user = User.find(params[:id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

  def edit
    @user = current_user
    @guest_user = User.guest
  end

  def update
    user = current_user
    if user.update(user_params)
      flash[:notice] = '登録情報を更新しました'
      redirect_to user_path(user)
    else
      render 'edit'
    end
  end

  def unsubscribe
    @user = current_user
    @guest_user = User.guest
  end

  def withdraw
    user = current_user
    user.update(is_deleted: true)
    reset_session
    flash[:notice] = 'ありがとうございました'
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :image)
  end
end
