class AdminController < ApplicationController
  # every action in this controller neew check their role before continue
  before_action :check_role

  # admin dashboard
  def dashboard
    # find all message which requested delete and disapproved for delete request
    @messages_request_delete = Message.where.not(delete_request: nil)
    @messages_request_delete = Message.where.not(delete_request: '<i class="fas fa-exclamation-circle"></i>')

    # find all message which having more than 10 report from user
    @reported_messages = Message.joins(:reports).select('messages.*, count(reports)').having('count(reports) > 10').group('messages.id')
  end
  
  private
  # user need to sign in and is an admin to visit to visit this dashboard
  def check_role
    if signed_in? 
      # if not admin, redirect to message index
      if current_user.role != "admin"
        redirect_to messages_path
      end
    # if not sign in, redirect to sign in form
    else
      redirect_to new_session_path
    end
  end
end