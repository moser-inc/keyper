FactoryGirl.define do
  factory :tb_api_key do
    spud_user nil
    api_key "MyString"
    password_digest "MyString"
    last_used_at "2016-10-25 17:01:40"
  end
end
