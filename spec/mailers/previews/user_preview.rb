# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
    def send_reset_password_email
        UserMailer.send_reset_password_email(User.first)
    end
end
