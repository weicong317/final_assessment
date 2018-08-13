class UsersController < ApplicationController
  before_action :check_authorization, only: [:show]

  def new
  end
  
  def create
    user = User.new(create_params)
    if user.save
      sign_in(user)
      redirect_to user_path(current_user.id)
    else
      redirect_to new_user_path
    end
  end

  def show
    @messages = Message.where(user_id: current_user.id).order(:created_at).reverse_order
  end
  
  private
  def create_params
    params.require(:sign_up).permit(:email, :password, :password_confirmation)
  end

  def check_authorization
    if signed_in?   
      if params[:id].to_i != current_user.id
        redirect_to messages_path
      end
    else
      redirect_to new_session_path
    end
  end
end