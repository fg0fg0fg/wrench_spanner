# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :reject_user, only: [:create]

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  def after_sign_out_path_for(resource)
    about_path
  end

  def prohibit_multiple_login
    redirect_to root_path
  end

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "ゲストとしてログインしました"
  end

  def reject_user
    @user = User.find_by(email: params[:user][:email])
    # if @user
    #   # if @user.valid_password?(params[:user][:password]) && (@user.active_for_authentication? == false)
    #   #   flash[:notice] = "退会済みです。再度ご登録をしてご利用ください"
    #   # else
    #   #   flash[:notice] = "入力内容をご確認ください"
    #   # end
    # else
    #   flash[:notice] = "該当ユーザーが見つかりません"
    # end
    unless @user && @user.valid_password?(params[:user][:password])
      flash[:notice] = "メールアドレスまたはパスワードが違います。"
    end
  end
end
