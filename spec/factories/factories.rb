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

    ignore do
      relationships_count 3
    end

    after(:create) do |channel, evaluator|
      FactoryGirl.create_list(:relationship, evaluator.relationships_count, channel: channel)
      FactoryGirl.create(:admin_relationship, channel: channel)
      FactoryGirl.create(:article, channel: channel)
    end
  end



  ### Relationship factories

  factory :relationship do
    user

    factory :admin_relationship do
      admin true
    end
  end



  ### Article factories

  factory :article do
    content "test"
    title "test"
  end
end
