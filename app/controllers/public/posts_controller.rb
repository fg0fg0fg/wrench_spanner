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
    tags = params[:post][:name].split(',')
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
      @posts = @genre.posts
    elsif params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts
    else
      @posts = Post.all
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = Comment.new
    @genres = Genre.all
    @post_tags = @post.tags
  end

  def edit
    @post = Post.find(params[:id])
    @tags = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tags = params[:name].split(',')
    if @post.update(post_params)
      @post.save_tags(tags)
      @post.tags.where.not(id: @post.tag_ids).destroy_all
      redirect_to post_path(@post), notice: "レビューを更新しました"
    else
      render 'edit'
    end
  end

  # def update
  #   # 1. カンマ区切りの文字列を配列にする
  #   tag_names = params[:tag_name].split(",")
  #   # 2. タグ名の配列をタグの配列にする
  #   tags = tag_names.map { |tag_name| Tag.find_or_create_by(name: tag_name) }
  #   # 3. タグのバリデーションを行い、バリデーションエラーがあればPostのエラーに加える
  #   tags.each do |tag|
  #     if tag.invalid?
  #       @tag_name = params[:tag_name]
  #       @post.errors.add(:tags, tag.errors.full_messages.join("\n"))
  #       return render :edit, status: :unprocessable_entity
  #     end
  #   end

  #   if @post.update(post_params) && @post.update!(tags: tags)
  #     redirect_to @post, notice: "Post was successfully updated.", status: :see_other
  #   else
  #     @tag_name = params[:tag_name]
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user), notice: "レビューを削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :genre_id, :star)
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
