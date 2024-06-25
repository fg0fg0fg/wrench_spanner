class Public::PostsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, unless: :admin_signed_in?
  before_action :matching_login_user, only: [:edit, :update, :destroy]
  before_action :ensure_guest_user, only: [:new]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tags = params[:name].split(',')
    if @post.save
      @post.save_tags(tags)
      redirect_to post_path(@post), notice: "レビューを投稿しました"
    else
      render 'new'
    end
  end

  def index
    @tags = Tag.all
    @genres = Genre.all
    if params[:genre_id]
      @genre = Genre.find(params[:genre_id])
      all_posts = @genre.posts
    elsif params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      all_posts = @tag.posts
    else
      all_posts = Post.all
    end
    @posts = sort_posts(all_posts).page(params[:page]).per(12)
    @all_posts = all_posts.count
    @sort = {genre_id: params[:genre_id],tag_id: params[:tag_id]}
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new
    @genres = Genre.all
  end

  def edit
    @tags = @post.tags.pluck(:name).join(',')
  end

  def update
    tags = params[:name].split(',')
    if @post.update(post_params)
      @post.save_tags(tags)
      redirect_to post_path(@post), notice: "レビューを更新しました"
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to user_path(current_user), notice: "レビューを削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :genre_id, :star)
  end

  def ensure_guest_user
    if current_user.email == ENV['GUEST_USER_EMAIL']
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
