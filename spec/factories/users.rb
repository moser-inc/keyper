FactoryBot.define do
  sequence :username do |n|
    "user-#{n}"
  end
  factory :user do
    username { FactoryBot.generate(:username) }
    password 'password'
    password_confirmation 'password'
  end
end
