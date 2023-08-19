require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    context "when not authenticated" do
      before { get "/users" }

      it "returns Unauthorized" do 
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("error")
        expect(json_response.dig("error")).to eq("Unauthorized")
      end

      it "returns JSON content type" do 
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "when authenticated" do
      let(:user) { FactoryBot.create(:user) }
      let(:auth_headers) { { "Authorization" => "Bearer #{user.generate_jwt_token}" } }

      before do
        FactoryBot.create_list(:user, 3)
        get "/users", headers: auth_headers
      end

      it "returns all users" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("data")
        expect(json_response["data"]).to have_key("users")
        expect(json_response.dig("data", "users").count).to eq(4)
      end
    end
  end

  describe "POST /create" do
    let(:user_params) { FactoryBot.attributes_for(:user) }

    it "creates a user" do 
      post "/users", params: { user: user_params }

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("data")
      expect(json_response["data"]).to have_key("user")
      expect(json_response.dig("data", "user")).to be_present
      expect(response).to have_http_status(:ok)
    end

    it "does not create a user" do 
      user_params[:first_name] = nil
      post "/users", params: { user: user_params }

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("errors")
      
      errors = json_response["errors"]
      expect(errors).to include("first_name" => ["can't be blank"])
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /show" do
    let(:user) { FactoryBot.create(:user) }

    context "when not authenticated" do 
      before { get "/users/#{user.id}" }

      it "returns unauthorized" do 
        json_response = JSON.parse(response.body)
        expect(json_response.dig("error")).to eq("Unauthorized")
        expect(json_response).to have_key("error")
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
    context "when authenticated" do 
      let(:auth_headers) { { "Authorization" => "Bearer #{user.generate_jwt_token}" } }

      context "when user exists" do
        before { get "/users/#{user.id}", headers: auth_headers }

        it "returns user" do 
          json_response = JSON.parse(response.body)
          expect(json_response).to have_key("data")
          expect(json_response.dig("data")).to have_key("user")
          expect(json_response.dig("data", "user")).to be_present
        end
      end
  
      context "when user does not exists" do 
        before { get "/users/100001", headers: auth_headers }

        it "should return not found" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "PATCH /update" do
    let(:user) { FactoryBot.create(:user) }
    
    context "when not authenticated" do
  
      it "returns Unauthorized without params" do 
        patch "/users/#{user.id}", params: { user: FactoryBot.attributes_for(:user) }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("error")
        expect(json_response.dig("error")).to eq("Unauthorized")
      end

      it "returns Unauthorized with params" do 
        patch "/users/#{user.id}"

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("error")
        expect(json_response.dig("error")).to eq("Unauthorized")
      end
    end

    context "when authenticated" do
      let(:auth_headers) { { "Authorization" => "Bearer #{user.generate_jwt_token}" } }

      context "when user exists" do
        context "with valid user params" do
          let(:user_params) { { "first_name": "updated name" } }
  
          before do
            patch "/users/#{user.id}", headers: auth_headers, params: { user: user_params }
          end
  
          it "updates user" do
            json_response = JSON.parse(response.body)
            expect(json_response).to have_key("data")
            expect(json_response.dig("data")).to have_key("user")
            expect(json_response.dig("data", "user")).to be_present
            expect(json_response.dig("data", "message")).to eq("User updated successfully.")
            expect(json_response.dig("data", "user", "first_name")).to eq("updated name")
            expect(json_response.dig("data", "user", "id")).to eq(user.id)
            expect(response).to have_http_status(:ok)
          end
        end
  
        context "with email already taken" do
          let(:old_user) { FactoryBot.create(:user) }
          let(:email_update_user_params) { { "email": old_user.email } }
  
          before do
            patch "/users/#{user.id}", headers: auth_headers, params: { user: email_update_user_params }
          end
  
          it "does not update already taken email" do
            json_response = JSON.parse(response.body)
            expect(json_response).to have_key("errors")
            
            errors = json_response["errors"]
            expect(errors).to include("email" => ["has already been taken"])
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context "when user does not exists" do 
        before { patch "/users/100001", headers: auth_headers }

        it "should return not found" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "DELETE /destroy" do
    let(:user) { FactoryBot.create(:user) }

    context "when not authenticated" do
      it "should return unauthorized" do
        delete "/users/#{user.id}"

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("error")
        expect(json_response.dig("error")).to eq("Unauthorized")
      end
    end

    context "when authenticated" do
      let(:auth_headers) { { "Authorization" => "Bearere #{user.generate_jwt_token}" } }

      context "when user exists" do
        before { delete "/users/#{user.id}", headers: auth_headers }

        it "should delete the existed user" do
          expect(response).to have_http_status(:no_content)
        end
      end

      context "when user does not exists" do 
        before { delete "/users/100001", headers: auth_headers }
        
        it "should return not found" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end


# NOTE: Whenever a test case runs, it operates within a transaction. Any data added to the database during the test case is rolled back
# after the test completes. For example: Each `it` block represents a test case. If a factory creates a user with ID 1 before a test case,
# and the subsequent(next) `it` block is executed, the code let(:user) { FactoryBot.create(:user) } will run for that test case as well,
# creating a user with a new ID (e.g., 2).

# If you want to observe this behavior, you can use `puts #{user.id}` in the `it` block.


=begin

======== FactoryBot.attributes_for(:user) vs FactoryBot.create(:user)

- `FactoryBot.attributes_for(:user)` returns a hash of attributes that can be used as simulated form data without creating a database record.
- `FactoryBot.create(:user)` creates and saves an instance of the `User` model with generated attributes in the database.


FactoryBot.attributes_for(:user)
=> 
{:first_name=>"Vishal #<#<Class:0x00000001056cd558>:0x00000001056c5240>",
 :last_name=>"Parjapati",
 :email=>"vishal#<#<Class:0x00000001056cd558>:0x00000001056c5240>@maropost.com",
 :password=>"1234"}


FactoryBot.build(:user)
=> 
#<User:0x00000001051ee3c0
 id: nil,
 first_name: "Vishal #<#<Class:0x00000001056cd558>:0x00000001051f6408>",
 last_name: "Parjapati",
 email: "vishal#<#<Class:0x00000001056cd558>:0x00000001051f6408>@maropost.com",
 password_digest: "[FILTERED]",
 created_at: nil,
 updated_at: nil>


 ============ to include()

 .to include("first_name" => ["can't be blank"]): This is the criterion we're checking for. We're using the include matcher to check if the errors hash includes a key-value pair where the key is "first_name" and the value is an array containing the error message ["can't be blank"]

=end 
