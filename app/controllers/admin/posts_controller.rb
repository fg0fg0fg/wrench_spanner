class Admin::PostsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_admin!

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
    @posts = sort_posts(all_posts).page(params[:page]).per(20)
    @all_posts = all_posts.count
    @sort = {genre_id: params[:genre_id],tag_id: params[:tag_id]}
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

