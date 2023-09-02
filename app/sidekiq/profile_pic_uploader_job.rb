class ProfilePicUploaderJob
  include Sidekiq::Job

  def perform(*args)
    puts ">>>>>>>>>>>>> profile pic should be uploaded in the background......."
  end
end
