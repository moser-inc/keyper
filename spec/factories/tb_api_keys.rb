FactoryGirl.define do
  factory :tb_api_key do
    user
    api_key nil
    password_digest nil
    last_used_at nil
  end
end
