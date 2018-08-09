class SessionsController < ApplicationController
  include ApplicationHelper

  def new  
  end

  def create
    @user = User.find_by(email: create_params[:email])
    if @user && @user.authenticate(create_params[:password])
      sign_in(@user)
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def destroy
    sign_out()
    redirect_to root_path
  end

  private
  def create_params
    params.require(:sign_in).permit(:email, :password)
  end
end
