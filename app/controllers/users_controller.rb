class UsersController < ApplicationController
  include ApplicationHelper

  before_action :check_authorization, only: [:show]

  def new
  end
  
  def create
    user = User.new(create_params)
    if user.save
      sign_in(user)
      redirect_to user_path(current_user.id)
    else
      redirect_to user_index_path
    end
  end

  def show
  end

  private
  def create_params
    params.require(:sign_up).permit(:email, :password, :password_confirmation)
  end

  def check_authorization
    if signed_in?   
      if params.permit(:id)[:id].to_i != current_user.id
        redirect_to root_path
      end
    else
      redirect_to new_session_path
    end
  end
end