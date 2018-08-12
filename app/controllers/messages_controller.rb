class MessagesController < ApplicationController
  before_action :check_login, only: [:new, :create]
  before_action :check_role, only: [:destroy, :update]
  before_action :check_authorization, only: [:delete_request]

  def index
    @messages = Message.all.reverse_order.paginate(:page => params[:page], :per_page => 20).order(:created_at)
  end

  def new
  end

  def create
    Message.create(message: create_params[:message], user_id: current_user.id, upload: create_params[:upload], category: (create_params[:category].to_i - 1))
    redirect_to messages_path
  end

  def show
    @message = Message.find(params[:id])
    @reports = @message.reports
  end

  def destroy
    Message.find(params[:id]).destroy
    redirect_to admin_dashboard_path
  end

  def update
    Message.find(params[:id]).update(delete_request: '<i class="fas fa-exclamation-circle"></i>')
    redirect_to admin_dashboard_path
  end

  def search
    @message = Message.find(search_params[:search])
    
    redirect_to @message
  end

  def delete_request
    @message = Message.find(params[:id])
    @message.update(delete_request: delete_params[:reason])
    
    redirect_to @message
  end

  def old_to_new
    @messages = Message.all.paginate(:page => params[:page], :per_page => 20).order(:created_at)

    respond_to do |format|
      format.js { render :file => "/messages/order_by.js.erb" }
    end
  end

  def with_comment
    @messages = Message.joins(:comments).select('messages.*, count(comments) as comment_count').group('messages.id').order('comment_count desc') 

    respond_to do |format|
      format.js { render :file => "/messages/order_by.js.erb" }
    end
  end

  def with_image
    @messages = Message.where.not(upload: nil).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.js { render :file => "/messages/order_by.js.erb" }
    end
  end

  private
  def create_params
    params.require(:new_message).permit(:message, :upload, :category)
  end

  def search_params
    params.require(:post_number).permit(:search)
  end

  def delete_params
    params.require(:delete_message).permit(:reason)
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
      if Message.find(params[:id]).user.id != current_user.id
        redirect_to messages_path
      end
    else
      redirect_to new_session_path
    end
  end

  def check_role
    if signed_in?
      if current_user.role === "user"
        redirect_to messages_path
      end
    else
      redirect_to new_session_path
    end      
  end
end