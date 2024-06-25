class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :matching_login_user, only: [:edit, :update, :destroy]
  before_action :ensure_guest_user, only: [:edit]

  def index
    @users = User.all.page(params[:page]).per(12)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報を更新しました"
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to new_user_registration_path, notice: "ユーザー情報を削除しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :profile_image)
  end

  def matching_login_user
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
