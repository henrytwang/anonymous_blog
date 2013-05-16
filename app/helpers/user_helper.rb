def current_user
  @user ||= User.where(id: session[:user_id]).first
end

def user_already_exists?(email)
  User.find_all_by_email(email).length > 0
end
