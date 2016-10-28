FactoryGirl.define do
  sequence :username do |n|
    "user-#{n}"
  end
  factory :user do
    username { FactoryGirl.generate(:username) }
    password 'password'
    password_confirmation 'password'
  end
end
