module ApplicationHelper
	# check is the user sign in and assign to variable if yes
  def current_user
		if session[:user_id]
			@current_user ||= User.find_by_id(session[:user_id])
		end
  end
	
	# check is the user sign in
  def signed_in?
		!current_user.nil?
	end

	# sign in the user and assign the session
	def sign_in(user)
		session[:user_id] = user.id
	end

	# delete session and sign out
	def sign_out
		session[:user_id] = nil
	end
end