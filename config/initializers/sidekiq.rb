# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
config.redis = { url: 'redis://localhost:6379/0' } # Configure the Redis connectio
end

Sidekiq.configure_client do |config|
config.redis = { url: 'redis://localhost:6379/0' }
end