FactoryGirl.define do
  factory :user do
    password 'testpw'
    password_confirmation 'testpw'
    confirmed_at Time.now

    # user1: Has instance1 and is no superadmin
    factory :user1 do
      name 'User1'
      email 'example@example.com'
    end

    # user2: Has instance2 and is no superadmin
    factory :user2 do
      name 'User2'
      email 'example2@example.com'
    end

    # user3: Has no instances but is assigned to instance2 and is no superadmin
    factory :user3 do
      name 'User3'
      email 'example@example.com'
    end

    # admin: Has no instances but is assigned to instance2 and is superadmin
    factory :admin do
      name 'Admin'
      email 'admin@example.com'
      is_admin true
    end
  end

  factory :instance do
    # Instance1: Owned by user1 no other users assigned
    factory :instance1 do
      name "Test Instance"
    end

    # Instance2: Owned by user2. User3 and admin are assigned
    factory :instance2 do
      name "Test Instance"
    end
  end

  factory :relationship do
    # Relationship between user1 and instance1
    factory :user1_with_instance do
      association :user, factory: :user1
      association :instance, factory: :instance1
      admin true
    end

    # Relationship between user2 and instance2
    factory :user2_with_instance do
      association :user, factory: :user2
      association :instance, factory: :instance2
      admin true
    end

    # Relationship between user3 and instance2
    factory :user3_with_instance do
      before(:create) {|x| Factory.create(:user2_with_instance) }

      association :user, factory: :user3
      association :instance, factory: :instance3
    end

    # Relationship between user3 and instance2
    factory :admin_with_instance do
      before(:create) {|x| Factory.create(:user2_with_instance) }

      association :user, factory: :admin
      association :instance, factory: :instance2
    end
  end
end
