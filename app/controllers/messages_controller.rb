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

  private
  def create_params
    params.require(:new_message).permit(:message, :upload, :category)
  end
end
