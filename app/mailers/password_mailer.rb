class PasswordMailer < ActionMailer::Base
  # default_url_options[:host] = "localhost:3000"


  # default_url_options[:host] = SystemParam.get_key_value(9,"WEB_SERVER_NAME","Host Name of Server")
  # default from: "do_not_reply@ATTOP.com"

  # def password_reset(user)
  #     send_email(user)
  # end

  # def password_create(user)
  #    send_email(user)
  # end


  # private
  #   def send_email(arg_user)
  #       @user = arg_user
  #       to_user_email = arg_user.email
  #       mail(to: "#{to_user_email}", subject: 'Password Reset Instructions')
  #   end
end
