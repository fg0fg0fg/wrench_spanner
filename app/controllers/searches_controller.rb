class SearchesController < ApplicationController
  before_action :login_check

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'user'
      @records = User.search_for(@content, @method)
    else
      @records = Post.search_for(@content, @method)
    end
  end

  private

  def login_check
    unless user_signed_in? || admin_signed_in?
      redirect_to root_path
    end
  end
end
