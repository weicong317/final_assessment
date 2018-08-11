class MessagesController < ApplicationController
  include ApplicationHelper

  def index
    @messages = Message.all.reverse_order.paginate(:page => params[:page], :per_page => 20).order(:created_at)
  end

  def new
  end

  def create
    message = Message.create(message: create_params[:message], user_id: current_user.id, upload: create_params[:upload])
    redirect_to messages_path
  end

  def show
    @message = Message.find(params[:id].to_i)
    
    respond_to do |format|
      format.html
      format.json {render json:@message}
    end
  end

  private
  def create_params
    params.require(:new_message).permit(:message, :upload)
  end
end
