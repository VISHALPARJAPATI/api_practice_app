class UserMailer < ApplicationMailer
    def send_reset_password_email user
        @user = user
        @token = @user.generate_reset_token
        mail(to: @user.email, subject: 'Reset Your Password')
    end
end
