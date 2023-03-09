FactoryBot.define do
  factory :user_recipes_share do
    user_id { nil }
    share_email { "MyText" }
    share_user_id { nil }
  end
end
