class UsersController < ApplicationController
  before_action :authenticate_user, except: [:login, :create]
  
  def index
    users = User.all

    render json: { data: { users: users } }, status: :ok
  end

  def create
    user = User.new user_params
    if user.save 
      render json: { data: { user: user } }, status: :ok
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def show
  end

  def update
  end

  # this method is responsible for login the user by taking email and password
  def login
    user = User.find_by(email: user_params[:email])
    if user && user.authenticate(user_params[:password])
      # Generate a token with the user's ID
      hmac_secret = Rails.application.secrets.secret_key_base
      exp_time = exp = Time.now.to_i + 4 * 3600 # token will expire after 4 hours
      payload = { user_id: user.id, exp: exp_time }

      token = JWT.encode(payload, hmac_secret, 'HS256')

      render json: { token: token }
    else
      render json: { errors: 'Invalid credentials' }, status: :unprocessable_entity
    end
  end

  def logout

  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end