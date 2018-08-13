class UsersController < ApplicationController
  # show action need to sign in and owner only continue
  before_action :check_authorization, only: [:show]

  def new
  end
  
  def create
    user = User.new(create_params)

    # success direct sign in user
    if user.save
      # sign in helper method
      sign_in(user)
      
      # new user will bring to their profile page
      redirect_to user_path(current_user.id)
    # fail refresh page
    else
      redirect_to new_user_path
    end
  end

  # show all the messages by the user from newest to oldest
  def show
    @messages = Message.where(user_id: current_user.id).order(:created_at).reverse_order
  end
  
  private
  def create_params
    params.require(:sign_up).permit(:email, :password, :password_confirmation)
  end

  # need log in and be owner
  def check_authorization
    if signed_in?   
      # not owner, go to message index
      if params[:id].to_i != current_user.id
        redirect_to messages_path
      end
    # not log in, got to sign in form
    else
      redirect_to new_session_path
    end
  end
end