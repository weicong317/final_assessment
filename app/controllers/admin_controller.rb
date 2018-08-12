class AdminController < ApplicationController
  before_action :check_role

  def dashboard
    @messages_request_delete = Message.where.not(delete_request: nil)
    @messages_request_delete = Message.where.not(delete_request: '<i class="fas fa-exclamation-circle"></i>')

    @reported_messages = Message.joins(:reports).select('messages.*, count(reports)').having('count(reports) > 10').group('messages.id')
  end
  
  private
  def check_role
    if signed_in? 
      if current_user.role != "admin"
        redirect_to messages_path
      end
    else
      redirect_to new_session_path
    end
  end
end
