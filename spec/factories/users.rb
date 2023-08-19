FactoryBot.define do
  factory :user do
    # Use a sequence to generate unique first names
    sequence(:first_name) { |n| "Vishal #{n}" }

    # Common last name for all users
    last_name { "Parjapati" }

    # Use a sequence to generate unique emails
    sequence(:email) { |n| "vishal#{n}@maropost.com" }

    # Common password for all users
    password { "1234" }
  end
end