class PasswordResetsController < ActionController::Base
  include UserFinder
  
  before_action :get_user_by_email, only: :send_reset_password_email
  before_action :get_user, only: [:reset_password, :update_password]
  before_action :validate_reset_token, only: :reset_password

  # Sends a reset password email to the user.
  def send_reset_password_email
    UserMailer.send_reset_password_email(@user).deliver_now
    render json: { message: 'A verification email has been sent to you.' }, status: :ok
  end

  # Displays the password reset form.
  def reset_password
    # No action needed here, view rendering takes care of this
  end

  # Updates the user's password after the reset.
  def update_password
    @user = User.find params[:id]

    if @user.update(password: params[:password])
      render plain: 'Password reset successful!'
    else
      render plain: 'Error updating password.'
    end
  end

  private

  def get_user_by_email
    @user = User.find_by(email: params[:email])
    
    unless @user.present?
     render json: { errors: { base: [ "This email is not registered with us." ] } }, status: :unprocessable_entity
    end
  end

  def validate_reset_token
    unless @user.reset_token == params[:token] && Time.current < @user.reset_token_expires_at
      render json: { errors: { base: [ "Invalid token...." ] } }, status: :unprocessable_entity
    end
  end
end