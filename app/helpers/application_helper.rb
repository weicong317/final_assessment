module ApplicationHelper
  def current_user
		if session[:user_id]
			@current_user ||= User.find_by_id(session[:user_id])
		end
  end
  
  def signed_in?
		!current_user.nil?
	end

	def sign_in(user)
		session[:user_id] = user.id
	end

	def sign_out
		session[:user_id] = nil
	end
end
