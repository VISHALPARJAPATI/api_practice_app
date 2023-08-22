require 'rails_helper'

RSpec.describe User, type: :model do
  # NOTE: In the future, we can use the before(:example) block instead of subject to include more complex logic that needs
  # to be executed before each test case and remains accessible across all test cases.

  subject(:user) { FactoryBot.build(:user) }

  # user is not valid, if firstname is blank
  it "should not be valid without a first name" do
    user.first_name = nil
    expect(user).to_not be_valid
  end

  # user is not valid, if email is blank
  it "should not be valid without a email" do
   user.email = nil
    expect(user).to_not be_valid  
  end

  # user is not valid, if password is blank
  it "should not be valid without a password" do
    user.password = nil

    expect(user).to_not be_valid
  end

  # user is not valid, if email is duplicate (has already been taken)
  it "should not be valid for duplicate email" do
    user.save
    duplicate_email_user = User.new(first_name: 'Duplicate email user', email: user.email, password: '1234')

    expect(duplicate_email_user).to_not be_valid
  end

  # full_name instance method, should returns the full_name
  it "should returns the full_name" do
    expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
  end
end

# command to run this particular spec: rspec spec/models/user_spec.rb --format documentation


=begin

====================== subject(:user) { } ========================================================================================

In RSpec, subject is a keyword used to define the main object of focus for testing within a specific describe block. 
It creates an instance that's automatically available in test examples, helping to improve code readability. Importantly, 
the state of the subject instance is isolated for each example. Any modifications made to the subject within one example won't 
impact its state in other examples. 


For example, 

I've created an instance using the `subject` above. In the first testcase/example, I set `first_name` to `nil`, 
but this `nil` state of `first_name` will only persist throughout the execution of the first test case. When the second test 
case runs, the `first_name` will have the value 'John', and it will not be `nil`. This isolation of state ensures that modifications 
within one test case do not affect the state of the `subject` in other test cases.

=end