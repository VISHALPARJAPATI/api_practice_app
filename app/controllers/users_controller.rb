class UsersController < ApplicationController
  def index
  end

  def create
    user = User.new user_params
    if user.save 
      render json: { data: { user: user } }, status: :ok
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
  end

  def update
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end