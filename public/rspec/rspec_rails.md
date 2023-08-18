# rspec-rails

1. Add the rspec-rails gem to your Gemfile:
   
   ```ruby
   gem 'rspec-rails', '~> x.y.z'
   ```
   Replace `x.y.z` with the desired version.

2. Install RSpec by running the generator command:
   
   ```bash
   bundle exec rails generate rspec:install
   ```

3. Generate model specs using RSpec generators. For example, to create model specs for the `User` model:
   
   ```bash
   rails generate rspec:model User
   ```

4. Generate controller specs using RSpec generators. In recent versions of rspec-rails, when generating a controller spec using the `rails generate rspec:controller users` command, the spec file is expected to be created in the `spec/requests` directory, not the `spec/controllers` directory. This shift aligns with the modern focus of controller specs on testing API endpoints and behavior.

5. To run model specs, execute the following command:
   
   ```bash
   rspec spec/models/user_spec.rb
   ```

6. To display detailed backtrace information for any errors during the test run, you can append the `--backtrace` flag to the RSpec command:
   
   ```bash
   rspec spec/models/user_spec.rb --backtrace
   ```

7. Command to run testcases with the format option.

rspec spec/models/user_spec.rb --format documentation