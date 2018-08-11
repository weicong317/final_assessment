class CommentsController < ApplicationController
  include ApplicationHelper

  def create
    @comment = Comment.create(text: create_params[:comment], user_id: current_user.id, message_id: create_params[:message_id])
    respond_to do |format|
      format.js
    end
  end

  private
  def create_params
    params.require(:new_comment).permit(:comment, :message_id)
  end
end