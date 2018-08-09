class UsersController < ApplicationController
  include ApplicationHelper

  def new
  end
  
  def create
    user = User.new(create_params)
    if user.save
      sign_in(user)
      redirect_to root_path
    else
      redirect_to user_index_path
    end
  end

  private
  def create_params
    params.require(:sign_up).permit(:email, :password, :password_confirmation)
  end
end
