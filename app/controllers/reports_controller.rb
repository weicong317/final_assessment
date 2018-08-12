class ReportsController < ApplicationController
  before_action :check_login, only: [:create]
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
  def check_login
    if signed_in?
      if current_user.role != "user"
        redirect_to messages_path
      elsif current_user.id === Message.find(params[:message_id]).user.id
        redirect_to message_path(params[:message_id])
      end
    else
      redirect_to new_session_path
    end
  end

  def check_authorization
    if signed_in?   
      if Report.find(params[:id]).user.id != current_user.id
        redirect_to message_path(params[:message_id])
      end
    else
      redirect_to new_session_path
    end
  end
end
