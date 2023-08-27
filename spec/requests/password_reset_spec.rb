require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "POST /send_reset_password_email" do
    it "sends a reset password email" do
      post "/password_resets/send_reset_password_email", params: { email: user.email }

      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("A verification email has been sent to you.")
      expect(response).to have_http_status(:ok)
    end

    it "does not send an email with invalid email" do
      post "/password_resets/send_reset_password_email", params: { email: "" }

      json_response = JSON.parse(response.body)
      expect(json_response.dig("errors", "base")).to be_an_instance_of(Array)
      expect(json_response.dig("errors", "base")).to eq(["This email is not registered with us."])
    end
  end

  describe "GET /reset_password" do
    context "when valid token is provided" do
      it "renders the reset_password template" do
        get "/password_resets/#{user.id}/reset_password", params: { token: user.generate_reset_token }
        expect(response).to render_template(:reset_password)
      end
    end

    context "when invalid token or user ID is not provided" do
      it "returns an error with invalid token" do
        get "/password_resets/#{user.id}/reset_password", params: { token: '' }

        json_response = JSON.parse(response.body)
        expect(json_response.dig("errors", "base")).to be_an_instance_of(Array)
        expect(json_response.dig("errors", "base")).to eq(["Invalid token...."])
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error with user not found" do
        get "/password_resets/100001/reset_password", params: { token: '' }

        json_response = JSON.parse(response.body)
        expect(json_response.dig("errors", "base")).to be_an_instance_of(Array)
        expect(json_response.dig("errors", "base")).to eq(["Record not found Couldn't find User with 'id'=100001"])  
        expect(response).to have_http_status(:not_found)
      end
    end
  end
  
  describe "POST /update_password" do
    it "returns an error with user not found" do
      post "/password_resets/100001/update_password", params: { password: 'new_password' }

      json_response = JSON.parse(response.body)
      expect(json_response.dig("errors", "base")).to be_an_instance_of(Array)
      expect(json_response.dig("errors", "base")).to eq(["Record not found Couldn't find User with 'id'=100001"])  
    end

    it "updates the password" do
      post "/password_resets/#{user.id}/update_password", params: { password: 'new_password' }
    
      user.reload
      expect(response.body).to eq('Password reset successful!')
      expect(user.authenticate('new_password')).to be_truthy
    end    
  end
end