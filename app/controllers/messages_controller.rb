class MessagesController < ApplicationController
  include ApplicationHelper

  def index
    @messages = Message.all.order(:created_at).reverse_order
  end

  def new
  end

  def create
    message = Message.create(message: create_params[:message], user_id: current_user.id)
    redirect_to messages_path
  end

  private
  def create_params
    params.require(:new_message).permit(:message)
  end
end
