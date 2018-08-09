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

  def create_from_omniauth
    auth_hash = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)
  
    # if: previously already logged in with OAuth
    if authentication.user
      user = authentication.user
      authentication.update_token(auth_hash)
      @next = root_path
    # else: user logs in with OAuth for the first time
    else
      user = User.create_with_auth_and_hash(authentication, auth_hash)
      @next = root_path
    end
  
    sign_in(user)
    redirect_to @next
  end 

  private
  def create_params
    params.require(:sign_in).permit(:email, :password)
  end
end
