class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genres = Genre.all
    if params[:genre_id]
      @genre = Genre.find(params[:genre_id])
      @posts = @genre.posts
    else
      @posts = Post.all
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new
    @genres = Genre.all
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: "レビューを削除しました"
  end
end

