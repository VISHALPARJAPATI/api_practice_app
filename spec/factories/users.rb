FactoryBot.define do
  factory :user do
    first_name { |n| "Vishal #{n}" }
    last_name { "Parjapati" }
    email { |n| "vishal#{n}@maropost.com" }
    password { "1234" }
  end
end
