class SessionsController < ApplicationController
  def new  
  end

  # manual sign in
  def create
    @user = User.find_by(email: create_params[:email])

    # check db and the confirm password
    if @user && @user.authenticate(create_params[:password])
      # sign in user, is a helper method
      sign_in(@user)

      # different role, go to different path
      # role: user, bring to their profile
      if current_user.role === "user"
        redirect_to user_path(current_user.id)
      # else, bring to admin dashboard
      else
        redirect_to admin_dashboard_path
      end
    # sign in fail, refresh page
    else
      redirect_to new_session_path
    end
  end
  
  # sign in with google
  def create_with_omniauth
    # get info from google
    auth_hash = request.env['omniauth.auth']

    # check db if the user being authorize
    authorization = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])

    if authorization
      user = authorization.user
    # if not authorize, create new user, with method in user model
    else
      user = User.create_with_auth(auth_hash)
    end

    # sign in user with helper method
    sign_in(user)

    # different role, go to different path
    # role: user, bring to their profile
    if current_user.role === "user"
      redirect_to user_path(current_user.id)
    # else, bring to admin dashboard
    else
      redirect_to admin_dashboard_path
    end
  end
  
  def destroy
    # sign out helper method
    sign_out()

    redirect_to root_path
  end

  private
  def create_params
    params.require(:sign_in).permit(:email, :password)
  end
end
