class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :matching_login_user, only: [:edit, :update, :destroy]
  before_action :ensure_guest_user, only: [:new, :edit, :create, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: "レビューを投稿しました"
    else
      render 'new'
    end
  end

  def index
    @posts = Post.all
    @genres = Genre.all
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @genre = @post.genre
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "レビューを更新しました"
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user), notice: "レビューを削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :genre_id)
  end

  def ensure_guest_user
    if current_user.email == "guest@example.com"
      redirect_to user_path(current_user) , notice: "ゲストユーザーは閲覧のみです"
    end
  end

  def matching_login_user
    @post = Post.find(params[:id])
    @user = @post.user
    unless @user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end
end
