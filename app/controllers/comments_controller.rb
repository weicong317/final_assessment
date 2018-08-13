class CommentsController < ApplicationController
  # create action need to login before continue
  before_action :check_login, only: [:create]
  # destroy action need to be onwer of the comment only can continue
  before_action :check_authorization, only: [:destroy]

  def create
    @comment = Comment.create(text: create_params[:comment], user_id: current_user.id, message_id: create_params[:message_id])
    
    # only respond in js since the comment is append directly after create
    respond_to do |format|
      format.js
    end
  end

  def destroy
    # get the message id before before destroy
    message_id = Comment.find(params[:id]).message.id

    # find the comment and destroy
    Comment.find(params[:id]).destroy

    # get the message with the id above
    @message = Message.find(message_id)

    # use the message to refresh the whole comment section
    respond_to do |format|
      format.js
    end
  end

  private
  def create_params
    params.require(:new_comment).permit(:comment, :message_id)
  end

  # user need to sign in and not admin to comment
  def check_login
    if signed_in?
      # if the current user is admin, redirect to message index if try to comment
      if current_user.role != "user"
        redirect_to messages_path
      end
    # redirect to sign in form if not sign in
    else
      redirect_to new_session_path
    end
  end

  # user need to sign in and owner to delete the comment
  def check_authorization
    if signed_in?   
      # if comment owner is not current user refresh the page
      if Comment.find(params[:id]).user.id != current_user.id
        redirect_to message_path(Comment.find(params[:id]).message.id)
      end
    # redirect to sign in form if not sign in
    else
      redirect_to new_session_path
    end
  end
end