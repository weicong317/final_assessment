class MessagesController < ApplicationController
  before_action :check_login, only: [:new, :create]
  before_action :check_role, only: [:destroy, :update]
  before_action :check_authorization, only: [:delete_request]

  def index
    @messages = Message.all.order(:created_at).reverse_order
  end

  def new
  end

  def create
    @message = Message.new(message: create_params[:message], user_id: current_user.id, upload: create_params[:upload], category: (create_params[:category].to_i - 1))
    if @message.save
      redirect_to @message
    else
      redirect_to messages_path
    end
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
    @message = Message.where(id: search_params[:search]) if search_params[:search].present?
    @message = Message.where(category: (search_params[:category].to_i - 1)) if search_params[:category].present?

    respond_to do |format|
      format.js
    end
  end

  def delete_request
    @message = Message.find(params[:id])
    @message.update(delete_request: delete_params[:reason])
    
    redirect_to @message
  end

  def old_to_new
    @messages = Message.all.order(:created_at)

    respond_to do |format|
      format.js { render :file => "/messages/order_by.js.erb" }
    end
  end

  def with_comment
    @messages = Message.joins(:comments).select('messages.*, count(comments) as comment_count').group('messages.id')
    byebug
    respond_to do |format|
      format.html
      format.js { render :file => "/messages/order_by.js.erb" }
    end
  end

  def with_image
    @messages = Message.where.not(upload: nil)

    respond_to do |format|
      format.js { render :file => "/messages/order_by.js.erb" }
    end
  end

  private
  def create_params
    params.require(:new_message).permit(:message, :upload, :category)
  end

  def search_params
    params.require(:searching).permit(:search, :category).reject{|_, v| v.blank?}
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