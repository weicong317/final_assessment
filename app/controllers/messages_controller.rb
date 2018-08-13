class MessagesController < ApplicationController
  # create and new action need to login before continue
  before_action :check_login, only: [:new, :create]
  # destroy and update action need to be admin only can continue
  before_action :check_role, only: [:destroy, :update]
  # delete_request action need to be onwer only can continue
  before_action :check_authorization, only: [:delete_request]

  # show all message in db from newest to oldest
  def index
    @messages = Message.all.order(:created_at).reverse_order
  end

  def new
  end

  def create
    # category need to minus 1 to match the enum
    @message = Message.new(message: create_params[:message], user_id: current_user.id, upload: create_params[:upload], category: (create_params[:category].to_i - 1))

    # success go to the message show page
    if @message.save
      redirect_to @message
    # fail go message index
    else
      redirect_to messages_path
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  # only for admin
  def destroy
    Message.find(params[:id]).destroy

    # after destroy, refresh dashboard again
    redirect_to admin_dashboard_path
  end

  # only for admin
  def update
    # update the delete request if disapproved
    Message.find(params[:id]).update(delete_request: '<i class="fas fa-exclamation-circle"></i>')

    # after update, refresh dashboard again
    redirect_to admin_dashboard_path
  end

  # can search specific message or filter with message category in message index
  def search
    # use where to get specific message even only one to enable using each to loop and print
    @message = Message.where(id: search_params[:search]) if search_params[:search].present?

    # to get all message with same category
    @message = Message.where(category: (search_params[:category].to_i - 1)) if search_params[:category].present?

    # do not refresh whole page
    respond_to do |format|
      format.js
    end
  end

  # only owner can request
  def delete_request
    @message = Message.find(params[:id])

    # update the column with reason
    @message.update(delete_request: delete_params[:reason])
    
    # after request, refresh the page
    redirect_to @message
  end

  private
  def create_params
    params.require(:new_message).permit(:message, :upload, :category)
  end

  # only allow those with value
  def search_params
    params.require(:searching).permit(:search, :category).reject{|_, v| v.blank?}
  end

  def delete_params
    params.require(:delete_message).permit(:reason)
  end

  # need to log in and not admin
  def check_login
    if signed_in?
      # if admin, bring to message index
      if current_user.role != "user"
        redirect_to messages_path
      end
    # if not log in, bring to sign in form
    else
      redirect_to new_session_path
    end
  end

  # check sign in and ownership
  def check_authorization
    if signed_in?
      # if message owner is not current user, go to message index
      if Message.find(params[:id]).user.id != current_user.id
        redirect_to messages_path
      end
    # bring to sign in form if not log in
    else
      redirect_to new_session_path
    end
  end

  # need log in and admin
  def check_role
    if signed_in?
      # not admin, bring to message index
      if current_user.role === "user"
        redirect_to messages_path
      end
    # not log in, bring to sign in form
    else
      redirect_to new_session_path
    end      
  end
end