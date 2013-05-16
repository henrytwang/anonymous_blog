require 'bcrypt'

class User < ActiveRecord::Base

  def self.authenticate(email, password)
    email_user_object = User.find_all_by_email(email)[0]
    if email_user_object.nil?
      nil
    elsif BCrypt::Password.new(email_user_object.password) == password
      email_user_object
    end
  end

end
