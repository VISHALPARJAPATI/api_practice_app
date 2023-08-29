class Api::V1::UsersController < ApplicationController
  include UserFinder

  before_action :authenticate_user, except: [:login, :create, :show]
  before_action :get_user, only: [:show, :update, :destroy, :update_password]
  
  def index
    users = User.all

    render json: { data: { users: users } }, status: :ok
  end

  # Signup
  # create/register a user
  def create
    user = User.new(user_params)
    if user.save 
      render json: { data: { user: user, message: "User created successfully." } }, status: :ok
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: { user: @user.attributes.merge(profile_pic: @user.profile_pic.url ) } }, status: :ok
  end

  def update
    if @user.update(user_params)
      render json: { data: { user: @user, message: "User updated successfully." } }, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    head :no_content

    # This status code indicates that the server has successfully processed the request, 
    # but there is no content to send in the response. It's often used for successful deletions
    # where you don't need to return any additional data. In this case, you would remove the render statement altogether, 
    # and the response would have a status code of 204.
  end

  # Sign-in
  # this method is responsible for login the user by taking email and password
  def login
    user = User.find_by(email: user_params[:email])
    if user && user.authenticate(user_params[:password])
      token = user.generate_jwt_token

      render json: { token: token }
    else
      render json: { errors: 'Invalid credentials' }, status: :unprocessable_entity
    end
  end

  # logout the user
  # we add the token to the revoked token table such that this token will not be none of use.
  def logout
    token = @authentication_middleware.extract_token(request.env)
    RevokedToken.create(token: token)

    render json: { message: 'Logged out successfully' }
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :profile_pic)
  end
end