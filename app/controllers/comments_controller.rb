class CommentsController < ApplicationController
  before_action :check_login, only: [:create]
  before_action :check_authorization, only: [:destroy]

  def create
    @comment = Comment.create(text: create_params[:comment], user_id: current_user.id, message_id: create_params[:message_id])
    respond_to do |format|
      format.js
    end
  end

  def destroy
    message_id = Comment.find(params[:id]).message.id
    Comment.find(params[:id]).destroy
    @message = Message.find(message_id)
    respond_to do |format|
      format.js
    end
  end

  private
  def create_params
    params.require(:new_comment).permit(:comment, :message_id)
  end

  def check_login
    if signed_in?
      if current_user.role != "user"
        redirect_to messages_path
      end
    else
      redirect_to new_session_path
    end
  end

  def check_authorization
    if signed_in?   
      if Comment.find(params[:id]).user.id != current_user.id
        redirect_to message_path(Comment.find(params[:id]).message.id)
      end
    else
      redirect_to new_session_path
    end
  end
end