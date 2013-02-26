FactoryGirl.define do
  ### User factories

  factory :user do
    password 'testpw'
    password_confirmation 'testpw'
    confirmed_at Time.now
    last_activity Time.now
    name 'User'
    sequence(:email) { |n| "user#{n}@example.com" }

    factory :admin do
      name 'Admin'
      email 'admin@example.com'
      is_admin true
    end
  end


  ### Channel factories

  factory :channel do
    name "Test channel"

    after(:create) do |channel|
      FactoryGirl.create_list(:relationship, 3, channel: channel)
      FactoryGirl.create(:admin_relationship, channel: channel)
      FactoryGirl.create(:message, channel: channel)
    end
  end



  ### Relationship factories

  factory :relationship do
    user
    admin false

    factory :admin_relationship do
      admin true
    end
  end



  ### Message factories

  factory :message do
    content "test"
    title "test"

    after(:create) do |message|
      FactoryGirl.create_list(:comment, 2, message: message, user: message.user)
    end
  end



  ### Comment factories

  factory :comment do
    content "test"
  end
end
