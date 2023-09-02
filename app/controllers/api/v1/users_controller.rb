class Api::V1::UsersController < ApplicationController
  include UserFinder

  before_action :authenticate_user, except: [:login, :create]
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
      if params[:user][:profile_pic].present?
        temp_file = params[:user][:profile_pic].tempfile
  
        # "profile_pic"=>#<ActionDispatch::Http::UploadedFile:0x0000000105016d90 @tempfile=#<Tempfile:/var/folders/t5/962r5pld7vv1lbh2zdqnddtr0000gn/T/RackMultipart20230902-22901-k42nw9.png>, 
        # @content_type="image/png", @original_filename="Screenshot 2023-09-02 at 1.47.27 PM.png", @headers="Content-Disposition: 
        # form-data; name=\"user[profile_pic]\"; filename=\"Screenshot 2023-09-02 at 1.47.27 PM.png\"\r\nContent-Type: image/png\r\n">

        # When a file is uploaded through a form, Rails stores the uploaded file in a temporary location on the server.
        # This temporary file is represented by the tempfile attribute of the uploaded file.

        # params[:user][:profile_pic].tempfile => gives you access to the temporary file that contains the uploaded data.
        # We can use this temporary file to read, process, or manipulate the uploaded data before saving
        # it to a permanent location or attaching it to a model.
  
        # Here, we can't directly pass the params[:user][:profile_pic] as an argument to the Active Job method
        # because this profile_pic is an instance of ActionDispatch::Http::UploadedFile,
        # and Active Job doesn't natively support this argument type for serialization.
        # Instead, we need to pass the file path so that we can read the file using the path
        # and use the temp file information to store the image to S3.
  
        # Enqueue the ImageUploaderJob to process the image upload in the background using Active Job.
        # We pass the path to the temporary file as an argument to the job.
        ImageUploaderJob.perform_later(user.id, temp_file.path)

        # Note: Active Storage may take some time to upload the image to S3, so we use Active Job to execute
        # that process in the background, ensuring a more responsive user experience.
      end
  
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
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end