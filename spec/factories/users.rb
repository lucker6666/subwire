FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password 'testpw'
    password_confirmation 'testpw'
    confirmed_at Time.now
  end
end
