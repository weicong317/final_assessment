class MessagesController < ApplicationController
  include ApplicationHelper

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
    @message = Message.find(params[:id].to_i)
  end

  def search
    @message = Message.find(search_params[:search])
    
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
end