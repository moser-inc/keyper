FactoryGirl.define do
  factory :api_key, class: 'Keyper::ApiKey' do
    user
    api_key nil
    password_digest nil
    last_used_at nil
  end
end
