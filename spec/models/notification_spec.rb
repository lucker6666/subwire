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
    it { should respond_to(:avatar_path) }
    it { should respond_to(:message) }
    it { should respond_to(:read!) }
  end

  describe :notify_all_users do
    before do
      ActionMailer::Base.deliveries.clear

      @channel = FactoryGirl.create('channel');
      @rels = @channel.relationships

      @mails = []
      @rels.each do |rel|
        @mails << rel.user.email
      end

      data = {
        notification_type: :new_article,
        provokesUser: @rels[1].user,
        subject: "Test",
        href: "/"
      }

      Notification.notify_all_users(data, @channel, @rels[0].user)
    end

    it "should send some mails" do
      ActionMailer::Base.deliveries.length.should eq(@rels.length - 1)

      ActionMailer::Base.deliveries.each do |mail|
        @mails.should include(mail.to.first)
      end
    end
  end
end