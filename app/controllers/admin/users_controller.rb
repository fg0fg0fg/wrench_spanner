class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only:[:show, :edit, :update, :destroy]

  def index
    @users = User.all.page(params[:page]).per(12)
  end

  def show
    @posts = @user.posts
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザー情報を更新しました"
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザー情報を削除しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
