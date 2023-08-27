require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "send_reset_password_email" do
    let(:user) { FactoryBot.create(:user) }

    before do
      @mail = UserMailer.send_reset_password_email(user)
    end

    it "should sends the email to the user" do
      expect(@mail.to).to eq([user.email])
    end

    it "should have the correct subject" do
      expect(@mail.subject).to eq("Reset Your Password")
    end

    it "should renders the body with user's name and token" do
      expect(@mail.body.encoded).to match("Reset Your Password")
      expect(@mail.body.encoded).to match(user.full_name)  # mail should have user full name
    end
  end
end
