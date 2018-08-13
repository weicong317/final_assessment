class ReportsController < ApplicationController
  # create action need to login before continue
  before_action :check_login, only: [:create]
  # destroy action need to be owner to continue
  before_action :check_authorization, only: [:destroy]
  
  def create
    Report.create(message_id: params[:message_id], user_id: current_user.id)

    redirect_to message_path(params[:message_id])
  end

  def destroy
    Report.find(params[:id]).destroy

    redirect_to message_path(params[:message_id])
  end

  private 
  # need to log in, not admin and message dont belong to current user
  def check_login
    if signed_in?
      # admin go to message index
      if current_user.role != "user"
        redirect_to messages_path
      # message belong to current user refresh the page
      elsif current_user.id === Message.find(params[:message_id]).user.id
        redirect_to message_path(params[:message_id])
      end
    # go to sign in form if not sign in
    else
      redirect_to new_session_path
    end
  end

  # need log in and owner
  def check_authorization
    if signed_in?   
      # not owner, refresh the page
      if Report.find(params[:id]).user.id != current_user.id
        redirect_to message_path(params[:message_id])
      end
    # not log in, go to sign in form
    else
      redirect_to new_session_path
    end
  end
end
