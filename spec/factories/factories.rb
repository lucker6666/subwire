FactoryGirl.define do
  factory :user do
    password 'testpw'
    password_confirmation 'testpw'
    confirmed_at Time.now

    # user1: Has channel1 and is no superadmin
    factory :user1 do
      name 'User1'
      email 'example@example.com'
    end

    # user2: Has channel2 and is no superadmin
    factory :user2 do
      name 'User2'
      email 'example2@example.com'
    end

    # user3: Has no channels but is assigned to channel2 and is no superadmin
    factory :user3 do
      name 'User3'
      email 'example@example.com'
    end

    # admin: Has no channels but is assigned to channel2 and is superadmin
    factory :admin do
      name 'Admin'
      email 'admin@example.com'
      is_admin true
    end
  end

  factory :channel do
    # channel1: Owned by user1 no other users assigned
    factory :channel1 do |channel|
      name "Test channel"

      after(:create) do |c|
        FactoryGirl.create(:article1, channel: c)
      end
    end

    # channel2: Owned by user2. User3 and admin are assigned
    factory :channel2 do |channel|
      name "Test channel"

      after(:create) do |c|
        FactoryGirl.create(:article1, channel: c)
      end
    end
  end

  factory :relationship do
    # Relationship between user1 and channel1
    factory :user1_with_channel do
      association :user, factory: :user1
      association :channel, factory: :channel1
      admin true
    end

    # Relationship between user2 and channel2
    factory :user2_with_channel do
      association :user, factory: :user2
      association :channel, factory: :channel2
      admin true
    end

    # Relationship between user3 and channel2
    factory :user3_with_channel do
      before(:create) {|x| Factory.create(:user2_with_channel) }

      association :user, factory: :user3
      association :channel, factory: :channel3
    end

    # Relationship between user3 and channel2
    factory :admin_with_channel do
      before(:create) {|x| Factory.create(:user2_with_channel) }

      association :user, factory: :admin
      association :channel, factory: :channel2
    end
  end

  factory :article do
    content "test"

    factory :article1 do
      title "test1"
    end

    factory :article2 do
      title "test2"
    end
  end
end
