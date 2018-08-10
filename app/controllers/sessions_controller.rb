class SessionsController < ApplicationController
  include ApplicationHelper

  def new  
  end

  def create
    @user = User.find_by(email: create_params[:email])
    if @user && @user.authenticate(create_params[:password])
      sign_in(@user)
      redirect_to user_path(current_user.id)
    else
      redirect_to root_path
    end
  end

  def destroy
    sign_out()
    redirect_to root_path
  end

  def create_with_omniauth
    auth_hash = request.env['omniauth.auth']

    authorization = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])

    if authorization
      user = authorization.user
    else
      user = User.create_with_auth(auth_hash)
    end

    sign_in(user)
    redirect_to user_path(current_user.id)
  end

  private
  def create_params
    params.require(:sign_in).permit(:email, :password)
  end
end
