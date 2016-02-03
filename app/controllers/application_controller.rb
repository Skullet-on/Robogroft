require File.expand_path("../../config.rb", __FILE__)
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate
    if current_user
      true
    else
      redirect_to new_user_session_path
    end
  end

  def private
    if current_user
      true
    else
      redirect_to new_user_session_path
    end
  end

  def admin
  	if current_user
  		if current_user.role == "admin"
  			true
  		else
  			redirect_to new_user_session_path
  		end
  	end
  end

end
