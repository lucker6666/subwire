require 'spec_helper'

describe Notification do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:channel) }
  end

  describe "Mass assignment" do
    it { should_not allow_mass_assignment_of(:channel_id) }
    it { should_not allow_mass_assignment_of(:user_id) }
  end

  describe "Validation" do
    it { should validate_presence_of(:notification_type) }
    it { should validate_presence_of(:href) }
  end

  describe "Respond to" do
    it { should respond_to(:creator) }
    it { should respond_to(:message) }
    it { should respond_to(:read!) }
  end

  describe :method do
    before do
      ActionMailer::Base.deliveries.clear

      @channel = FactoryGirl.create('channel')
      @rels = @channel.relationships

      @mails = []
      @rels.each do |rel|
        @mails << rel.user.email
      end

      data = {
        notification_type: :new_message,
        provokesUser: @rels[1].user,
        subject: "Test Foo!",
        href: "/"
      }

      Notification.notify_all_users(data, @channel, @rels[0].user)
    end

    describe :notify_all_users do
      it "should send some mails" do
        ActionMailer::Base.deliveries.length.should eq(@rels.length - 1)

        ActionMailer::Base.deliveries.each do |mail|
          @mails.should include(mail.to.first)
        end
      end
    end

    describe :avatar_path do#
      before do
        @notification = Notification.find_all_by_user_id(@rels[2].user.id).first
        @user = User.find(@notification.created_by)
      end

      context "while user has not enabled gravatar option" do
        it "should return the avatar path for the respective user" do
          @notification.avatar_path.should eq(@user.avatar.url)
        end
      end

      context "while user has enabled gravatar option" do
        it "should return gravatar path for the respective user" do
          gravatar = Digest::MD5.hexdigest(@user.email.strip.downcase)
          @user.gravatar = gravatar
          @user.password = 'foobar'
          @user.password_confirmation = 'foobar'
          @user.save!

          @notification.avatar_path.should eq('http://www.gravatar.com/avatar/' + gravatar + '?s=30')
        end
      end
    end

    describe :message do
      it "should return a string containing the subject" do
        user = @rels[1].user

        notification = Notification.find_all_by_user_id(user.id).first
        notification.message.should include("Test Foo!")
      end
    end

    describe :read do
      it "should set the notification as read" do
        user = @rels[1].user

        notification = Notification.find_all_by_user_id(user.id).first
        notification.read!

        notification = Notification.find(notification.id)
        notification.is_read.should eq(true)
      end
    end

    describe :find_all_relevant do
      context "while having no notifications" do
        it "should return empty array" do
          channel = FactoryGirl.create('channel')
          user = channel.relationships.first.user

          Notification.destroy_all
          Notification.find_all_relevant(channel, user).should eq([])
        end
      end

      context "while having notifications" do
        it "should return array with notifications" do
          user = @rels[1].user
          notification = Notification.find_all_by_user_id(user.id).first
          Notification.find_all_relevant(@channel, user).should include(notification)
        end
      end
    end
  end
end