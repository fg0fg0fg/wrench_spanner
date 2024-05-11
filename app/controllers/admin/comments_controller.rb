class Admin::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
  end
end
