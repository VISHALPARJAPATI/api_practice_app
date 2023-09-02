class ImageUploaderJob < ApplicationJob
  retry_on attempts: 3

  queue_as :image_upload

  def perform(*args)
    puts ">>>>>> this is an active job >>>>>>>>>>>"

    user_id, file_path = args
    user = User.find user_id
    
    user.profile_pic.attach(io: File.open(file_path), filename: File.basename(file_path))

    raise "Error in image uploading: #{user.errors.full_messages}" if user.errors.any?

    # Optionally, you can remove the temporary file after it's been attached
    File.delete(file_path) if File.exist?(file_path)
  end
end
